// Submit this file with other files you created.
// Do not touch port declarations of the module 'CPU'.

// Guidelines
// 1. It is highly recommened to `define opcodes and something useful.
// 2. You can modify modules (except InstMemory, DataMemory, and RegisterFile)
// (e.g., port declarations, remove modules, define new modules, ...)
// 3. You might need to describe combinational logics to drive them into the module (e.g., mux, and, or, ...)
// 4. `include files if required

module CPU(input reset,       // positive reset signal
           input clk,         // clock signal
           output is_halted); // Whehther to finish simulation
  /***** Wire declarations *****/

  wire [31:0] current_pc;
  wire [31:0] next_pc;
  wire [31:0] inst_dout;

  wire [4:0] rs1_in;
  wire [31:0] rs1_dout;
  wire [31:0] rs2_dout;
  wire stall;
  wire ID_is_halted;
  wire ID_mem_read;
  wire ID_mem_to_reg;
  wire ID_mem_write;
  wire ID_alu_src;
  wire ID_write_enable;
  wire ID_pc_to_reg;
  wire [3:0] ID_alu_op;
  wire ID_is_ecall;
  wire [31:0] imm_gen_out;

  wire [31:0] alu_in2;
  wire [31:0] alu_result;

  wire [31:0] dmem_out;

  wire [31:0] rd_din;

  /***** Register declarations *****/
  // You need to modify the width of registers
  // In addition, 
  // 1. You might need other pipeline registers that are not described below
  // 2. You might not need registers described below
  /***** IF/ID pipeline registers *****/
  reg [31:0] IF_ID_inst;           // will be used in ID stage
  /***** ID/EX pipeline registers *****/
  // From the control unit
  reg [3:0] ID_EX_alu_op;   // will be used in EX stage
  reg ID_EX_alu_src;        // will be used in EX stage
  reg ID_EX_mem_write;      // will be used in MEM stage
  reg ID_EX_mem_read;       // will be used in MEM stage
  reg ID_EX_mem_to_reg;     // will be used in WB stage
  reg ID_EX_reg_write;      // will be used in WB stage
  reg ID_EX_is_halted;
  // From others
  reg [31:0] ID_EX_rs1_data;
  reg [31:0] ID_EX_rs2_data;
  reg [31:0] ID_EX_imm;
  reg ID_EX_ALU_ctrl_unit_input;
  reg [4:0] ID_EX_rd;

  /***** EX/MEM pipeline registers *****/
  // From the control unit
  reg EX_MEM_mem_write;     // will be used in MEM stage
  reg EX_MEM_mem_read;      // will be used in MEM stage
  reg EX_MEM_mem_to_reg;    // will be used in WB stage
  reg EX_MEM_reg_write;     // will be used in WB stage
  reg EX_MEM_is_halted;
  // From others
  reg [31:0] EX_MEM_alu_out;
  reg [31:0] EX_MEM_dmem_data;
  reg [4:0] EX_MEM_rd;

  /***** MEM/WB pipeline registers *****/
  // From the control unit
  reg MEM_WB_mem_to_reg;    // will be used in WB stage
  reg MEM_WB_reg_write;     // will be used in WB stage
  reg MEM_WB_rd;
  reg MEM_WB_is_halted;
  // From others
  reg [31:0] MEM_WB_mem_to_reg_src_1;
  reg [31:0] MEM_WB_mem_to_reg_src_2;

  // ---------- Update program counter ----------
  // PC must be updated on the rising edge (positive edge) of the clock.
  PC pc(
    .reset(reset),          // input (Use reset to initialize PC. Initial value must be 0)
    .clk(clk),              // input
    .next_pc(next_pc),      // input
    .current_pc(current_pc) // output
  );

  PC_ADDER pc_adder(
    .current_pc(current_pc), // input
    .stall(stall),           // input
    .next_pc(next_pc)        // output
  );
  
  // ---------- Instruction Memory ----------
  InstMemory imem(
    .reset(reset),     // input
    .clk(clk),         // input
    .addr(current_pc), // input
    .dout(inst_dout)   // output
  );

  // Update IF/ID pipeline registers here
  always @(posedge clk) begin
    if (reset) begin
      IF_ID_inst <= 32'b0;
    end else begin
      IF_ID_inst <= inst_dout;
    end
  end

  // ---------- Register File ----------
  HALTED_MUX halted_mux(
    .rs1(IF_ID_inst[19:15]),
    .is_ecall(is_ecall),
    .rs1_in(rs1_in)
  );

  RegisterFile reg_file (
    .reset(reset),                   // input
    .clk(clk),                       // input
    .rs1(rs1_in),                    // input
    .rs2(IF_ID_inst[24:20]),         // input
    .rd(MEM_WB_rd),                  // input
    .rd_din(rd_din),                 // input
    .write_enable(MEM_WB_reg_write), // input
    .rs1_dout(rs1_dout),             // output
    .rs2_dout(rs2_dout)              // output
  );


  // ---------- Control Unit ----------
  ControlUnit ctrl_unit (
    .opcode(IF_ID_inst[6:0]),        // input
    .mem_read(ID_mem_read),          // output
    .mem_to_reg(ID_mem_to_reg),      // output
    .mem_write(ID_mem_write),        // output
    .alu_src(ID_alu_src),            // output
    .write_enable(ID_write_enable),  // output
    .alu_op(ID_alu_op),              // output
    .is_ecall(ID_is_ecall)           // output (ecall inst)
  );
  
  ALUControlUnit alu_control_unit (
    .opcode(IF_ID_inst[6:0]),
    .funct3(IF_ID_inst[14:12]),
    .funct7(IF_ID_inst[31:25]),
    .alu_op(ID_alu_op)
  );

  HAZARD_DETECTION hazard_detection (
    .current_inst(IF_ID_inst),
    .EX_rd(ID_EX_rd),
    .EX_reg_write(ID_EX_reg_write),
    .MEM_rd(EX_MEM_rd),
    .MEM_reg_write(EX_MEM_reg_write),
    .stall(stall)
  );

  // ---------- Immediate Generator ----------
  ImmediateGenerator imm_gen(
    .inst(IF_ID_inst),        // input
    .imm_gen_out(imm_gen_out) // output
  );

  // Update ID/EX pipeline registers here
  always @(is_ecall, rs1_dout, stall) begin
    if (stall) begin
      ID_is_halted = 0;
    end else if (is_ecall && (rs1_dout == 10)) begin
      ID_is_halted = 1;
    end else begin
      ID_is_halted = 0;
    end
  end

  always @(posedge clk) begin
    if (reset) begin
      ID_EX_alu_src <= 1'b0;
      ID_EX_mem_write <= 1'b0;
      ID_EX_mem_read <= 1'b0;
      ID_EX_mem_to_reg <= 1'b0;
      ID_EX_reg_write <= 1'b0;
      ID_EX_rs1_data <= 32'b0;
      ID_EX_rs2_data <= 32'b0;
      ID_EX_imm <= 32'b0;
      ID_EX_is_halted <= 1'b0;
      ID_EX_alu_op <= 4'b0;
      ID_EX_rd <= 5'b0;
    end else begin
      ID_EX_alu_src <= ID_alu_src;
      ID_EX_mem_write <= ID_mem_write;
      ID_EX_mem_read <= ID_mem_read;
      ID_EX_mem_to_reg <= ID_mem_to_reg;
      ID_EX_reg_write <= ID_write_enable;
      ID_EX_rs1_data <= rs1_dout;
      ID_EX_rs2_data <= rs2_dout;
      ID_EX_imm <= imm_gen_out;
      ID_EX_halted <= ID_is_halted; //TODO Implemented is_halted
      ID_EX_alu_op <= ID_alu_op;
      ID_EX_rd <= IF_ID_inst[11:7];
    end
  end

  // ------ ALU SRC MUX -------
  ALU_SRC_MUX alu_src_mux(
    .rs2_data(ID_EX_rs2_data), // input
    .imm_gen_out(ID_EX_imm),   // input
    .alu_src(ID_EX_alu_src),   // input
    .alu_in2(alu_in2)          // output
  );

  // ---------- ALU ----------
  ALU alu (
    .alu_op(ID_EX_alu_op),     // input
    .alu_in_1(ID_EX_rs1_data), // input  
    .alu_in_2(alu_in2),        // input
    .alu_result(alu_result),   // output
  );

  // Update EX/MEM pipeline registers here
  always @(posedge clk) begin
    if (reset) begin
      EX_MEM_mem_write <= 1'b0;
      EX_MEM_mem_read <= 1'b0;
      EX_MEM_mem_to_reg <= 1'b0;
      EX_MEM_reg_write <= 1'b0;
      EX_MEM_alu_out <= 32'b0;
      EX_MEM_dmem_data <= 32'b0;
      EX_MEM_rd <= 5'b0;
      EX_MEM_is_halted <= 1'b0;
      
    end else begin
      EX_MEM_mem_write <= ID_EX_mem_write;
      EX_MEM_mem_read <= ID_EX_mem_read;
      EX_MEM_mem_to_reg <= ID_EX_mem_to_reg;
      EX_MEM_reg_write <= ID_EX_reg_write;
      EX_MEM_alu_out <= alu_result;
      EX_MEM_dmem_data <= ID_EX_rs2_data;
      EX_MEM_rd <= ID_EX_rd;
      EX_MEM_is_halted <= ID_EX_is_halted;
    end
  end

  // ---------- Data Memory ----------
  DataMemory dmem(
    .reset(reset),                // input
    .clk(clk),                    // input
    .addr(EX_MEM_alu_out),        // input
    .din(EX_MEM_dmem_data),       // input
    .mem_read(EX_MEM_mem_read),   // input
    .mem_write(EX_MEM_mem_write), // input
    .dout(dmem_out)               // output
  );

  // Update MEM/WB pipeline registers here
  always @(posedge clk) begin
    if (reset) begin
      MEM_WB_mem_to_reg <= 1'b0;
      MEM_WB_reg_write <= 1'b0;
      MEM_WB_rd <= 1'b0;
      MEM_WB_mem_to_reg_src_1 <= 32'b0;
      MEM_WB_mem_to_reg_src_2 <= 32'b0;
      MEM_WB_is_halted <= 1'b0;
    end else begin
      MEM_WB_mem_to_reg <= EX_MEM_reg_write;
      MEM_WB_reg_write <= EX_MEM_mem_to_reg;
      MEM_WB_rd <= EX_MEM_rd;
      MEM_WB_mem_to_reg_src_1 <= dmem_out;
      MEM_WB_mem_to_reg_src_2 <= EX_MEM_alu_out;
      MEM_WB_is_halted <= EX_MEM_is_halted;
    end
  end

  // ------- WB MUX ----------
  WB_MUX wb_mux (
    .reg_src1(MEM_WB_mem_to_reg_src_1),
    .reg_src2(MEM_WB_mem_to_reg_src_2),
    .mem_to_reg(MEM_WB_mem_to_reg),
    .rd_din(rd_din)
  );

  always @(posedge clk) begin
    if (reset) begin
      is_halted <= 1'b0;

    end else begin
      is_hatled <= MEM_WB_is_halted;

    end
  end
  
endmodule

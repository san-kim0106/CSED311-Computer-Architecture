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
           output reg is_halted); // Whehther to finish simulation
  /***** Wire declarations *****/

  wire [31:0] current_pc;
  wire [31:0] plus_four_pc;
  wire [31:0] pc_branch;
  wire [31:0] pc_jalr;
  wire [31:0] next_pc;
  wire [31:0] inst_dout;

  wire [4:0] rs1_in;
  wire [31:0] rs1_dout;
  wire [31:0] rs2_dout;
  wire stall;
  wire ID_is_halted;
  wire ID_jal;
  wire ID_jalr;
  wire ID_branch;
  wire ID_mem_read;
  wire ID_mem_to_reg;
  wire ID_mem_write;
  wire ID_alu_src;
  wire ID_is_input_valid;
  wire ID_write_enable;
  wire [1:0] pc_src;
  wire ID_pc_to_reg;
  wire [3:0] ID_alu_op;
  wire ID_is_ecall;
  wire [31:0] imm_gen_out;
  wire [1:0] forward_a;
  wire [1:0] forward_b;

  wire [31:0] alu_in1_forwarding;
  wire [31:0] alu_in2_forwarding;
  wire [31:0] alu_in2;
  wire bcond;
  wire [31:0] alu_result;

  wire is_ready;
  wire is_output_valid;
  wire is_hit;
  wire cache_stall;
  wire [31:0] dmem_out;

  wire [31:0] rd_din;

  /***** Register declarations *****/
  // You need to modify the width of registers
  // In addition, 
  // 1. You might need other pipeline registers that are not described below
  // 2. You might not need registers described below
  /***** IF/ID pipeline registers *****/
  reg [31:0] IF_ID_inst;           // will be used in ID stage
  reg [31:0] IF_ID_pc;
  reg [31:0] IF_ID_plus_four_pc;
  reg IF_ID_bubble;
  /***** ID/EX pipeline registers *****/
  // From the control unit
  reg [31:0] ID_EX_pc;
  reg [31:0] ID_EX_plus_four_pc;
  reg [3:0] ID_EX_alu_op;   // will be used in EX stage
  reg ID_EX_jal;
  reg ID_EX_jalr;
  reg ID_EX_is_input_valid;
  reg ID_EX_branch;
  reg ID_EX_alu_src;        // will be used in EX stage
  reg ID_EX_mem_write;      // will be used in MEM stage
  reg ID_EX_mem_read;       // will be used in MEM stage
  reg ID_EX_mem_to_reg;     // will be used in WB stage
  reg ID_EX_reg_write;      // will be used in WB stage
  reg ID_EX_is_halted;
  // From others
  reg [4:0] ID_EX_rs1;
  reg [4:0] ID_EX_rs2;
  reg [31:0] ID_EX_rs1_data;
  reg [31:0] ID_EX_rs2_data;
  reg [31:0] ID_EX_imm;
  reg ID_EX_ALU_ctrl_unit_input;
  reg [4:0] ID_EX_rd;
  reg [6:0] ID_EX_opcode;

  /***** EX/MEM pipeline registers *****/
  // From the control unit
  reg [31:0] EX_MEM_plus_four_pc;
  reg EX_MEM_is_jal;
  reg EX_MEM_is_jalr;
  reg EX_MEM_is_input_valid;
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
  reg [31:0] MEM_WB_plus_four_pc;
  reg MEM_WB_is_jal;
  reg MEM_WB_is_jalr;
  reg MEM_WB_mem_to_reg;    // will be used in WB stage
  reg MEM_WB_reg_write;     // will be used in WB stage
  reg [4:0] MEM_WB_rd;
  reg MEM_WB_is_halted;
  // From others
  reg [31:0] MEM_WB_mem_to_reg_src_1;
  reg [31:0] MEM_WB_mem_to_reg_src_2;

  // cache wires
  wire is_input_valid;
  wire is_ready;
  wire is_output_valid;
  wire is_hit;

  // ---------- Update program counter ----------
  // PC must be updated on the rising edge (positive edge) of the clock.

  PC_MUX pc_mux(
    .pc_plus_four(plus_four_pc),
    .pc_branch(pc_branch),
    .pc_jalr(alu_result),
    .pc_src(pc_src),

    .next_pc(next_pc)
  );

  PC pc(
    .reset(reset),              // input (Use reset to initialize PC. Initial value must be 0)
    .clk(clk),                  // input
    .stall(stall),              // input
    .cache_stall(cache_stall),  // input
    .next_pc(next_pc),          // input
    .current_pc(current_pc)     // output
  );

  PC_ADDER pc_adder(
    .current_pc(current_pc), // input
    .next_pc(plus_four_pc)   // output
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
      IF_ID_pc <= 32'b0;
      IF_ID_inst <= 32'b0;
      IF_ID_plus_four_pc <= 32'b0;
      IF_ID_bubble <= 1'b0;
    end else if (!stall && !cache_stall) begin
      IF_ID_pc <= current_pc;
      IF_ID_inst <= inst_dout;
      IF_ID_plus_four_pc <= plus_four_pc;

      if (pc_src) begin
        IF_ID_bubble <= 1'b1;
      end else begin
        IF_ID_bubble <= 1'b0;
      end

    end
  end

  // ---------- Register File ----------
  HALTED_MUX halted_mux(
    .rs1(IF_ID_inst[19:15]),
    .is_ecall(ID_is_ecall),
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
  HATLED halted(
    .is_ecall(ID_is_ecall),
    .rs1_dout(rs1_dout),
    .stall(stall),
    .is_halted(ID_is_halted)
  );

  ControlUnit ctrl_unit (
    .opcode(IF_ID_inst[6:0]),        // input
    .stall(stall),                   // input
    .bubble(IF_ID_bubble),           // input
    .is_halted(ID_EX_is_halted),     // input
    .pc_src(pc_src),
    .is_input_valid(ID_is_input_valid),
    .is_jal(ID_jal),
    .is_jalr(ID_jalr),
    .branch(ID_branch),
    .mem_read(ID_mem_read),          // output
    .mem_to_reg(ID_mem_to_reg),      // output
    .mem_write(ID_mem_write),        // output
    .alu_src(ID_alu_src),            // output
    .write_enable(ID_write_enable),  // output
    .is_ecall(ID_is_ecall)           // output (ecall inst)
  );
  
  ALUControlUnit alu_control_unit (
    .opcode(IF_ID_inst[6:0]),
    .funct3(IF_ID_inst[14:12]),
    .funct7(IF_ID_inst[31:25]),
    .alu_op(ID_alu_op)
  );

  PC_SRC pc_src_module(
    .bcond(bcond),
    .is_jal(ID_EX_jal),
    .is_jalr(ID_EX_jalr),
    .pc_src(pc_src)
  );

  HAZARD_DETECTION hazard_detection (
    .current_inst(IF_ID_inst),
    .dist1_rd(ID_EX_rd),
    .dist1_reg_write(ID_EX_reg_write),
    .dist1_is_load(ID_EX_mem_read),
    .dist2_rd(EX_MEM_rd),
    .dist2_reg_write(EX_MEM_reg_write),
    .stall(stall)
  );

  // ---------- Immediate Generator ----------
  ImmediateGenerator imm_gen(
    .inst(IF_ID_inst),        // input
    .imm_gen_out(imm_gen_out) // output
  );

  // Update ID/EX pipeline registers here
  always @(posedge clk) begin
    if (reset) begin
      ID_EX_pc <= 32'b0;
      ID_EX_plus_four_pc <= 32'b0;
      ID_EX_alu_src <= 1'b0;
      ID_EX_jal <= 1'b0;
      ID_EX_jalr <= 1'b0;
      ID_EX_is_input_valid <= 1'b0;
      ID_EX_branch <= 1'b0;
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
      ID_EX_rs1 <= 5'b0;
      ID_EX_rs2 <= 5'b0;
      ID_EX_opcode <= 6'b0;
    end else if (!stall && !cache_stall) begin
      ID_EX_pc <= IF_ID_pc;
      ID_EX_plus_four_pc <= IF_ID_plus_four_pc;
      ID_EX_alu_src <= ID_alu_src;
      ID_EX_jal <= ID_jal;
      ID_EX_jalr <= ID_jalr;
      ID_EX_is_input_valid <= ID_is_input_valid;
      ID_EX_branch <= ID_branch;
      ID_EX_mem_write <= ID_mem_write;
      ID_EX_mem_read <= ID_mem_read;
      ID_EX_mem_to_reg <= ID_mem_to_reg;
      ID_EX_reg_write <= ID_write_enable;
      ID_EX_rs1_data <= rs1_dout;
      ID_EX_rs2_data <= rs2_dout;
      ID_EX_imm <= imm_gen_out;
      ID_EX_is_halted <= ID_is_halted;
      ID_EX_alu_op <= ID_alu_op;
      ID_EX_rd <= IF_ID_inst[11:7];
      ID_EX_rs1 <= IF_ID_inst[19:15];
      ID_EX_rs2 <= IF_ID_inst[24:20];
      ID_EX_opcode <= IF_ID_inst[6:0];
    end

    if (stall && !cache_stall) begin
      ID_EX_rd <= 5'b0;
      ID_EX_branch <= 1'b0;
      ID_EX_mem_write <= 1'b0;
      ID_EX_mem_read <= 1'b0;
      ID_EX_mem_to_reg <= 1'b0;
      ID_EX_reg_write <= 1'b0;
      ID_EX_is_halted <= 1'b0;
      ID_EX_is_input_valid <= 1'b0;
    end

  end

  FORWARDING_UNIT forwarding_unit(
    .opcode(ID_EX_opcode),
    .rs1(ID_EX_rs1),
    .rs2(ID_EX_rs2),

    .dist1_rd(EX_MEM_rd),
    .dist1_reg_write(EX_MEM_reg_write),

    .dist2_rd(MEM_WB_rd),
    .dist2_reg_write(MEM_WB_reg_write),

    .forward_a(forward_a),
    .forward_b(forward_b)
  );

  // ------ ALU SRC MUX -------
  ALU_INPUT_MUX alu_input_mux_rs1(
    .no_forwarding(ID_EX_rs1_data),
    .dist1_forwarding(EX_MEM_alu_out),
    .dist2_forwarding(rd_din),
    .selector(forward_a),
    .alu_in(alu_in1_forwarding)
  );

  ALU_INPUT_MUX alu_input_mux_rs2(
    .no_forwarding(ID_EX_rs2_data),
    .dist1_forwarding(EX_MEM_alu_out),
    .dist2_forwarding(rd_din),
    .selector(forward_b),
    .alu_in(alu_in2_forwarding)
  );

  ALU_SRC_MUX alu_src_mux(
    .rs2_data(alu_in2_forwarding), // input
    .imm_gen_out(ID_EX_imm),       // input
    .alu_src(ID_EX_alu_src),       // input
    .alu_in2(alu_in2)              // output
  );

  PC_IMM_ADDER pc_imm_adder(
    .current_pc(ID_EX_pc),
    .imm(ID_EX_imm),
    .pc_branch(pc_branch)
  );

  // ---------- ALU ----------
  ALU alu (
    .alu_op(ID_EX_alu_op),      // input
    .in_1(alu_in1_forwarding),  // input
    .in_2(alu_in2),             // input
    .alu_out(alu_result),       // output
    .bcond(bcond)               // output
  );

  // Update EX/MEM pipeline registers here
  always @(posedge clk) begin
    if (reset) begin
      EX_MEM_plus_four_pc <= 32'b0;
      EX_MEM_mem_write <= 1'b0;
      EX_MEM_is_jal <= 1'b0;
      EX_MEM_is_jalr <= 1'b0;
      EX_MEM_is_input_valid <= 1'b0;
      EX_MEM_mem_read <= 1'b0;
      EX_MEM_mem_to_reg <= 1'b0;
      EX_MEM_reg_write <= 1'b0;
      EX_MEM_alu_out <= 32'b0;
      EX_MEM_dmem_data <= 32'b0;
      EX_MEM_rd <= 5'b0;
      EX_MEM_is_halted <= 1'b0;
      
    end else if (!cache_stall) begin
      EX_MEM_plus_four_pc <= ID_EX_plus_four_pc;
      EX_MEM_is_jal <= ID_EX_jal;
      EX_MEM_is_jalr <= ID_EX_jalr;
      EX_MEM_is_input_valid <= ID_EX_is_input_valid;
      EX_MEM_mem_write <= ID_EX_mem_write;
      EX_MEM_mem_read <= ID_EX_mem_read;
      EX_MEM_mem_to_reg <= ID_EX_mem_to_reg;
      EX_MEM_reg_write <= ID_EX_reg_write;
      EX_MEM_alu_out <= alu_result;
      EX_MEM_dmem_data <= alu_in2_forwarding;
      EX_MEM_rd <= ID_EX_rd;
      EX_MEM_is_halted <= ID_EX_is_halted;
    end
  end

  // ---------- Data Memory ----------
  Cache cache(
    .reset(reset),
    .clk(clk),
    .is_input_valid(EX_MEM_is_input_valid), 
    .addr(EX_MEM_alu_out),
    .mem_read(EX_MEM_mem_read),
    .mem_write(EX_MEM_mem_write),
    .din(EX_MEM_dmem_data),
    .is_ready(is_ready),
    .is_output_valid(is_output_valid),
    .dout(dmem_out),
    .is_hit(is_hit)
  );

  CACHE_STALL Cache_Stall(
    .is_ready(is_ready),
    .is_output_valid(is_output_valid),
    .is_hit(is_hit),
    .cache_stall(cache_stall)
  );

  // Update MEM/WB pipeline registers here
  always @(posedge clk) begin
    if (reset) begin
      MEM_WB_plus_four_pc <= 32'b0;
      MEM_WB_mem_to_reg <= 1'b0;
      MEM_WB_is_jal <= 1'b0;
      MEM_WB_is_jalr <= 1'b0;
      MEM_WB_reg_write <= 1'b0;
      MEM_WB_rd <= 1'b0;
      MEM_WB_mem_to_reg_src_1 <= 32'b0;
      MEM_WB_mem_to_reg_src_2 <= 32'b0;
      MEM_WB_is_halted <= 1'b0;
    end else if (!cache_stall) begin
      MEM_WB_plus_four_pc <= EX_MEM_plus_four_pc;
      MEM_WB_is_jal <= EX_MEM_is_jal;
      MEM_WB_is_jalr <= EX_MEM_is_jalr;
      MEM_WB_mem_to_reg <= EX_MEM_mem_to_reg;
      MEM_WB_reg_write <= EX_MEM_reg_write;
      MEM_WB_rd <= EX_MEM_rd;
      MEM_WB_mem_to_reg_src_1 <= inst_dout;
      MEM_WB_mem_to_reg_src_2 <= EX_MEM_alu_out;
      MEM_WB_is_halted <= EX_MEM_is_halted;
    end
  end

  // ------- WB MUX ----------
  WB_MUX wb_mux (
    .reg_src1(MEM_WB_mem_to_reg_src_1),
    .reg_src2(MEM_WB_mem_to_reg_src_2),
    .plus_four_pc(MEM_WB_plus_four_pc),
    .is_jal(MEM_WB_is_jal),
    .is_jalr(MEM_WB_is_jalr),
    .mem_to_reg(MEM_WB_mem_to_reg),
    .rd_din(rd_din)
  );

  always @(posedge clk) begin
    if (reset) begin
      is_halted = 1'b0;

    end else if (!cache_stall) begin
      is_halted = MEM_WB_is_halted;

    end
  end

  // -------- Cache -----------
  // TODO : connect cache
  Cache cache (
    .reset(),               // input
    .clk(),                 // input

    .is_input_valid(),      // input
    .addr(),                // input
    .mem_read(),            // input
    .mem_write(),           // input
    .din(),                 // input

    .is_ready(),            // output
    .is_output_valid(),     // output
    .dout(),                // output
    .is_hit()               // output
  );
  
endmodule

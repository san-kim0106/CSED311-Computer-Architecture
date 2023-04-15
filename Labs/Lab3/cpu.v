// Submit this file with other files you created.
// Do not touch port declarations of the module 'CPU'.

// Guidelines
// 1. It is highly recommened to `define opcodes and something useful.
// 2. You can modify the module.
// (e.g., port declarations, remove modules, define new modules, ...)
// 3. You might need to describe combinational logics to drive them into the module (e.g., mux, and, or, ...)
// 4. `include files if required

module CPU(input reset,       // positive reset signal
           input clk,         // clock signal
           output is_halted); // Whehther to finish simulation
  /***** Wire declarations *****/

  wire [31:0] current_pc;
  wire [31:0] next_pc;

  wire [31:0] addr;
  wire [31:0] dout;

  wire [31:0] rs1_dout;
  wire [31:0] rs2_dout;

  wire IorD;
  wire write_enable;
  wire mem_read;
  wire mem_write;

  /***** Register declarations *****/
  reg [31:0] IR; // instruction register
  reg [31:0] MDR; // memory data register
  reg [31:0] A; // Read 1 data register
  reg [31:0] B; // Read 2 data register
  reg [31:0] ALUOut; // ALU output register
  // Do not modify and use registers declared above.

  wire[31:0] alu_in1;
  wire[31:0] alu_in2;
  wire[31:0] alu_out;

  wire [31:0] imm_gen_out;

  wire [31:0] rd_din;




  always @(posedge clk) begin
    IR <= dout;
    MDR <= dout;
    A <= rs1_dout;
    B <= rs2_dout;
    ALUOut <= alu_out;
    
  end

  // ---------- Update program counter ----------
  // PC must be updated on the rising edge (positive edge) of the clock.
  PC pc(
    .reset(reset),       // input (Use reset to initialize PC. Initial value must be 0)
    .clk(clk),         // input
    .next_pc(next_pc),     // input
    .current_pc(current_pc)   // output
  );

  MEM_MUX mem_mux(
    .current_pc(current_pc),
    .d_addr(ALUOut), //TODO
    .IorD(IorD),
    .addr(addr)
  );

  REG_MUX reg_mux(
    .alu_out(ALUOut),
    .dout(MDR),
    .MemtoReg(), //TODO : connect to ctrl unit
    .reg_write_data(rd_din)
  );

  ALU_SRC_A_MUX alu_src_a_mux(
    .current_pc(current_pc),
    .rs1_out(A),
    .ALUSrcA(), //TODO : connect to ctrl unit
    .alu_in1(alu_in1)
  );

  ALU_SRC_B_MUX alu_src_b_mux(
    .rs2_out(B),
    .imm_gen_out(imm_gen_out),
    .ALUSrcB0(), //TODO : connect to ctrl unit
    .ALUSrcB1(), //TODO : connect to ctrl unit
    .alu_in2(alu_in2)
  );

  PC_MUX pc_mux(
    .alu_out(alu_out),
    .alu_out_reg(ALUOut),
    .PCSource(), //TODO : connect to ctrl unit
    .next_pc(next_pc)
  );

  // ---------- Register File ----------
  RegisterFile reg_file(
    .reset(reset),                  // input
    .clk(clk),                      // input
    .rs1(IR[19:15]),                // input
    .rs2(IR[24:20]),                // input
    .rd(IR[11:7]),                  // input
    .rd_din(rd_din),                      //TODO input
    .write_enable(write_enable),    // input
    .rs1_dout(rs1_dout),            // output
    .rs2_dout(rs2_dout)             // output
  );

  // ---------- Memory ----------
  Memory memory(
    .reset(reset),                 // input
    .clk(clk),                     // input
    .addr(addr),                   // input
    .din(B),                       // input
    .mem_read(mem_read),           // input
    .mem_write(mem_write),         // input
    .dout(dout)                    // output
  );

  // ---------- Control Unit ----------
  ControlUnit ctrl_unit(
    .part_of_inst(),  // input
    .is_jal(),        // output
    .is_jalr(),       // output
    .branch(),        // output
    .mem_read(),      // output
    .mem_to_reg(),    // output
    .mem_write(),     // output
    .alu_src(),       // output
    .write_enable(),  // output
    .pc_to_reg(),     // output
    .is_ecall()       // output (ecall inst)
  );

  // ---------- Immediate Generator ----------
  ImmediateGenerator imm_gen(
    .part_of_inst(IR[31:0]),  // input
    .imm_gen_out(imm_gen_out)    // output
  );

  // ---------- ALU Control Unit ----------
  ALUControlUnit alu_ctrl_unit(
    .part_of_inst(),  // input TODO : op[6:0] or Instruction[30, 14-12]?
    .alu_op()         // output
  );

  // ---------- ALU ----------
  ALU alu(
    .alu_op(),      // input TODO : connect to alu ctrl unit
    .alu_in_1(alu_in1),    // input  
    .alu_in_2(alu_in2),    // input
    .alu_result(alu_out),  // output

    .alu_bcond()     // output TODO
  );

endmodule

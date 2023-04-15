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

  wire [31:0] mem_addr;
  wire [31:0] mem_dout;

  wire [31:0] imm_gen_out;

  wire [31:0] rs1_dout;
  wire [31:0] rs2_dout;
  wire [31:0] rd_din;

  wire iord;
  wire write_enable;
  wire mem_read;
  wire mem_write;
  wire mem_to_reg;
  wire pc_write_cond;
  wire pc_write;
  wire ir_write;
  wire reg_write;
  wire alu_src_a;
  wire [1:0] alu_src_b;
  wire [1:0] alu_op;
  wire pc_source;
  wire [1:0] addr_clt;

  wire [31:0] alu_in1;
  wire [31:0] alu_in2;
  wire [31:0] alu_out;
  wire [3:0] _alu_op;

  /***** Register declarations *****/
  reg [31:0] IR; // instruction register
  reg [31:0] MDR; // memory data register
  reg [31:0] A; // Read 1 data register
  reg [31:0] B; // Read 2 data register
  reg [31:0] ALUOut; // ALU output register
  // Do not modify and use registers declared above.

  reg [3:0] current_state;
  wire [3:0] next_state;
  wire [3:0] state_plus_one;
  wire [3:0] rom1_out;
  wire [3:0] rom2_out;
  wire [1:0] addr_clt;

  always @(posedge) begin
    if (!iord && ir_write) IR <= mem_dout;
    if (iord) MDR <= mem_dout;
    A <= rs1_dout;
    B <= rs2_dout;
    ALUOut <= alu_out;
  end

  // ---------- Update program counter ----------
  // PC must be updated on the rising edge (positive edge) of the clock.
  PC pc(
    .reset(reset),          // input (Use reset to initialize PC. Initial value must be 0)
    .clk(clk),              // input
    .next_pc(next_pc),      // input
    .current_pc(current_pc) // output
  );

  MEM_MUX mem_mux(
    .current_pc(current_pc),  // input
    .d_addr(ALUOut),          // input
    .IorD(IorD),              // input
    .addr(mem_addr)           // output
  );

  // ---------- Memory ----------
  Memory memory(
    .reset(reset),                 // input
    .clk(clk),                     // input
    .addr(mem_addr),               // input
    .din(B),                       // input
    .mem_read(mem_read),           // input
    .mem_write(mem_write),         // input
    .dout(mem_dout)                // output
  );

  REG_MUX reg_mux(
    .alu_out(ALUOut),        // input
    .dout(MDR),              // input
    .mem_to_reg(mem_to_reg), // input
    .reg_write_data(rd_din)  // output
  );

  // ---------- Register File ----------
  RegisterFile reg_file(
    .reset(reset),                  // input
    .clk(clk),                      // input
    .rs1(IR[19:15]),                // input
    .rs2(IR[24:20]),                // input
    .rd(IR[11:7]),                  // input
    .rd_din(rd_din),                // input
    .write_enable(write_enable),    // input
    .rs1_dout(rs1_dout),            // output
    .rs2_dout(rs2_dout)             // output
  );

  // ---------- Control Unit ----------
  NEXT_STATE_ADDER next_state_adder(
    .current_state(current_state),
    .next_state(state_plus_one)
  );

  ROM1 rom1(
    .opcode(IR[6:0]),
    .rom1_out(rom1_out)
  );

  ROM2 rom2(
    .opcode(IR[6:0]),
    .rom2_out(rom2_out)
  );

  NEXT_STATE_MUX next_state_mux(
    .adder_out(state_plus_one),
    .rom1_out(rom1_out),
    .rom2_out(rom2_out),
    .addr_clt(addr_clt),
    .next_state(next_state)
  );

  STATE_REGISTER state_register(
    .clk(clk),
    .next_state(next_state),
    .current_state(current_state)
  );

  CONTROL_SIGNALS control_signals(
    .current_state(current_state),
    .pc_write_cond(pc_write_cond),,
    .pc_write(pc_write),
    .iord(iord),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .ir_write(ir_write),
    .mem_to_reg(mem_to_reg),
    .reg_write(reg_write),
    .alu_src_a(alu_src_a),
    .alu_src_b(alu_src_b),
    .alu_op(alu_op),
    .pc_source(pc_source),
    .addr_clt(addr_clt)
  );


  // ---------- Immediate Generator ----------
  ImmediateGenerator imm_gen(
    .inst(IR),                // input
    .imm_gen_out(imm_gen_out) // output
  );

  // ---------- ALU Control Unit ----------
  ALUControlUnit alu_ctrl_unit(
    .alu_op(alu_op),  // input
    .funct3(IR[14:12]),
    .funct7(IR[31:25]),
    ._alu_op(_alu_op)    // output
  );

  
  ALU_SRC_A_MUX alu_src_a_mux(
    .current_pc(current_pc),
    .rs1_out(A),
    .ALUSrcA(alu_src_a),
    .alu_in1(alu_in1)
  );

    ALU_SRC_B_MUX alu_src_b_mux(
    .rs2_out(B),
    .imm_gen_out(imm_gen_out),
    .ALUSrcB0(alu_src_b[0]),
    .ALUSrcB1(alu_src_b[1]),
    .alu_in2(alu_in2)
  );

  // ---------- ALU ----------
  ALU alu(
    .alu_op(_alu_op),      // input
    .alu_in_1(alu_in1),    // input  
    .alu_in_2(alu_in2),    // input
    .alu_result(alu_out),  // output
    .alu_bcond()           // TODO: output
  );

  PC_MUX pc_mux(
    .alu_out(alu_out),
    .alu_out_reg(ALUOut),
    .PCSource(pc_source),
    .next_pc(next_pc)
  );

endmodule

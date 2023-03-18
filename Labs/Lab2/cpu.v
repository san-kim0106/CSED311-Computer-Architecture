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
    wire [31:0] inst;

    wire [31:0] rs1_out;
    wire [31:0] rs2_out;
    wire [31:0] rd;
    wire [31:0] rd_din;

    wire [31:0] imm_gen_out;

    wire[3:0] alu_op;
    wire[31:0] alu_in2;
    wire[31:0] alu_out;

    // Control Wires
    wire write_enable;
    wire is_jal;
    wire is_jalr;
    wire branch;
    wire mem_read;
    wire mem_to_reg;
    wire mem_write;
    wire alu_src;
    wire write_enable;
    wire pc_to_reg;
    wire is_ecall;

    wire bcond;


    /***** Register declarations *****/

// ---------- Update program counter ----------
// PC must be updated on the rising edge (positive edge) of the clock.
    PC pc(
        .reset(reset),            // input (Use reset to initialize PC. Initial value must be 0)
        .clk(clk),                // input
        .next_pc(next_pc),        // input
        .current_pc(current_pc)   // output
    );

    nextPC next_PC(
        .current_pc(current_pc), // input
        .next_pc(next_pc) // output
    );

    // ---------- Instruction Memory ----------
    InstMemory imem(
        .reset(reset), // input
        .clk(clk), // input
        .addr(current_pc), // input
        .inst(inst) // output
    );

    // ---------- Register File ----------
    RegisterFile reg_file (
        .reset(reset), // input
        .clk(clk), // input
        .rs1(inst[19:15]), // input
        .rs2(inst[24:20]), // input
        .rd(inst[11:7]), // input
        .rd_din(alu_out), // input //* Fix this to rd_din after implementing MUX
        .write_enable(write_enable), // input
        .is_ecall(is_ecall), // input
        .rs1_dout(rs1_out), // output
        .rs2_dout(rs2_out), // output
        .is_halted(is_halted)
    );


    // ---------- Control Unit ----------
    ControlUnit ctrl_unit (
        .opcode(inst[6:0]),  // input
        .is_jal(is_jal),        // output
        .is_jalr(is_jalr),       // output
        .branch(branch),        // output
        .mem_read(mem_read),      // output
        .mem_to_reg(mem_to_reg),    // output
        .mem_write(mem_write),     // output
        .alu_src(alu_src),       // output
        .write_enable(write_enable),     // output
        .pc_to_reg(pc_to_reg),     // output
        .is_ecall(is_ecall)       // output (ecall inst)
    );

    // ---------- Immediate Generator ----------
    ImmediateGenerator imm_gen(
        .inst(inst),  // input
        .imm_gen_out(imm_gen_out)    // output
    );

    // ---------- ALU Control Unit ----------
    ALUControlUnit alu_ctrl_unit (
        .opcode(inst[6:0]),        // input
        .funct3(inst[14:12]),        // input
        .funct7(inst[31:25]),        // input
        .alu_op(alu_op)         // output
    );

    // ---------- ALU INPUT MUX ----------
    ALU_MUX alu_mux(
        .rs2_out(rs2_out), // input
        .imm_gen_out(imm_gen_out), // input
        .alu_src(alu_src), // input
        .alu_in2(alu_in2) // output
    );

    // ---------- ALU ----------
    ALU alu (
        .alu_op(alu_op), // input
        .in_1(rs1_out), // input  
        .in_2(alu_in2), // input
        .out(alu_out), // output
        .bcond(bcond) // output
    );

    // ---------- Data Memory ----------
    DataMemory dmem(
        .reset(reset),      // input
        .clk(clk),        // input
        .addr(alu_out),       // input
        .din(rs2_out),        // input
        .mem_read(mem_read),   // input
        .mem_write(mem_write),  // input
        .dout(rd_din)        // output
    );
endmodule

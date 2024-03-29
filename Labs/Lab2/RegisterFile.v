<<<<<<< HEAD
module RegisterFile(input reset,
                    input clk,

                    input [4:0] rs1,          // source register 1
                    input [4:0] rs2,          // source register 2

                    input [4:0] rd,           // destination register
                    input [31:0] rd_din,      // input data for rd
                    input write_enable,          // RegWrite signal

                    input is_ecall, // ECALL control signal

                    output reg [31:0] rs1_dout, // output of rs 1
                    output reg [31:0] rs2_dout, // output of rs 2
                    output reg is_halted); 
    integer i;
    // Register file
    reg [31:0] rf[0:31];

    // TODO
    // Asynchronously read register file
    // Synchronously write data to the register file
    always @(rs1, rs2) begin
        // Combinational Logic for READING DATA
        rs1_dout = rf[rs1]; //! Double check syntax
        rs2_dout = rf[rs2]; //! Double check syntax
    end

    always @(is_ecall) begin
        // $display("GPR[0] == %d", rf[0]);  //! FOR DEBUGGING
        // $display("GPR[17] == %d", rf[17]);  //! FOR DEBUGGING
        if (rf[17] == 10) begin
            is_halted = 1;
        end
    end

    always @(posedge clk) begin
        // Sequential Logic for WRITING DATA
        if (write_enable && rd != 0) begin
            // $display("REG IDX: %d | WRITE DATA: %d", rd, rd_din); //! FOR DEBUGGING
            rf[rd] = rd_din;
        end
    end

    // Initialize register file (do not touch)
    always @(posedge clk) begin
    // Reset register file
        if (reset) begin
            for (i = 0; i < 32; i = i + 1)
                rf[i] = 32'b0;
            rf[2] = 32'h2ffc; // stack pointer
        end
    end
endmodule
=======
module RegisterFile(input reset,
                    input clk,

                    input [4:0] rs1,          // source register 1
                    input [4:0] rs2,          // source register 2

                    input [4:0] rd,           // destination register
                    input [31:0] rd_din,      // input data for rd
                    input write_enable,          // RegWrite signal

                    input is_ecall, // ECALL control signal

                    output reg [31:0] rs1_dout, // output of rs 1
                    output reg [31:0] rs2_dout, // output of rs 2
                    output reg is_halted); 
    integer i;
    // Register file
    reg [31:0] rf[0:31];

    // TODO
    // Asynchronously read register file
    // Synchronously write data to the register file
    always @(rs1, rs2) begin
        // Combinational Logic for READING DATA
        rs1_dout = rf[rs1]; //! Double check syntax
        rs2_dout = rf[rs2]; //! Double check syntax
    end

    always @(is_ecall) begin
        // $display("GPR[0] == %d", rf[0]);  //! FOR DEBUGGING
        // $display("GPR[17] == %d", rf[17]);  //! FOR DEBUGGING
        if (rf[17] == 10) begin
            is_halted = 1;
        end
    end

    always @(posedge clk) begin
        // Sequential Logic for WRITING DATA
        if (write_enable && rd != 0) begin
            // $display("REG IDX: %d | WRITE DATA: %d", rd, rd_din); //! FOR DEBUGGING
            rf[rd] = rd_din;
        end
    end

    // Initialize register file (do not touch)
    always @(posedge clk) begin
    // Reset register file
        if (reset) begin
            for (i = 0; i < 32; i = i + 1)
                rf[i] = 32'b0;
            rf[2] = 32'h2ffc; // stack pointer
        end
    end
endmodule
>>>>>>> 8d624cd1ac5eb7437f38dcdef4afa3f13b2bafec

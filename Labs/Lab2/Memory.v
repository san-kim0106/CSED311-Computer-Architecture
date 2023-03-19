module InstMemory #(parameter MEM_DEPTH = 1024) (input reset,
                                                 input clk,
                                                 input [31:0] addr,   // address of the instruction memory
                                                 output reg [31:0] inst); // instruction at addr
    integer i;
    // Instruction memory
    reg [31:0] mem[0:MEM_DEPTH - 1];
    // Do not touch imem_addr
    wire [31:0] imem_addr;
    assign imem_addr = {2'b00, addr >> 2};

    // TODO
    // Asynchronously read instruction from the memory 
    // (use imem_addr to access memory)
    always @(addr) begin // Combinational Logic for Instruction Fetch
        i = addr / 4;
        inst = mem[i]; //* Double check: addr is a 32-bit number but is used as an index
        // $display("inst: %d | i: %d", inst, i); //! FOR DEBUGGING
    end

    // Initialize instruction memory (do not touch except path)
    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < MEM_DEPTH; i = i + 1)
                mem[i] = 32'b0;
            // Provide path of the file including instructions with binary format
            $readmemh("C:\\Users\\sany0\\OneDrive\\Desktop\\CSED311-Computer-Architecture\\Labs\\Lab2\\student_tb\\test_text.txt", mem);
        end
    end

endmodule

module DataMemory #(parameter MEM_DEPTH = 16384) (input reset,
                                                  input clk,
                                                  input [31:0] addr,    // address of the data memory
                                                  input [31:0] din,     // data to be written
                                                  input mem_read,       // is read signal driven?
                                                  input mem_write,      // is write signal driven?
                                                  output reg [31:0] mem_out);  // output of the data memory at addr
    integer i;
    // Data memory
    reg [31:0] mem[0: MEM_DEPTH - 1];
    // Do not touch dmem_addr
    wire [31:0] dmem_addr;
    assign dmem_addr = {2'b00, addr >> 2};

    // TODO
    // Asynchrnously read data from the memory --> Combinational Logic
    // Synchronously write data to the memory --> Sequential Logic (clk signal)
    // (use dmem_addr to access memory)

    always @(addr, mem_read) begin
        // Combinational Logic for READING DATA
        if (mem_read) begin
            mem_out = mem[dmem_addr];
            // $display("LOAD IDX: %d | LOAD VALUE: %d", dmem_addr, mem_out); //! FOR DEBUGGING
        end
    end

    always @(posedge clk) begin
        // Sequential Logic for WRITING DATA
        if (mem_write) begin
            // $display("STORE IDX: %d | STORE VALUE: %d", dmem_addr, din); //! FOR DEBUGGING
            mem[dmem_addr] = din;
        end
    end

    // Initialize data memory (do not touch)
    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < MEM_DEPTH; i = i + 1)
                mem[i] = 32'b0;
        end
    end
endmodule



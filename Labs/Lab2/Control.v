// Implementation ControlUnit

module ControlUnit (input [6:0] opcode,
                    output RegWrie,
                    output ALUSrc,
                    output MemRead,
                    output Memwrite,
                    output MemtoReg,
                    output PCtoReg,
                    output PCSrc1,
                    output PCSrc2);
    
    if (opcode ...) begin
        // TODO: RegWrite
    end else if (opcode... ) begin
        // TODO: ALUSrc
    end else if (opcode... ) begin
        // TODO: MemRead
    end else if (opcode... ) begin
        // TODO: MemWrite
    end else if (opcode... ) begin
        // TODO: MemtoReg
    end else if (opcode... ) begin
        // TODO: PCtoReg
    end else if (opcode... ) begin
        // TODO: PCSrc1
    end else if (opcode... ) begin
        // TODO: PCSrc2
    end

endmodule
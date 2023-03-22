`include "ALUop.v"

module ALU (input[3:0] alu_op,
            input[31:0] in_1,
            input[31:0] in_2,
            output reg [31:0] alu_out,
            output reg bcond);

	always @(in_1, in_2) begin
		case (alu_op)
			`FUNC_ADD: begin
				alu_out = in_1 + in_2; 
				bcond = 0;
			end

			`FUNC_SUB: begin
				alu_out = in_1 - in_2; 
				bcond = 0;
			end

			`FUNC_JALR: begin
				alu_out = (in_1 + in_2) & 32'hfffffffe; 
				bcond = 0;
			end
            
			`FUNC_NOT: begin 
				alu_out = ~in_1; 
				bcond = 0;
			end
 
			`FUNC_AND: begin
				alu_out = in_1 & in_2; 
				bcond = 0;
			end

			`FUNC_OR: begin
				alu_out = in_1 | in_2; 
				bcond = 0;
			end

			`FUNC_XOR: begin
				alu_out = in_1 ^ in_2; 
				bcond = 0;
			end

			`FUNC_LLS: begin
				alu_out = in_1 << in_2[4:0];
				bcond = 0;
			end

			`FUNC_LRS: begin
				alu_out = in_1 >> in_2[4:0];
				bcond = 0;
			end

			`FUNC_ARS: begin
				alu_out = $signed(in_1) >>> in_2[4:0]; 
				bcond = 0;
			end

			`FUNC_BEQ: begin
				alu_out = 0;
				if (in_1 == in_2) bcond = 1;
				else bcond = 0;
			end

			`FUNC_BNE: begin
				alu_out = 0;
				if (in_1 != in_2) bcond = 1;
				else bcond = 0;
			end

			`FUNC_BLT: begin
				alu_out = 0;
				// $display("BLT rs1: %d | rs2: %d", in_1, in_2); //! FOR DEBUGGING
				if ($signed(in_1) < $signed(in_2)) bcond = 1;
				else bcond = 0;
			end

			`FUNC_BGE: begin
				alu_out = 0;
				// $display("BGE rs1: %d | rs2: %d", in_1, in_2); //! FOR DEBUGGING
				if ($signed(in_1) >= $signed(in_2)) bcond = 1;
				else bcond = 0;
			end

			default: begin
				alu_out = 0; 
				bcond = 0;
			end

		endcase

		// $display("alu_op: %d | in_1: %d | in_2: %d | alu result: %d", alu_op, in_1, in_2, alu_out); //! FOR DEBUGGING

	end

endmodule
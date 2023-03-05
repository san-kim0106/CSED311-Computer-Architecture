`include "vending_machine_def.v"

module check_time_and_coin(
	i_input_coin, // denotes which coin has been given to the vending machine
	i_select_item, // denotes the selected item(s)

	clk,
	reset_n,

	wait_time, // 32-bit wire to represent integer
	o_return_coin // denotes the returned coins (by the vending machine)
);

	input clk;
	input reset_n;
	input [`kNumCoins-1:0] i_input_coin;
	input [`kNumItems-1:0]	i_select_item;
	
	output reg  [`kNumCoins-1:0] o_return_coin;
	output reg [31:0] wait_time;

	//! Double check when to and not to use blocking/non-blocking assignments

	// initiate values
	initial begin
		// TODO: initiate values
		wait_time = `kWaitTime; //! double check if you can initialize an array like this
		o_return_coin = `kNumCoins'b0; //! double check if you can initialize an array like this
	end


	// update coin return time
	always @(i_input_coin, i_select_item) begin
		// TODO: update coin return time
		wait_time = `kWaitTime;

		if (i_select_item) begin
			case(i_select_item)
				'b0001: ;
				'b0010: ;
				'b0100: ;
				'b1000: ;

			endcase
		end

	end

	always @(*) begin
		// TODO: o_return_coin

		o_return_coin = o_return_coin + i_input_coin;
	end

	always @(posedge clk) begin
		if (!reset_n) begin
			// TODO: reset all states.
			wait_time = `kWaitTime
			

		end
		else begin
			// TODO: update all states.
			wait_time = wait_time - 1'b1;
		end
	end
endmodule 
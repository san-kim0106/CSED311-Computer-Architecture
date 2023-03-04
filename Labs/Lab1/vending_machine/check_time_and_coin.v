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

	// initiate values
	initial begin
		// TODO: initiate values
		waiting_time = `kWaitTime; //! double check if you can initialize an array like this
		o_return_coin = `kNumCoins'b0; //! double check if you can initialize an array like this
	end


	// update coin return time
	always @(i_input_coin, i_select_item) begin
		// TODO: update coin return time
		

	end

	always @(*) begin
		// TODO: o_return_coin
	end

	always @(posedge clk) begin
		if (!reset_n) begin
			// TODO: reset all states.
			current_total = 0;
			current_total_nxt = 0;

		end
		else begin
			// TODO: update all states.
			waiting_time = waiting_time - 1'b1;
		end
	end
endmodule 
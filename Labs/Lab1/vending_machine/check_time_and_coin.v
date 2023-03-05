`include "vending_machine_def.v"

module check_time_and_coin(
	i_input_coin, // denotes which coin has been given to the vending machine
	i_select_item, // denotes the selected item(s)

	clk,
	reset_n,
	wait_time, // 32-bit wire to represent integer
	input_total,
	item_price,

	o_return_coin // denotes the returned coins (by the vending machine)
);

	input clk;
	input reset_n;
	input [31:0] item_price [`kNumItems-1:0];
	input [`kNumCoins-1:0] i_input_coin;
	input [`kNumItems-1:0]	i_select_item;
	
	output reg  [`kNumCoins-1:0] o_return_coin;
	output reg [31:0] wait_time;
	output reg input_total;

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
		if (i_input_coin && wait_time > 0) wait_time = `kWaitTime; // reset the wait_time to 100
		
		if (i_select_item && wait_time > 0) begin
			for (integer i = 0; i < `kNumItems; i = i + 1) begin
				if (i_select_item[i] && input_total >= item_price[i]) wait_time = `kWaitTime;
			end
		end
	end

	always @(wait_time) begin
		// TODO: o_return_coin
		if (wait_time == 0) begin
			while (input_total > 0) begin
				if (input_total >= 1000) begin
					o_return_coin = 3'b100;
					input_total = input_total - 1000;
				end else if (input_total >= 500) begin
					o_return_coin = 3'b010;
					input_total = input_total - 500;
				end else begin
					o_return_coin = 3'b001;
					input_total = input_total - 100;
				end

				#50;
			end
		end
	end

	always @(posedge clk) begin
		if (!reset_n) begin
			// TODO: reset all states.
			wait_time = `kWaitTime;

		end else begin
			// TODO: update all states.
			wait_time = wait_time - 1'b1;
		end
	end
endmodule
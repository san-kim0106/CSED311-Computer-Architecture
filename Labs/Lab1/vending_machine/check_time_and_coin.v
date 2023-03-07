`include "vending_machine_def.v"

module check_time_and_coin(
	i_input_coin, // denotes which coin has been given to the vending machine
	i_select_item, // denotes the selected item(s)

	clk,
	reset_n,
	wait_time, // 32-bit wire to represent integer
	item_price,
	current_total,
	i_trigger_return,

	o_return_coin // denotes the returned coins (by the vending machine)
);

	/* Additional arguments */
	input [`kTotalBits-1:0] current_total;
	input i_trigger_return;
	input [31:0] item_price [`kNumItems-1:0];
	/* End of additional arguments */

	input clk;
	input reset_n;
	input [`kNumCoins-1:0] i_input_coin;
	input [`kNumItems-1:0]	i_select_item;
	
	output reg  [`kNumCoins-1:0] o_return_coin;
	output reg [31:0] wait_time;

	integer return_total;

	// initiate values
	initial begin
		// TODO: initiate values
		wait_time = `kWaitTime;
		o_return_coin = `kNumCoins'b0;
	end

	// update coin return time
	always @(i_input_coin, i_select_item) begin
		// TODO: update coin return time
		if (i_input_coin && wait_time > 0) wait_time = `kWaitTime;
		
		if (i_select_item && wait_time > 0) begin
			for (integer i = 0; i < `kNumItems; i = i + 1) begin
				if (i_select_item[i] && current_total >= item_price[i]) wait_time = `kWaitTime;
			end
		end
	end

	always @(*) begin
		// TODO: o_return_coin
		if ($signed(wait_time) <= 0 || i_trigger_return) begin
			$display("current_total: %d | wait_time: %d", current_total, wait_time);
			if (current_total >= 1000) o_return_coin = `kNumCoins'd4;
			else if (current_total >= 500) o_return_coin = `kNumCoins'd2;
			else o_return_coin = `kNumCoins'd1;
		end else begin
			o_return_coin = `kNumCoins'b0;
		end
	end

	always @(posedge clk) begin
		if (!reset_n) begin
			// TODO: reset all states.
			wait_time = `kWaitTime;
			o_return_coin = `kNumCoins'b0;

		end else begin
			// TODO: update all states.
			if ($signed(wait_time) > 0) wait_time <= wait_time - 1'b1;
		end
	end
endmodule
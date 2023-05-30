`include "vending_machine_def.v"

module check_time_and_coin(
	i_input_coin, // denotes which coin has been given to the vending machine
	i_select_item, // denotes the selected item(s)

	clk,
	reset_n,
	wait_time, // 32-bit wire to represent integer
	return_finished,

	o_available_item,
	i_trigger_return
);

	/* Additional arguments */
	input i_trigger_return;
	input [`kNumItems-1:0] o_available_item;
	input return_finished;
	/* End of additional arguments */

	input clk;
	input reset_n;
	input [`kNumCoins-1:0] i_input_coin;
	input [`kNumItems-1:0]	i_select_item;
	output reg [31:0] wait_time;


	// initiate values
	initial begin
		// TODO: initiate values
		wait_time = `kWaitTime;
	end

	always @(posedge clk) begin
		if (!reset_n) begin
			// TODO: reset all states.
			wait_time = `kWaitTime;

		end else if (i_input_coin || (return_finished && wait_time != `kWaitTime)) begin
			wait_time = `kWaitTime;

		end else if (i_select_item) begin

			for (integer i = 0; i < `kNumItems; i = i + 1) begin

				if (i_select_item[i] && o_available_item[i]) wait_time = `kWaitTime;

			end

		end else begin
			// TODO: update all states.
			wait_time <= wait_time - 1'b1;
		end
	end
endmodule
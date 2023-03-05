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
		if (i_input_coin) begin
			wait_time = `kWaitTime;
			if (i_input_coin[0]) input_total = input_total + 100;
			if (i_input_coin[1]) input_total = input_total + 500;
			if (i_input_coin[2]) input_total = input_total + 1000;
		end
		
		if (i_select_item && wait_time > 0) begin
			case(i_select_item)
				'b0001: if (o_available_item[0]) wait_time = `kWaitTime;
				'b0010: if (o_available_item[1]) wait_time = `kWaitTime;
				'b0100: if (o_available_item[2]) wait_time = `kWaitTime;
				'b1000: if (o_available_item[3]) wait_time = `kWaitTime;				

			endcase
		end

	end

	always @(wait_time) begin
		// TODO: o_return_coin
		if (wait_time == 0) begin
			while (input_total > 0) begin
				if (input_total >= 1000) o_return_coin = 3'b100;
				else begin
					if (input_total >= 500) o_return_coin = 3'b010;
					else o_return_coin = 3'b001;
				end
				#50;
			end
		end
	end

	always @(posedge clk) begin
		if (!reset_n) begin
			// TODO: reset all states.
			wait_time = `kWaitTime

		end else begin
			// TODO: update all states.
			wait_time = wait_time - 1'b1;
		end
	end
endmodule 
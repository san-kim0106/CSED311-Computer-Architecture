`include "vending_machine_def.v"

	

module check_time_and_coin(i_input_coin,i_select_item,clk,reset_n,wait_time,o_return_coin, input_total, i_trigger_return, item_price,coin_value);
	input clk;
	input reset_n;
	input [`kNumCoins-1:0] i_input_coin;
	input [`kNumItems-1:0]	i_select_item;
	output reg  [`kNumCoins-1:0] o_return_coin;
	output reg [31:0] wait_time;
	integer i;
	input input_total;
	input i_trigger_return;
	input [31:0] item_price [`kNumItems-1:0];
	input [31:0] coin_value [`kNumCoins-1:0];
	// initiate values
	initial begin
		// TODO: initiate values
		wait_time <= 100;
	end


	// update coin return time
	always @(i_input_coin, i_select_item) begin
		// TODO: update coin return time
		if(i_input_coin) begin
			wait_time = 100;
		end
		
		if(i_select_item) begin
			for(i = 0; i<`kNumItems; i = i + 1) begin
				if(i_select_item[i] && item_price[i] <= input_total) begin
					wait_time = 100;
				end
			end
		end
	end

	always @(wait_time) begin
		// TODO: o_return_coin
		// Calculate returned coid due to time over or return button
		if($signed(wait_time) <= 0 || i_trigger_return) begin
			for(i = 0 ; i< `kNumCoins; i = i +1) begin
				o_return_coin[i] = 0;
			end
			if(input_total >= coin_value[2]) begin
				o_return_coin[2] = 1;
			end else if(input_total >= coin_value[1]) begin
				o_return_coin[1] = 1;
			end else if(input_total >= coin_value[0]) begin
				o_return_coin[0] = 1;
			end
		end
	end	

	always @(posedge clk ) begin
		if (!reset_n) begin
		// TODO: reset all states.
			wait_time <= 100;
			for(i = 0; i<`kNumCoins; i = i + 1) begin
				o_return_coin[i] = 0;
			end
		end
		else begin
		// TODO: update all states.
			wait_time <= wait_time -1;
		end
	end
endmodule 
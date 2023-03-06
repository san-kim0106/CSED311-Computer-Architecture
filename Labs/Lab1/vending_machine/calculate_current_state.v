`include "vending_machine_def.v"
	

module calculate_current_state(
	i_input_coin,
	i_select_item,

	item_price,
	coin_value,
	current_total,
	input_total,
	output_total,
	return_total,
	current_total_nxt,
	wait_time,

	o_return_coin,
	o_available_item,
	o_output_item
);
	
	input [`kNumCoins-1:0] i_input_coin, o_return_coin;
	input [`kNumItems-1:0]	i_select_item;			
	input [31:0] item_price [`kNumItems-1:0];
	input [31:0] coin_value [`kNumCoins-1:0];	
	input [`kTotalBits-1:0] current_total;
	input [31:0] wait_time;

	output reg [`kNumItems-1:0] o_available_item, o_output_item;
	output reg  [`kTotalBits-1:0] input_total, output_total, return_total, current_total_nxt;
	integer i;

	initial begin
		o_available_item = 0;
	end
	
	// Combinational logic for the next states
	always @(*) begin
		// TODO: current_total_nxt
		// You don't have to worry about concurrent activations in each input vector (or array).
		// Calculate the next current_total state.

		current_total_nxt = current_total + input_total - output_total;

	end
	
	// Combinational logic for the outputs
	always @(i_input_coin, i_select_item) begin
		input_total = 0;
		output_total = 0;
		return_total = 0;

		// Check i_input_coin and update input_total
		for (integer i = 0; i < `kNumCoins; i = i + 1) begin
			if (i_input_coin[i]) input_total = input_total + coin_value[i];
		end

		// Check i_select_item and update outtput_total
		for (integer i = 0; i < `kNumItems; i = i + 1) begin
			if (i_select_item[i] && current_total >= item_price[i]) output_total = output_total + item_price[i];
		end

		// update o_available_item
		for (integer i = 0; i < `kNumItems; i = i + 1) begin
			// The item is available if its price is less than input_total
			if (item_price[i] <= current_total + input_total) o_available_item[i] = 1;
			else o_available_item[i] = 0;
		end

		// update o_output_item
		for (integer i = 0; i < `kNumItems; i = i + 1) begin
			if (i_select_item[i] && o_available_item[i]) o_output_item[i] = 1;
			else o_output_item[i] = 0;
		end
	end


endmodule 

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



	
	// Combinational logic for the next states
	always @(*) begin
		// TODO: current_total_nxt
		// You don't have to worry about concurrent activations in each input vector (or array).
		// Calculate the next current_total state.
		
	end

	
	
	// Combinational logic for the outputs
	always @(*) begin
		// TODO: o_available_item
		for (integer i = 0; i < `kNumItems; i = i + 1) begin
			// The item is available if its price is less than input_total
			if (item_price[i] <= input_total) o_available_item[i] = 1;
		end

		// TODO: o_output_item
		// Loop around the i_select_item vector and output the item if it is available
		for (integer i = 0; i < `kNumItems; i = i + 1) begin
			// VM outputs an item if it is selected and available
			if (i_select_item[i] && o_available_item[i]) o_output_item[i] = 1;
		end

	end
 
	


endmodule 
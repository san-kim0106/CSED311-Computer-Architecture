
`include "vending_machine_def.v"
	

module calculate_current_state(i_input_coin,i_select_item,item_price,coin_value,current_total,
input_total, output_total, return_total,current_total_nxt,wait_time,o_return_coin,o_available_item,o_output_item);


	
	input [`kNumCoins-1:0] i_input_coin,o_return_coin;
	input [`kNumItems-1:0]	i_select_item;			
	input [31:0] item_price [`kNumItems-1:0];
	input [31:0] coin_value [`kNumCoins-1:0];	
	input [`kTotalBits-1:0] current_total;
	input [31:0] wait_time;
	output reg [`kNumItems-1:0] o_available_item,o_output_item;
	output reg  [`kTotalBits-1:0] input_total, output_total, return_total,current_total_nxt;
	integer i;	



	
	// Combinational logic for the next states
	always @(i_input_coin, i_select_item, o_return_coin) begin
		// TODO: current_total_nxt
		// You don't have to worry about concurrent activations in each input vector (or array).
		// Calculate the next current_total state.
		if(i_input_coin)begin
			current_total_nxt = 1; // 1 means Money state	
		end else if(i_select_item) begin
			current_total_nxt = 2; // 2 means Item state	
		end else if(o_return_coin) begin
			current_total_nxt = 3; // 3 means Return state
		end else begin
			current_total_nxt = 4; // 4 means Waiting state	
		end		
	end

	
	
	// Combinational logic for the outputs
	always @(current_total, i_input_coin, i_select_item, o_return_coin ) begin
		// TODO: o_available_item
		// TODO: o_output_item
		case(current_total) 
			0 : begin // initial state
				input_total = 0; 
				output_total = 0;
				return_total = 0;	
			end
			1 : begin // Money state : Check the input of coin and modify input_total
				for(i = 0; i < `kNumCoins; i = i + 1) begin
					if(i_input_coin[i]) begin
						input_total = input_total + coin_value[i];	
					end
				end
			end
			2 : begin // Item state : Check the selected item, calculate o_output_item, and modify input_total by output_total
				for(i = 0; i < `kNumItems; i = i + 1) begin
					o_output_item[i] = 0;
					if(i_select_item[i]  && item_price[i] <= input_total - output_total) begin
						o_output_item[i] = 1; // Check selected item is available or not.
						output_total = output_total + item_price[i];
					end
				end
			end
			3 : begin // Return state : Calculate which coin should be returned
				for(i = 0; i < `kNumCoins; i = i + 1) begin
					if(o_return_coin[i]) begin
						return_total = return_total + coin_value[i];
					end
				end
			end
			4 : begin // Wating state : waiting for input and modify input_total by return_total and output_total, also reset them. According to new input_total, calculate available item
				input_total = input_total - return_total - output_total;
				return_total = 0;
				output_total = 0; // should be done asynchronously
				for(i=0; i< `kNumItems; i = i + 1) begin
					o_available_item[i] = 0;
					if(item_price[i] <= input_total) begin
						o_available_item[i] = 1;	
					end	
				end
			end
		endcase

	end
 
	


endmodule 
`include "CLOG2.v"
`include "state.v"

module Cache #(parameter LINE_SIZE = 16,
               parameter NUM_SETS = 8,
               parameter NUM_WAYS = 2) (
    input reset,
    input clk,

    input is_input_valid, 
    input [31:0] addr, // Address
    input mem_read, // Control Signal
    input mem_write, // Control Signal
    input [31:0] din, // Write data

    output reg is_ready, // Is the Cache take requests?
    output reg is_output_valid, // is dout valid?
    output reg [31:0] dout,
    output reg is_hit);
  // Wire declarations
  wire is_data_mem_ready;
  // Reg declarations
  reg [127:0] data_bank1 [7:0]; // Each block is 16 byte (128 bits) and there are 8 blocks in each data bank
  reg [24:0] tag_bank1 [7:0]; // Each tag is 25 bit
  reg [7:0] is_valid1;
  reg [7:0] is_dirty1;
  reg [7:0] replacement1;

  reg [127:0] data_bank2 [7:0]; // Each block is 16 byte (128 bits) and there are 8 blocks in each data bank
  reg [24:0] tag_bank2 [7:0]; // Each tag is 25 bit
  reg [7:0] is_valid2;
  reg [7:0] is_dirty2;
  reg [7:0] replacement2;

  // if 0 then replace from bank1
  // else if 1 then replace from bank2
  reg replacement_table;

  // Register for DataMemory Module
  reg _mem_request;
  reg [31:0] _mem_addr;
  reg [127:0] _mem_din;
  reg _mem_read;
  reg _mem_write;
  reg _is_output_valid;
  reg [127:0] _mem_dout;

  // State registers
  reg [3:0] current_state;
  reg [3:0] next_state;

  // Signals when to write to the cache
  reg cache_write;
  
  // You might need registers to keep the status.

  assign is_ready = is_data_mem_ready;

  always @(posedge clk) begin
    if(reset) begin // Set the inital values
      for(i = 0; i < NUM_SETS; i = i + 1) begin
        is_valid1[i] <= 0;
        is_valid2[i] <= 0;
        is_dirty1[i] <= 0;
        is_dirty2[i] <= 0;
        replacement1[i] <= 0;
        replacement2[i] <= 0;
      end

      current_state <= `ready;
      next_state <= `ready;
      cache_write <= 0;
      _mem_request <= 0;
      replacement_table <= 0;

    end else begin // Update FSM
      current_state <= next_state;
    end
    
    if (cache_write) begin
    
    end
  end

  always @(*) begin
    integer idx = addr[6:4];
    integer block_offset = addr[3:2];
    
    case (current_state)
      `ready:
        if (is_input_valid) begin
          next_state = tag_compare;
        end else begin
          next_state = `ready;
        end

      `tag_compare:
        if (tag_bank1[idx] == addr[31:7] && is_valid1[idx]) begin
          // Cache hit
          if (mem_read) begin
            dout = data_bank1[idx][32 * (block_offset + 1) - 1: 32 * block_offset];
            replacement1[idx] = 0;
            replacement2[idx] = 1;
          end else if (mem_write) begin
            cache_write = 1;
            // TODO
          end
          is_hit = 1;
          is_output_valid = 1;
          next_state = `ready;
        end else if (tag_bank2[idx] == addr[31:7] && is_valid2[idx]) begin
          // Cache hit
          if (mem_read) begin
            dout = data_bank2[idx][32 * (block_offset + 1) - 1: 32 * block_offset];
            replacement1[idx] = 1;
            replacement2[idx] = 0;
          end else if (mem_write) begin
            cache_write = 1;
            // TODO
          end
          is_hit = 1;
          is_output_valid = 1;
          next_state = `ready;
        end else begin
          // Cache miss
          is_hit = 0;
          is_output_valid = 0;
          next_state = `evict;
        end

      `evict:
        if (replacement1[idx]) begin
          // Evict from data_bank1
          replacement_table = 0;
          if (is_dirty1[idx]) next_state = `write_back;
          else                next_state = `allocate;
        end else if (replacement1[idx]) begin
          // Evict from data_bank2
          replacement_table = 1;
          if (is_dirty1[idx]) next_state = `write_back;
          else                next_state = `allocate;
        end else begin
          // Cold Miss
          replacement_table = 0;
          next_state = `allocate;
        end

        is_hit = 0;
        is_output_valid = 0;
        
      `write_back:
        if (!replacement_table) begin
          // write-back bank1
            _mem_request = 1;
            _mem_addr = (tag_bank1[idx], idx, 4'b0000);
            _mem_din = data_bank1[idx];
            _mem_read = 0;
            _mem_write = 1;
            is_dirty1[idx] = 0;
        end else begin
          // write-back bank2
          _mem_request = 1;
          _mem_addr = (tag_bank1[idx], idx, 4'b0000);
          _mem_din = data_bank1[idx];
          _mem_read = 0;
          _mem_write = 1;
          is_dirty2[idx] = 0;
        end

        next_state = `interim;

      `allocate:
        _mem_request = 1;
        _mem_addr = addr;
        _mem_read = 1;
        _mem_write = 0;

        next_state = `interim;
      
      `interim:
        if (is_data_mem_ready && _is_output_valid) begin
          next_state = `tag_compare;
          cache_write = 1;
          // TODO: The data read from the DataMemroy should be written to the cache
          // TODO: We need to make changes to the tag bank
        end else if (is_data_mem_ready) begin
          next_state = `evict
        end else begin
          _mem_request = 0;
          next_state = `interim;
        end
    endcase
  end

  // Instantiate data memory
  DataMemory #(.BLOCK_SIZE(LINE_SIZE)) data_mem(
    .reset(reset),
    .clk(clk),

    .is_input_valid(_mem_request),
    .addr(_mem_addr),        // NOTE: address must be shifted by CLOG2(LINE_SIZE)
    .mem_read(_mem_read),
    .mem_write(_mem_write),
    .din(_mem_din),

    // is output from the data memory valid?
    .is_output_valid(_is_output_valid),
    .dout(_mem_dout),
    // is data memory ready to accept request?
    .mem_ready(is_data_mem_ready)
  );

endmodule

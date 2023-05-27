`define tag_compare 3'b000  // State 0
`define evict 3'b001        // State 1
`define write_back 3'b010   // State 2
`define allocate 3'b011     // State 3
`define interim 3'b100      // State 4
`define cache_write 3'b101  // State 5

/*
  if it's a cache write:
    tag_compare, 0 --(miss)--> evict, 1 ---(dirty)--> write-back, 2 --> interim, 4
                                        |
                                        |--(clean)--> allocate, 3 --> interim, 4

*/
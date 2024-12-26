module xor_state (
   input  logic [1087:0]   data_in  ,
   input  logic [1599:0]   state    ,
   input  logic            is_xor   ,

   output logic [1599:0]   data_out_r
);

   logic [1087:0] data_xor;
   logic [1599:0] data_tmp;

   always_comb begin 
      data_xor = data_in ^ state[1087:0]; 
      data_tmp = {state[1599:1088], data_xor[1087:0]}; // 1088 r, 512 c
   end 

   always_comb begin 
      if (is_xor) data_out_r = data_tmp;
      else        data_out_r = 0;
   end

endmodule 
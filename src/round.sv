import keccak_pkg::plane;
import keccak_pkg::state;
import keccak_pkg::N;

module round (
   input  logic         clk        , 
   input  logic         reset_n    ,
	input  state         A_in       ,
   input  logic [4:0]   rnd_count  ,

   output state         A_out      ,
   output logic         finish
);

   state step_in;
   state step_out;
   state step_out_reg;

   assign step_in = (rnd_count == 0) ? A_in : step_out_reg;

   step_mapping sm (
      .A_in    (step_in)   ,
      .rc_num  (rnd_count) ,
      .A_out   (step_out)     
   );

   assign finish = (rnd_count == 24);
   assign A_out = step_out_reg;

   always_ff @(posedge clk or negedge reset_n) begin 
      if (~reset_n) step_out_reg <= 0;
      else step_out_reg <= step_out;
   end

endmodule 

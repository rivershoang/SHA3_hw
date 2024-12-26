module cache (
   input  logic            clk         ,
   input  logic            reset_n     ,
   input  logic [1599:0]   d_in        ,
   input  logic            enable_reg  ,
   output logic [1599:0]   q_out
);

   always_ff @(posedge clk or negedge reset_n) begin 
      if (~reset_n)        q_out <= 0;
      else if (enable_reg) q_out <= d_in;
   end

endmodule 

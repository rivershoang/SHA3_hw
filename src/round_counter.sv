module round_counter (
   input  logic        clk     , 
   input  logic        reset_n , 
   input  logic        en_count,
   output logic [4:0]  round
);

   always_ff @(posedge clk or negedge reset_n) begin 
      if (!reset_n) round <= 0;
      else begin 
         if (~en_count) round <= 0;
         else begin 
            if (round == 24) round <= 0;
            else round <= round + 1;
            end
        end
    end
    
endmodule
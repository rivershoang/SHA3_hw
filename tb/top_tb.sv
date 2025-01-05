module top_tb ();
   logic clk, reset_n;
   logic start;
   logic wr_fifo, rd_fifo;
   logic [63:0] data_in, data_out;
   logic finish_hash;

   top top_inst (
      .clk (clk),
      .reset_n (reset_n),
      .start (start),
      .wr_fifo (wr_fifo),
      .data_in (data_in),
      .data_out (data_out),
      .finish_hash (finish_hash)
   );

   initial begin 
      clk = 0;
      forever #1 clk = ~clk;
   end

   initial begin 
      reset_n = 0;
      data_in = 0;
      wr_fifo = 0;
      rd_fifo = 0;
      start = 0;

      @(posedge clk);
      reset_n = 1;
      // Write data to FIFO
      repeat (16) begin
         @(posedge clk);
         wr_fifo = 1;
         data_in = $random;
         @(posedge clk);
         wr_fifo = 0;
      end
      @(posedge clk);
      start = 1;
      @(posedge clk);
      start = 0;
      #100;
      $stop;
   end
   
endmodule 

      
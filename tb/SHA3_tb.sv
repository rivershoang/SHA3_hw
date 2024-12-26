import keccak_pkg::plane;
import keccak_pkg::state;
import keccak_pkg::N;

module SHA3_tb();
	logic		clk, rst_n;
	logic		start;
	logic		[63:0] data_in;

	logic		last_block;

	logic		valid;
	logic		finish_hash;
	logic		[63:0] data_out;
	logic		ready;

   SHA3 top (
      .clk           (clk)          , 
      .rst_n         (rst_n)        , 
      .start         (start)        , 
      .data_in       (data_in)      ,  
      .last_block    (last_block)   ,  
      .valid         (valid)        ,  
      .finish_hash   (finish_hash)  , 
      .data_out      (data_out)     , 
      .ready         (ready)
   );

   initial begin clk = 0;
      forever #5 clk = ~clk;
   end
   
   initial begin
      rst_n = 0; 
      data_in = 64'h8899AABBCCDDEEFF;
      last_block = 0; #7;
      rst_n = 1; #3; 
      @(posedge clk); start = 1;
      @(posedge clk); start = 0; data_in = 64'h8899AABBCCDDEEFF; // cycle 1
      @(posedge clk); data_in =  64'h2233445566778899; // cycle 2
      @(posedge clk);  data_in = 64'hFFFFFFFFFFFFFFFF; // cycle 3
      @(posedge clk);  data_in = 64'hFFFFFFFFFFFFFFFF; // cycle 4
      @(posedge clk);  data_in = 64'hFFFFFFFFFFFFFFFF; // cycle 5
      @(posedge clk);  data_in = 64'hFFFFFFFFFFFFFFFF; // cycle 6
      @(posedge clk);  data_in = 64'hFFFFFFFFFFFFFFFF; // cycle 7
      @(posedge clk);  data_in = 64'hFFFFFFFFFFFFFFFF; // cycle 8
      @(posedge clk);  data_in = 64'hFFFFFFFFFFFFFFFF; // cycle 9
      @(posedge clk);  data_in = 64'hFFFFFFFFFFFFFFFF; // cycle 10
      @(posedge clk);  data_in = 64'hFFFFFFFFFFFFFFFF; // cycle 11
      @(posedge clk);  data_in = 64'hFFFFFFFFFFFFFFFF; // cycle 12
      @(posedge clk);  data_in = 64'hFFFFFFFFFFFFFFFF; // cycle 13
      @(posedge clk);  data_in = 64'hFFFFFFFFFFFFFFFF; // cycle 14
      @(posedge clk);  data_in = 64'h0000000000000000; // cycle 15
      @(posedge clk);  last_block = 1; data_in = 64'hFFFFFFFFFFFFFFFF; // cycle 16
      @(posedge clk); last_block =0;
      #10000000;
      $stop;
   //  end
   //    rst_n = 0; 
   //    data_in = 64'h8899AABBCCDDEEFF;
   //    last_block = 0; #7;
   //    rst_n = 1; #3; 
   //    @(posedge clk); start = 1;
   //    @(posedge clk); start = 0; last_block = 1;  
   //    @(posedge clk); last_block = 0;
   //    #1000;
   //    $stop;
   //  end
//     rst_n = 0;
// data_in = 64'h8899AABBCCDDEEFF;
// last_block = 0; #7;
// rst_n = 1; #3; 
// start = 1;
// #10; start = 0;  
// #1090; last_block = 1;
// #10; last_block = 0;
// #1000;
// $stop;
// end
   end
endmodule 
module serial_to_paralell_pad_tb;


  // Signals
  reg clk;
  reg reset_n;
  reg vld;
  reg is_last_data;
  reg [64-1:0] data_in;
  wire [1087:0] data_out;
  wire is_full;
  wire is_first_data;

  // Instantiate the DUT (Device Under Test)
  serial_to_paralell_pad dut (
    .clk(clk),
    .reset_n(reset_n),
    .vld(vld),
    .is_last_data(is_last_data),
    .data_in(data_in),
    .data_out(data_out),
    .is_full(is_full),
    .is_first_data(is_first_data)
  );

  // Clock generation
  initial clk = 0;
always #5 clk = !clk;
initial 
begin
reset_n = 0; vld = 1;
//dt_i = 128'h00112233_44556677_8899aabb_ccddeeff; 
data_in = 63'h0;
is_last_data = 0; #7;
reset_n = 1; #3; 
#10; 
is_last_data = 1;  
#10 is_last_data = 0;
#100;
$stop;
end

endmodule
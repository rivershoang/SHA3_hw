module xor_state_tb();

   // Testbench signals
   logic [1087:0] data_in;
   logic [1599:0] state;
   logic          is_xor;
   logic [1599:0] data_out_r;

   // DUT instantiation
   xor_state dut (
      .data_in(data_in),
      .state(state),
      .is_xor(is_xor),
      .data_out_r(data_out_r)
   );

   initial begin 
      data_in = 1088'hffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff;
      state = 0;
      is_xor = 1;
#10;
   end


endmodule 
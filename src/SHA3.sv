`include "../src/keccak_pkg.sv"
import keccak_pkg::plane;
import keccak_pkg::state;
import keccak_pkg::N;

module SHA3(clk, rst_n, start, data_in, last_block, valid, finish_hash, data_out, ready,read_data_fifo);
	input                clk, rst_n;
	input                start;
	input  logic [63:0]  data_in;
	input                last_block;
   output logic         read_data_fifo;
	output logic         valid;
	output logic         finish_hash;
	output logic [63:0]  data_out;
	output logic         ready;

	logic		         last_block, 
                     buff_full, 
                     first, 
                     nxt_block, 
                     en_vsx, 
                     en_counter,
                     finish;
	logic		[1087:0] dt_o;
	state		         tr_out, 
                     tr_in;
	logic		[1599:0] init_state, 
                     data_to_sta, 
                     tr_out_string, 
                     tr_out_string_finish;
	logic		[  4: 0] round_num;


   
   serial_to_paralell_pad serial_to_paralell_pad_inst (
      .clk           (clk)       ,
      .reset_n       (rst_n)     ,
      .data_in       (data_in)   ,
      .is_last_data  (last_block),
      .vld           (valid)     ,
      .enable_count  (en_counter),
      .is_full       (buff_full) ,
      .is_first_data (first)     ,
      .data_out      (dt_o)
   );


   mux mux_sel (
      .a    (tr_out_string_finish)  ,
      .sel  (nxt_block)             ,
      .b    (1600'b0)               ,
      .c    (init_state)
   );

   xor_state xor_s (
      .data_in    (dt_o)      ,
      .state      (init_state),
      .is_xor     (en_vsx)    ,
      .data_out_r (data_to_sta)
   );

   string_to_array STA (
      .S (data_to_sta),
      .A (tr_in)
   );

   round rnd_keccak (
      .clk        (clk)       ,
      .reset_n    (rst_n)     ,
      .A_in       (tr_in)     ,
      .rnd_count  (round_num) ,
      .A_out      (tr_out)    ,
      .finish     (finish)
   );

   round_counter counter (
      .clk        (clk)       ,
      .reset_n    (rst_n)     , 
      .en_count   (en_counter),
      .round      (round_num)
   );

   control_unit CU (
      .clk        (clk)       ,
      .rst_n      (rst_n)     ,
      .start      (start)     ,
      .last       (last_block),
      .buff_full  (buff_full) ,
      .first      (first)     ,
      .finish     (finish)    ,
      .valid      (valid)     ,
      .nxt_block  (nxt_block) ,
      .en_vsx     (en_vsx)    ,
      .en_counter (en_counter),
      .ready      (ready)     ,
      .read_data_fifo (read_data_fifo)
   );

   array_to_string ATS (
      .A (tr_out),
      .S (tr_out_string)
   );

   cache reg_buf (
      .clk        (clk)          ,
      .reset_n    (rst_n)        ,
      .d_in       (tr_out_string),
      .enable_reg (finish)       ,
      .q_out      (tr_out_string_finish)
   );

   parallel_serial result (
      .clk           (clk)                   ,
      .reset_n       (rst_n)                 ,
      .S_out         (tr_out_string_finish)  ,
      .ready         (ready)                 ,
      .S_out_serial  (data_out)              ,
      .finish_hash   (finish_hash)
   );

endmodule 

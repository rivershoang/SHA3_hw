module top (
   input  logic clk,
   input  logic reset_n,
   input  logic start,
   input  logic wr_fifo,
   input  logic [63:0] data_in,

   output logic [63:0] data_out,
   output logic finish_hash
);


   logic [63:0]   data_tmp,
                  data_out_tmp;
   logic          last_read;
   logic          read_data_fifo,
                  write_data_fifo,
                  read_result;

   FIFO FIFO_inst (
      .clk (clk),
      .reset_n (reset_n),
      .data_in (data_in),
      .wr_en (wr_fifo),
      .rd_en (read_data_fifo),
      .data_out (data_tmp),
      .is_full (),
      .is_empty (),
      .fifo_len (),
      .last_read (last_read)
   );

   SHA3 sha3_core (
      .clk (clk),
      .rst_n (reset_n),
      .start (start),
      .data_in (data_tmp),
      .last_block (last_read),
      .valid (),
      .finish_hash (finish_hash),
      .ready (ready),
      .read_data_fifo (read_data_fifo),
      .data_out (data_out_tmp)
   );

   FIFO_result FIFO_inst_out (
      .clk (clk),
      .reset_n (reset_n),
      .data_in (data_out_tmp),
      .wr_en (write_data_fifo),
      .rd_en (read_result),
      .data_out (data_out),
      .is_full (),
      .is_empty (),
      .fifo_len (),
      .last_read ()  
   );

   always_ff @(posedge clk or negedge reset_n) begin 
      if (~reset_n) begin 
         write_data_fifo <= 0;
         read_result <= 0;
      end else if (ready && ~finish_hash) begin 
         write_data_fifo <= 1;
      end else if (finish_hash) begin 
         write_data_fifo <= 0;
         read_result <= 1;
      end
   end

endmodule

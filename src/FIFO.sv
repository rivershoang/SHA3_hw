module FIFO #( 
   parameter   WIDTH = 64,
               DEPTH = 16,
               ADDR_W = 4
)

   (  
   input  logic               clk      , 
   input  logic               reset_n  ,
   
   input  logic [WIDTH-1:0]   fifo_in  ,
   input  logic               fifo_wr  ,
   input  logic               fifo_rd  ,

   output logic [WIDTH-1:0]   fifo_out ,
   output logic               fifo_full,
   output logic               fifo_empty
);

   logic [WIDTH-1:0]    mem_array [DEPTH-1:0];
   integer              wr_point;
   integer              rd_point;
   integer              count_data;


   assign fifo_full = (count_data == 16);
   assign fifo_empty = (count_data == 0);

   always_ff @(posedge clk or negedge reset_n) begin 
      if (~reset_n) begin 
         count_data <= 0;
      end else if ((~fifo_full && fifo_wr) && (~fifo_empty && fifo_rd)) begin 
         count_data <= count_data;
      end else if (~fifo_full && fifo_wr) begin 
         count_data <= count_data + 1;
      end else if (~fifo_empty && fifo_rd) begin 
         count_data <= count_data - 1;
      end else begin 
         count_data <= count_data;
      end 
   end

   // Read data
   always_ff @(posedge clk or negedge reset_n) begin 
      if (~reset_n) begin 
         fifo_out <= 0;
      end else begin 
         if (fifo_rd && ~fifo_empty) begin 
            fifo_out <= mem_array[rd_point];
         end else begin 
            fifo_out <= fifo_out;
         end
      end
   end

   // Write data
   always_ff @(posedge clk) begin 
      if (fifo_wr && ~fifo_full) begin 
         mem_array[wr_point] <= fifo_in;
      end else begin
         mem_array[wr_point] <= mem_array[wr_point];
      end
   end

   // Pointer
   always_ff @(posedge clk or negedge reset_n) begin 
      if (~reset_n) begin 
         wr_point <= 0;
         rd_point <= 0;
      end else begin 
         if (~fifo_full && fifo_wr) begin 
            wr_point <= wr_point + 1;
         end else begin 
            wr_point <= wr_point;
         end
         if (~fifo_empty && fifo_rd) begin 
            rd_point <= rd_point + 1;
         end else begin 
            rd_point <= rd_point;
         end
      end
   end

endmodule  
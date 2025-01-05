module FIFO_result #( 
   parameter   WIDTH = 64,
               DEPTH = 4,
               ADDR_W = 4
)

   (  
   input  logic               clk      , 
   input  logic               reset_n  ,
   
   input  logic [WIDTH-1:0]   data_in  ,
   input  logic               wr_en    ,
   input  logic               rd_en    , 

   output logic [WIDTH-1:0]   data_out ,
   output logic               is_full  ,
   output logic               is_empty ,
   output logic [ADDR_W  :0]  fifo_len ,   // current length
   output logic               last_read
);

   logic [WIDTH-1:0] mem_fifo [0:DEPTH-1];
   logic [ADDR_W-1:0] wr_point; // pointer write (4bit)
   logic [ADDR_W-1:0] rd_point; // pointer read (4bit)
   assign rd_point = wr_point - fifo_len[ADDR_W-1:0];

   logic wr_enable; 
   logic rd_enable;
   
   assign wr_enable = wr_en && ~is_full;
   assign rd_enable = rd_en && ~is_empty;

   // Write data
   always_ff @(posedge clk) begin 
      if (wr_enable) begin 
         mem_fifo[wr_point] <= data_in;
      end
   end

   // update pointer write
   always_ff @(posedge clk or negedge reset_n) begin 
      if (~reset_n) begin 
         wr_point <= 0;
      end else if (wr_enable) begin 
         wr_point <= wr_point + 1;
      end
   end

   // update fifo length
   always_ff @(posedge clk or negedge reset_n) begin 
      if (~reset_n) begin 
         fifo_len <= 0;
      end else begin 
         case ({rd_enable,wr_enable})
            2'b01: fifo_len <= fifo_len + 1;
            2'b10: fifo_len <= fifo_len - 1;
            default: fifo_len <= fifo_len;
         endcase 
      end
   end

   // Read data
   always_ff @(posedge clk or negedge reset_n) begin
      if (~reset_n) begin
         data_out <= 0;
      end else if (rd_enable) begin
         data_out <= mem_fifo[rd_point];
      end
   end

   // Signal when the last data is read
   always_ff @(posedge clk or negedge reset_n) begin
      if (~reset_n) begin
         last_read <= 0;
      end else begin
         last_read <= rd_enable && (fifo_len == 1);
      end
   end

   assign is_full = (fifo_len == DEPTH); // full when depth = 16
   assign is_empty = (fifo_len == 0); // empty when depth = 0
   
endmodule  
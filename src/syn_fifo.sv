module syn_fifo #(
   parameter   DATA_SIZE   = 64 ,
               ADDR_SPACE  = 4
) 
(
   input  logic                  clk      ,
   input  logic                  rst_n    ,
   input  logic                  wr_en    ,
   input  logic                  rd_en    ,
   input  logic [DATA_SIZE-1:0]  wr_data  ,
   output logic [DATA_SIZE-1:0]  rd_data  ,
   output logic                  empty    ,
   output logic                  full
);

   logic [DATA_SIZE-1:0] reg_array [2**ADDR_SPACE-1:0]; // dept 16
   logic is_wr; // enable write data
   logic [ADDR_SPACE-1:0]  rd_point,
                           wr_point;

   assign is_wr = wr_en & ~full;

   assign rd_data = reg_array[rd_point];

   always_ff @(posedge clk) begin 
      if (is_wr) begin 
         reg_array[wr_point] <= wr_data;
      end
   end

   always_ff @(posedge clk or negedge rst_n) begin
      if (~rst_n) begin 
         wr_point <= 0;
         rd_point <= 0;
         full     <= 0;
         empty    <= 1;
      end else begin
         // write data 
         if (wr_en && ~full) begin 
            wr_point <= wr_point + 1;
            empty    <= 0;
         end
         // read data
         if (rd_en && ~empty) begin 
            rd_point <= rd_point + 1;
            full     <= 0;
         end
      end
   end

   always_ff @(posedge clk) begin 
      if(wr_point == rd_point) begin 
         empty <= 1; 
      end else begin 
         empty <= 0; 
      end
      if (wr_point + 1 == rd_point) begin
         full <= 1;
      end else begin 
         full <= 0;
      end
   end

endmodule
 
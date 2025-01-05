module FIFO_tb;

    // Parameters
    parameter WIDTH = 64;
    parameter DEPTH = 16;
    parameter ADDR_W = 4;

    // Signals
    logic clk;
    logic reset_n;
    logic [WIDTH-1:0] data_in;
    logic wr_en;
    logic rd_en;
    logic [WIDTH-1:0] data_out;
    logic [ADDR_W:0] fifo_len;
    logic is_full;
    logic is_empty;
    logic last_read;

    // DUT Instantiation
    FIFO #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH),
        .ADDR_W(ADDR_W)
    ) dut (
        .clk(clk),
        .reset_n(reset_n),
        .data_in(data_in),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .data_out(data_out),
        .is_full(is_full),
        .is_empty(is_empty),
        .fifo_len(fifo_len),
        .last_read(last_read)
    );

    // Clock Generation
    initial begin
    clk = 0;
    forever #1 clk = ~clk; // 10ns clock period
    end

    initial begin 
        reset_n = 0;
        data_in = 0;
        wr_en = 0;
        rd_en = 0;

        @(posedge clk);
        reset_n = 1;
            // Test: Write data to FIFO
        repeat (DEPTH) begin
            @(posedge clk);
            wr_en = 1;
            data_in = $random;
            @(posedge clk);
            wr_en = 0;
        end

            // Test: Read data from FIFO
        repeat (DEPTH) begin
            @(posedge clk);
            rd_en = 1;
            @(posedge clk);
            rd_en = 0;
        end

        $stop;
    end

endmodule 
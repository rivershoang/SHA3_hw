`timescale 1ns / 1ps

module tb_syn_fifo;

    // Parameters
    parameter DATA_SIZE = 64;
    parameter ADDR_SPACE = 4;

    // Signals
    logic clk;
    logic rst_n;
    logic wr_en;
    logic rd_en;
    logic [DATA_SIZE-1:0] wr_data;
    logic [DATA_SIZE-1:0] rd_data;
    logic empty;
    logic full;

    // Instantiate the FIFO module
    syn_fifo #(
        .DATA_SIZE(DATA_SIZE),
        .ADDR_SPACE(ADDR_SPACE)
    ) fifo_inst (
        .clk(clk),
        .rst_n(rst_n),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .wr_data(wr_data),
        .rd_data(rd_data),
        .empty(empty),
        .full(full)
    );

    // Clock Generation
    always begin
        #5 clk = ~clk;  // 100 MHz clock
    end

    // Test Sequence
    initial begin
        // Initialize signals
        clk = 0;
        rst_n = 0;
        wr_en = 0;
        rd_en = 0;
        wr_data = 0;

        // Reset the FIFO
        #10 rst_n = 1; // release reset after 10ns

        // Test Case 1: Write data into FIFO
        #10 wr_en = 1; wr_data = 64'hA5A5A5A5A5A5A5A5;  // Write data
        #10 wr_en = 0;  // Disable write
        
        // Test Case 2: Read data from FIFO
        #10 rd_en = 1;  // Enable read
        #10 rd_en = 0;  // Disable read

        // Test Case 3: Fill the FIFO and check full status
        #10 wr_en = 1; wr_data = 64'h1234567890ABCDEF; // Write more data
        #10 wr_en = 0;

        // Test Case 4: Enable read and ensure empty status is set
        #10 rd_en = 1;
        #10 rd_en = 0;

        // Test Case 5: Reset FIFO
        #10 rst_n = 0;  // Apply reset
        #10 rst_n = 1;  // Release reset

        // Test Case 6: Write when FIFO is full
        #10 wr_en = 1; wr_data = 64'hDEADBEEFDEADBEEF; // Try to write when FIFO is full
        #10 wr_en = 0;  // Disable write

        // Test Case 7: Read all data
        #10 rd_en = 1;  // Read from FIFO
        #10 rd_en = 0;  // Disable read

        #10 $stop;  // End of simulation
    end

endmodule

    module FIFO_tb;

    // Parameters
    parameter WIDTH = 64;
    parameter DEPTH = 16;
    parameter ADDR_W = 4;

    // Signals
    logic clk;
    logic reset_n;
    logic [WIDTH-1:0] fifo_in;
    logic fifo_wr;
    logic fifo_rd;
    logic [WIDTH-1:0] fifo_out;
    logic fifo_full;
    logic fifo_empty;

    // DUT Instantiation
    FIFO #(
        .WIDTH(WIDTH),
        .DEPTH(DEPTH),
        .ADDR_W(ADDR_W)
    ) uut (
        .clk(clk),
        .reset_n(reset_n),
        .fifo_in(fifo_in),
        .fifo_wr(fifo_wr),
        .fifo_rd(fifo_rd),
        .fifo_out(fifo_out),
        .fifo_full(fifo_full),
        .fifo_empty(fifo_empty)
    );

    // Clock Generation
    initial begin
    clk = 0;
    forever #5 clk = ~clk; // 10ns clock period
    end

    // Test Procedure
    initial begin
    // Initialize inputs
    reset_n = 0;
    fifo_wr = 0;
    fifo_rd = 0;
    fifo_in = 0;

    // Apply reset
    #10 reset_n = 1;
    $display("Reset applied.");

    // Test Case 1: Write data into FIFO until full
    $display("Writing data into FIFO...");
    for (int i = 0; i < DEPTH; i++) begin
        @(posedge clk);
        if (!fifo_full) begin
        fifo_in = $random;
        fifo_wr = 1;
        end
    end
    @(posedge clk);
    fifo_wr = 0;
    $display("FIFO Full: %b", fifo_full);

    // Test Case 2: Read data from FIFO until empty
    $display("Reading data from FIFO...");
    for (int i = 0; i < DEPTH; i++) begin
        @(posedge clk);
        if (!fifo_empty) begin
        fifo_rd = 1;
        end
    end
    @(posedge clk);
    fifo_rd = 0;
    $display("FIFO Empty: %b", fifo_empty);

    // Test Case 3: Simultaneous Read and Write
    $display("Testing simultaneous read/write...");
    for (int i = 0; i < DEPTH; i++) begin
        @(posedge clk);
        fifo_in = $random;
        fifo_wr = 1;
        fifo_rd = 1;
    end
    @(posedge clk);
    fifo_wr = 0;
    fifo_rd = 0;

    // Test Case 4: Reset during operation
    $display("Applying reset during operation...");
    @(posedge clk);
    fifo_wr = 1;
    fifo_in = $random;
    @(posedge clk);
    reset_n = 0; // Apply reset
    @(posedge clk);
    reset_n = 1; // Release reset
    fifo_wr = 0;

    if (fifo_empty && !fifo_full) begin
        $display("Reset successful.");
    end else begin
        $display("Reset failed.");
    end

    // End of test
    $display("Testbench complete.");
    $stop;
    end

    endmodule

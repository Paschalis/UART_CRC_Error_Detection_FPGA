// Testbench for Top-Level UART with CRC Error Detection Module
module uart_crc_top_tb;

reg clk;                   // Clock signal
reg reset;                 // Reset signal
reg [7:0] tx_data_in;      // 8-bit data input for transmission
reg tx_start;              // Transmit start signal
wire [7:0] rx_data_out;    // 8-bit data output from reception
wire rx_ready_out;         // Receive ready flag
wire crc_valid_out;        // CRC validity flag

// Instantiate the top-level module
uart_crc_top dut (
    .clk(clk),
    .reset(reset),
    .tx_data_in(tx_data_in),
    .tx_start(tx_start),
    .rx_data_out(rx_data_out),
    .rx_ready_out(rx_ready_out),
    .crc_valid_out(crc_valid_out)
);

// Generate a clock signal with a period of 10 time units
always #5 clk = ~clk;

initial begin
    clk = 0;              // Initialize clock
    reset = 1;            // Assert reset
    tx_data_in = 8'b0;    // Initialize data input
    tx_start = 0;         // Initialize transmit start signal
    #10 reset = 0;        // Deassert reset after 10 time units
end

initial begin
    tx_data_in = 8'b10101010; // Load data to be transmitted
    tx_start = 1;             // Start transmission
    #10 tx_start = 0;         // Deassert transmit start signal
    #100;                     // Wait for reception to complete
    if (rx_ready_out && crc_valid_out) // Check if data received and CRC is valid
        $display("Received data: %b, CRC valid: 1", rx_data_out); // Print received data
    else
        $display("Error: Data invalid or CRC not valid"); // Print error message
    #10;
    $finish;                 // End simulation
end

endmodule

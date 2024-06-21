// Top-Level Module for UART with CRC Error Detection
module uart_crc_top (
    input wire clk,           // Clock input
    input wire reset,         // Reset input
    input wire [7:0] tx_data_in, // 8-bit data input for transmission
    input wire tx_start,      // Transmit start signal
    output wire [7:0] rx_data_out, // 8-bit data output from reception
    output wire rx_ready_out, // Receive ready flag
    output wire crc_valid_out // CRC validity flag
);

wire tx_out, tx_busy, rx_ready;
wire [7:0] rx_data;
wire [7:0] tx_crc, rx_crc;
reg data_valid;

// Instantiate UART Transmitter
uart_transmitter uart_tx (
    .clk(clk),
    .reset(reset),
    .data_in(tx_data_in),
    .crc_in(tx_crc),
    .tx_start(tx_start),
    .tx_out(tx_out),
    .tx_busy(tx_busy)
);

// Instantiate UART Receiver
uart_receiver uart_rx (
    .clk(clk),
    .reset(reset),
    .rx_in(tx_out),
    .data_out(rx_data),
    .crc_out(rx_crc),
    .rx_ready(rx_ready)
);

// Instantiate CRC Generator
crc_generator crc_gen (
    .clk(clk),
    .reset(reset),
    .data_in(tx_data_in),
    .crc_out(tx_crc)
);

// Data valid signal for CRC checking
always @(posedge clk or posedge reset) begin
    if (reset) begin
        data_valid <= 0;
    end else begin
        data_valid <= rx_ready; // Use rx_ready from uart_receiver
    end
end

// Instantiate CRC Checker
crc_checker crc_check (
    .clk(clk),
    .reset(reset),
    .data_in(rx_data),
    .crc_in(rx_crc),
    .crc_error(crc_valid_out) // Connect to crc_valid_out
);

assign rx_data_out = rx_data;   // Assign received data to output
assign rx_ready_out = rx_ready; // Assign receive ready flag to output

endmodule

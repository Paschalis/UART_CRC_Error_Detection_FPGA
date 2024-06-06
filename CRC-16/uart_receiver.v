// UART Receiver Module
module uart_receiver (
    input wire clk,        // Clock input
    input wire reset,      // Reset input
    input wire rx_in,      // Receive input
    output reg [7:0] data_out, // 8-bit data output
    output reg [15:0] crc_out, // 16-bit CRC output
    output reg rx_ready    // Receive ready flag
);

parameter BAUD_RATE = 9600;     // Baud rate parameter
localparam CLK_FREQ = 50000000; // System clock frequency
localparam BAUD_COUNTER_MAX = (CLK_FREQ / BAUD_RATE) - 1;

reg [4:0] bit_counter;          // Bit counter for tracking received bits
reg [10:0] baud_counter;        // Baud rate counter
reg [25:0] rx_shift_reg;        // Shift register for data reception

always @(posedge clk or posedge reset) begin
    if (reset) begin
        bit_counter <= 0;       // Reset bit counter
        baud_counter <= 0;      // Reset baud counter
        rx_ready <= 0;          // Reset receive ready flag
    end else if (!rx_ready) begin
        if (bit_counter == 0) begin
            // Wait for start bit
            if (rx_in == 0) begin // Start bit detected
                if (baud_counter == (BAUD_COUNTER_MAX / 2)) begin
                    baud_counter <= 0;         // Reset baud counter to sample in the middle
                    bit_counter <= 1;          // Start receiving bits
                end else begin
                    baud_counter <= baud_counter + 1; // Increment baud counter
                end
            end
        end else begin
            if (baud_counter == BAUD_COUNTER_MAX) begin
                baud_counter <= 0;                 // Reset baud counter
                rx_shift_reg <= {rx_in, rx_shift_reg[25:1]}; // Shift in received bit
                bit_counter <= bit_counter + 1;    // Increment bit counter
                if (bit_counter == 26) begin       // All bits received (1 start + 8 data + 16 CRC + 1 stop = 26)
                    data_out <= rx_shift_reg[23:16]; // Extract received data
                    crc_out <= rx_shift_reg[15:0]; // Extract received CRC
                    rx_ready <= 1;                 // Set receive ready flag
                    bit_counter <= 0;              // Reset bit counter
                end
            end else begin
                baud_counter <= baud_counter + 1;  // Increment baud counter
            end
        end
    end else begin
        // Reset rx_ready once data is read (assumption is rx_ready will be reset externally)
        rx_ready <= 0;
    end
end

endmodule

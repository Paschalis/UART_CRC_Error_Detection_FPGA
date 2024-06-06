// UART Receiver Module
module uart_receiver (
    input wire clk,           // Clock input
    input wire reset,         // Reset input
    input wire rx_in,         // Receive input
    output reg [7:0] data_out, // 8-bit data output
    output reg [7:0] crc_out, // 8-bit CRC output
    output reg rx_ready       // Receive ready flag
);

parameter BAUD_RATE = 9600;     // Baud rate parameter
localparam CLK_FREQ = 50000000; // System clock frequency
localparam BAUD_COUNTER_MAX = (CLK_FREQ / BAUD_RATE) - 1;
localparam HALF_BAUD_COUNTER = BAUD_COUNTER_MAX / 2;

reg [3:0] bit_counter;          // Bit counter for tracking received bits
reg [10:0] baud_counter;        // Baud rate counter
reg [17:0] rx_shift_reg;        // Shift register for data reception
reg sampling;                   // Sampling flag

always @(posedge clk or posedge reset) begin
    if (reset) begin
        bit_counter <= 0;        // Reset bit counter
        baud_counter <= 0;       // Reset baud counter
        sampling <= 0;           // Reset sampling flag
        rx_ready <= 0;           // Reset receive ready flag
    end else begin
        if (!sampling && !rx_in) begin
            sampling <= 1;       // Start sampling on start bit detection
            baud_counter <= 0;   // Reset baud counter
        end
        if (sampling) begin
            if (baud_counter == BAUD_COUNTER_MAX) begin
                rx_shift_reg <= {rx_in, rx_shift_reg[17:1]}; // Shift in the received bit
                baud_counter <= 0; // Reset baud counter
                bit_counter <= bit_counter + 1; // Increment bit counter
                if (bit_counter == 17) begin // If all bits are received
                    data_out <= rx_shift_reg[8:1]; // Extract data from shift register
                    crc_out <= rx_shift_reg[16:9]; // Extract CRC from shift register
                    rx_ready <= 1; // Set receive ready flag
                    sampling <= 0; // Stop sampling
                end
            end else begin
                baud_counter <= baud_counter + 1; // Increment baud counter
            end
        end else begin
            rx_ready <= 0; // Reset receive ready flag
        end
    end
end

endmodule

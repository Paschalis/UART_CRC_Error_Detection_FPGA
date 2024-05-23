// UART Receiver Module
module uart_receiver (
    input wire clk,        // Clock input
    input wire reset,      // Reset input
    input wire rx_in,      // Receive input
    output reg [7:0] data_out, // 8-bit data output
    output reg [15:0] crc_out, // 16-bit CRC output
    output reg rx_ready    // Receive ready flag
);

parameter BAUD_RATE = 9600; // Baud rate parameter
reg [4:0] bit_counter;      // Bit counter for tracking received bits
reg [10:0] baud_counter;    // Baud rate counter
reg [25:0] rx_shift_reg;    // Shift register for data reception

always @(posedge clk or posedge reset) begin
    if (reset) begin
        bit_counter <= 0;    // Reset bit counter
        baud_counter <= 0;   // Reset baud counter
        rx_ready <= 0;       // Reset receive ready flag
    end else if (!rx_ready && rx_in == 0) begin // Start bit detected
        if (baud_counter == (50000000 / BAUD_RATE / 2) - 1) begin
            baud_counter <= 0;                 // Reset baud counter
            bit_counter <= 1;                  // Start receiving bits
        end else begin
            baud_counter <= baud_counter + 1;  // Increment baud counter
        end
    end else if (bit_counter > 0) begin
        if (baud_counter == (50000000 / BAUD_RATE) - 1) begin
            baud_counter <= 0;                 // Reset baud counter
            rx_shift_reg <= {rx_in, rx_shift_reg[25:1]}; // Shift in received bit
            bit_counter <= bit_counter + 1;    // Increment bit counter
            if (bit_counter == 26) begin       // All bits received
                data_out <= rx_shift_reg[23:16]; // Extract received data
                crc_out <= rx_shift_reg[15:0]; // Extract received CRC
                rx_ready <= 1;                 // Set receive ready flag
                bit_counter <= 0;              // Reset bit counter
            end
        end else begin
            baud_counter <= baud_counter + 1;  // Increment baud counter
        end
    end
end

endmodule

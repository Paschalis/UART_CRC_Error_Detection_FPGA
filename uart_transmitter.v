// UART Transmitter Module
module uart_transmitter (
    input wire clk,        // Clock input
    input wire reset,      // Reset input
    input wire [7:0] data_in, // 8-bit data input
    input wire [15:0] crc_in, // 16-bit CRC input
    input wire tx_start,   // Transmit start signal
    output reg tx_out,     // Transmit output
    output reg tx_busy     // Transmit busy flag
);

parameter BAUD_RATE = 9600; // Baud rate parameter
reg [4:0] bit_counter;      // Bit counter for tracking transmitted bits
reg [10:0] baud_counter;    // Baud rate counter
reg [25:0] tx_shift_reg;    // Shift register for data transmission

always @(posedge clk or posedge reset) begin
    if (reset) begin
        bit_counter <= 0;    // Reset bit counter
        baud_counter <= 0;   // Reset baud counter
        tx_out <= 1;         // Set tx_out to idle state (high)
        tx_busy <= 0;        // Set tx_busy to not busy
    end else if (tx_start && !tx_busy) begin
        tx_shift_reg <= {1'b1, crc_in, data_in, 1'b0}; // Load data with start and stop bits
        tx_busy <= 1;         // Set tx_busy to busy
    end else if (tx_busy) begin
        if (baud_counter == (50000000 / BAUD_RATE) - 1) begin
            tx_out <= tx_shift_reg[0];           // Transmit the least significant bit
            tx_shift_reg <= {1'b0, tx_shift_reg[25:1]}; // Shift right
            baud_counter <= 0;                   // Reset baud counter
            bit_counter <= bit_counter + 1;      // Increment bit counter
            if (bit_counter == 26) begin
                tx_busy <= 0;                    // Transmission complete, reset tx_busy
                bit_counter <= 0;                // Reset bit counter
            end
        end else begin
            baud_counter <= baud_counter + 1;    // Increment baud counter
        end
    end
end

endmodule

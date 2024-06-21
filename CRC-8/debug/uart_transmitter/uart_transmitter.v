// UART Transmitter Module
module uart_transmitter (
    input wire clk,           // Clock input
    input wire reset,         // Reset input
    input wire [7:0] data_in, // 8-bit data input
    input wire [7:0] crc_in,  // 8-bit CRC input
    input wire tx_start,      // Transmit start signal
    output reg tx_out,        // Transmit output
    output reg tx_busy        // Transmit busy flag
);

parameter BAUD_RATE = 9600;     // Baud rate parameter
localparam CLK_FREQ = 50000000; // System clock frequency
localparam BAUD_COUNTER_MAX = (CLK_FREQ / BAUD_RATE) - 1; // 5207

reg [4:0] bit_counter;          // Bit counter for tracking transmitted bits (5 bits for 18-bit max)
reg [12:0] baud_counter;        // Baud rate counter (13 bits for max 5207)
reg [17:0] tx_shift_reg;        // Shift register for data transmission

always @(posedge clk or posedge reset) begin
    if (reset) begin
        bit_counter <= 0;        // Reset bit counter
        baud_counter <= 0;       // Reset baud counter
        tx_out <= 1;             // Set tx_out to idle state (high)
        tx_busy <= 0;            // Set tx_busy to not busy
        $display("Transmitter reset.");
    end else if (tx_start && !tx_busy) begin
        // Load tx_shift_reg with start bit (0), data_in, crc_in, and stop bit (1)
        tx_shift_reg <= {1'b1, crc_in, data_in, 1'b0}; 
        tx_busy <= 1;            // Set tx_busy to busy
        bit_counter <= 0;        // Reset bit counter for new transmission
        baud_counter <= 0;       // Reset baud counter
        tx_out <= 0;             // Start bit
        $display("Transmitter started: Data to transmit: %b, CRC: %b", data_in, crc_in);
    end else if (tx_busy) begin
        if (baud_counter == BAUD_COUNTER_MAX) begin
            tx_out <= tx_shift_reg[0];               // Transmit the least significant bit
            tx_shift_reg <= tx_shift_reg >> 1;       // Shift the register right
            baud_counter <= 0;                       // Reset baud counter
            bit_counter <= bit_counter + 1;          // Increment bit counter
            $display("Transmitting bit: %b, Bit counter: %d, Baud counter: %d, Shift reg: %b", tx_out, bit_counter, baud_counter, tx_shift_reg);
            if (bit_counter == 17) begin             // If all bits are transmitted
                tx_busy <= 0;                        // Set tx_busy to not busy
                tx_out <= 1;                         // Set tx_out to idle state (high)
                $display("Transmission complete.");
            end
        end else begin
            baud_counter <= baud_counter + 1;        // Increment baud counter
            $display("Incrementing baud_counter: %d", baud_counter);
        end
    end
end

endmodule

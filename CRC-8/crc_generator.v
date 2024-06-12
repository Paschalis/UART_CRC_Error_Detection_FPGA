// CRC Generator Module (CRC-8)
module crc_generator (
    input wire clk,           // Clock input
    input wire reset,         // Reset input
    input wire [7:0] data_in, // 8-bit data input
    output reg [7:0] crc_out  // 8-bit CRC output
);

reg [7:0] crc;

// CRC-8 polynomial: x^8 + x^2 + x + 1 (0x07)

// Sequential Feedback Implementation
always @(posedge clk or posedge reset) begin
    if (reset) begin
        crc <= 8'b0; // Reset CRC
    end else begin
        crc <= crc ^ data_in;
        crc <= {crc[6:0], 1'b0} ^ (crc[7] ? 8'b00000111 : 8'b0);
        crc <= {crc[5:0], 2'b00} ^ (crc[6] ? 8'b00000111 : 8'b0);
        crc <= {crc[4:0], 3'b000} ^ (crc[5] ? 8'b00000111 : 8'b0);
        crc <= {crc[3:0], 4'b0000} ^ (crc[4] ? 8'b00000111 : 8'b0);
        crc <= {crc[2:0], 5'b00000} ^ (crc[3] ? 8'b00000111 : 8'b0);
        crc <= {crc[1:0], 6'b000000} ^ (crc[2] ? 8'b00000111 : 8'b0);
        crc <= {crc[0], 7'b0000000} ^ (crc[1] ? 8'b00000111 : 8'b0);
        crc_out <= crc;
    end
end

// // Iterative Shift and XOR Implementation (Compact Version)
// always @(posedge clk or posedge reset) begin
//     if (reset) begin
//         crc <= 8'b0; // Reset CRC
//     end else begin
//         integer i;
//         crc = crc ^ data_in; // XOR input data with current CRC
//         for (i = 0; i < 8; i = i + 1) begin
//             if (crc[7]) begin
//                 crc = (crc << 1) ^ 8'b00000111; // Apply feedback if MSB is 1
//             end else begin
//                 crc = crc << 1; // Shift left if MSB is 0
//             end
//         end
//         crc_out <= crc; // Update CRC output
//     end
// end


endmodule

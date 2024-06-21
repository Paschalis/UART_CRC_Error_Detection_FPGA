module crc_generator (
    input wire clk,         // Clock input
    input wire reset,       // Reset input
    input wire [7:0] data_in, // 8-bit data input
    output reg [7:0] crc_out // 8-bit CRC output
);
    parameter POLYNOMIAL = 8'h07; // CRC-8 polynomial (x^8 + x^2 + x + 1)
    reg [7:0] crc_register;       // CRC register

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            crc_register <= 8'h00; // Initialize CRC register to 0 on reset
            crc_out <= 8'h00;      // Initialize CRC output to 0 on reset
        end else begin
            // Shift register and calculate CRC
            if (crc_register[7]) begin
                crc_register <= {crc_register[6:0], 1'b0} ^ POLYNOMIAL;
            end else begin
                crc_register <= crc_register << 1;
            end
            
            // XOR CRC with new data
            crc_register <= crc_register ^ data_in;
            crc_out <= crc_register; // Update CRC output
        end
    end
endmodule


// module crc_generator (
//     input wire clk,           // Clock input
//     input wire reset,         // Reset input
//     input wire [7:0] data_in, // 8-bit data input
//     output reg [7:0] crc_out  // 8-bit CRC output
// );

// reg [7:0] crc;

// // CRC-8 polynomial: x^8 + x^2 + x + 1 (0x07)

// // Sequential Feedback Implementation
// always @(posedge clk or posedge reset) begin
//     if (reset) begin
//         crc <= 8'b0; // Reset CRC
//     end else begin
//         crc <= crc ^ data_in;
//         crc <= {crc[6:0], 1'b0} ^ (crc[7] ? 8'b00000111 : 8'b0);
//         crc <= {crc[5:0], 2'b00} ^ (crc[6] ? 8'b00000111 : 8'b0);
//         crc <= {crc[4:0], 3'b000} ^ (crc[5] ? 8'b00000111 : 8'b0);
//         crc <= {crc[3:0], 4'b0000} ^ (crc[4] ? 8'b00000111 : 8'b0);
//         crc <= {crc[2:0], 5'b00000} ^ (crc[3] ? 8'b00000111 : 8'b0);
//         crc <= {crc[1:0], 6'b000000} ^ (crc[2] ? 8'b00000111 : 8'b0);
//         crc <= {crc[0], 7'b0000000} ^ (crc[1] ? 8'b00000111 : 8'b0);
//         crc_out <= crc;
//     end
// end

// /*
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
// */

// endmodule

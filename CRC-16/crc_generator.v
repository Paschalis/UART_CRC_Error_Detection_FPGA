// CRC Generator Module
module crc_generator (
    input wire clk,           // Clock input
    input wire reset,         // Reset input
    input wire [7:0] data_in, // 8-bit data input
    output reg [15:0] crc_out // 16-bit CRC output
);

reg [15:0] crc_reg;          // CRC register

always @(posedge clk or posedge reset) begin
    if (reset) begin
        crc_reg <= 16'b0;    // Reset CRC register
    end else begin
        crc_reg <= crc16_next(crc_reg, data_in);
    end
end

function [15:0] crc16_next(input [15:0] crc, input [7:0] data);
    reg [15:0] crc_next;
    reg [3:0] i;
    begin
        crc_next = crc ^ {8'b0, data};
        for (i = 0; i < 8; i = i + 1) begin
            if (crc_next[15]) begin
                crc_next = (crc_next << 1) ^ 16'h1021;
            end else begin
                crc_next = crc_next << 1;
            end
        end
        crc16_next = crc_next;
    end
endfunction

always @(posedge clk or posedge reset) begin
    if (reset) begin
        crc_out <= 16'b0;   // Reset CRC output
    end else begin
        crc_out <= crc_reg; // Update CRC output
    end
end

endmodule

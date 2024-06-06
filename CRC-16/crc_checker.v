// CRC Checker Module
module crc_checker (
    input wire clk,         // Clock input
    input wire reset,       // Reset input
    input wire [7:0] data_in, // 8-bit data input
    input wire [15:0] crc_in, // 16-bit CRC input
    input wire data_valid,  // Signal indicating data_in is valid
    output reg crc_valid    // CRC validity flag
);

reg [15:0] crc_reg;         // CRC register

always @(posedge clk or posedge reset) begin
    if (reset) begin
        crc_reg <= 16'b0;   // Reset CRC register
        crc_valid <= 0;     // Reset CRC valid flag
    end else if (data_valid) begin
        crc_reg <= crc16_next(crc_reg, data_in); // Update CRC with next data byte
    end
end

always @(posedge clk or posedge reset) begin
    if (reset) begin
        crc_valid <= 0;     // Reset CRC valid flag
    end else if (data_valid) begin
        // Check if CRC matches after the complete data stream has been processed
        if (crc_reg == crc_in) begin
            crc_valid <= 1'b1; // Set CRC valid flag if CRC matches
        end else begin
            crc_valid <= 1'b0; // Reset CRC valid flag if CRC does not match
        end
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

endmodule


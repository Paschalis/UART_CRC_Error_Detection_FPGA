`timescale 1ns / 1ps

module uart_transmitter_tb;

// Testbench signals
reg clk;
reg reset;
reg [7:0] data_in;
reg [7:0] crc_in;
reg tx_start;
wire tx_out;
wire tx_busy;

// Instantiate the UART Transmitter
uart_transmitter uut (
    .clk(clk),
    .reset(reset),
    .data_in(data_in),
    .crc_in(crc_in),
    .tx_start(tx_start),
    .tx_out(tx_out),
    .tx_busy(tx_busy)
);

// Clock generation
initial begin
    clk = 0;
    forever #10 clk = ~clk; // 50 MHz clock
end

// Testbench procedure
initial begin
    // Open VCD file for GTKWave
    $dumpfile("uart_transmitter_tb.vcd");
    $dumpvars(0, uart_transmitter_tb);
    
    // Initialize signals
    reset = 1;
    data_in = 8'b00000000; // Initialize with binary value
    crc_in = 8'b00000000;  // Initialize with binary value
    tx_start = 0;

    // Apply reset
    #100;
    reset = 0;
    #20;
    
    // Test 1: Transmit data 0b01010101 (0x55) with CRC 0b10100011 (0xA3)
    data_in = 8'b01010101; // Binary value for 0x55
    crc_in = 8'b10100011;  // Binary value for 0xA3
    tx_start = 1;
    #20;
    tx_start = 0;
    
    // Wait for transmission to complete
    wait(tx_busy == 0);
    
    // Test 2: Transmit data 0b10101011 (0xAB) with CRC 0b01011111 (0x5F)
    #1000; // Wait for some time before next test
    data_in = 8'b10101011; // Binary value for 0xAB
    crc_in = 8'b01011111;  // Binary value for 0x5F
    tx_start = 1;
    #20;
    tx_start = 0;
    
    // Wait for transmission to complete
    wait(tx_busy == 0);
    
    // Test 3: Transmit data 0b11111111 (0xFF) with CRC 0b00000000 (0x00)
    #1000; // Wait for some time before next test
    data_in = 8'b11111111; // Binary value for 0xFF
    crc_in = 8'b00000000;  // Binary value for 0x00
    tx_start = 1;
    #20;
    tx_start = 0;
    
    // Wait for transmission to complete
    wait(tx_busy == 0);

    // End simulation
    #1000;
    $finish;
end

// Monitor and check the outputs
initial begin
    $monitor("Time: %0d, Reset: %b, Data: %b, CRC: %b, TX Start: %b, TX Out: %b, TX Busy: %b",
             $time, reset, data_in, crc_in, tx_start, tx_out, tx_busy);
end

endmodule

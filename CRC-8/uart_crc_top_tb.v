module uart_crc_top_tb;

    reg clk;                   // Clock signal
    reg reset;                 // Reset signal
    reg [7:0] tx_data_in;      // 8-bit data input for transmission
    reg tx_start;              // Transmit start signal
    wire [7:0] rx_data_out;    // 8-bit data output from reception
    wire rx_ready_out;         // Receive ready flag
    wire crc_valid_out;        // CRC validity flag

    // Instantiate the top-level module
    uart_crc_top dut (
        .clk(clk),
        .reset(reset),
        .tx_data_in(tx_data_in),
        .tx_start(tx_start),
        .rx_data_out(rx_data_out),
        .rx_ready_out(rx_ready_out),
        .crc_valid_out(crc_valid_out)
    );

    // Generate a clock signal with a period of 10 time units
    always #5 clk = ~clk;

    initial begin
        clk = 0;              // Initialize clock
        reset = 1;            // Assert reset
        tx_data_in = 8'b0;    // Initialize data input
        tx_start = 0;         // Initialize transmit start signal
        #20 reset = 0;        // Deassert reset after 20 time units
    end

    initial begin
        // Wait a bit after reset is deasserted
        #30;
        
        // Test case 1: Simple pattern
        tx_data_in = 8'b10101010; // Load data to be transmitted
        tx_start = 1;             // Start transmission
        #10 tx_start = 0;         // Deassert transmit start signal
        wait (rx_ready_out);      // Wait for reception to complete
        #10;
        if (crc_valid_out)        // Check if CRC is valid
            $display("Test Case 1 Passed: Received data: %b, CRC valid", rx_data_out); // Print received data
        else
            $display("Test Case 1 Failed: CRC not valid"); // Print error message

        // Test case 2: Different pattern
        #100;                     // Wait before next test case
        tx_data_in = 8'b11001100; // Load different data to be transmitted
        tx_start = 1;             // Start transmission
        #10 tx_start = 0;         // Deassert transmit start signal
        wait (rx_ready_out);      // Wait for reception to complete
        #10;
        if (crc_valid_out)        // Check if CRC is valid
            $display("Test Case 2 Passed: Received data: %b, CRC valid", rx_data_out); // Print received data
        else
            $display("Test Case 2 Failed: CRC not valid"); // Print error message

        // // Test case 3: All ones
        // #100;                     // Wait before next test case
        // tx_data_in = 8'b11111111; // Load another different data to be transmitted
        // tx_start = 1;             // Start transmission
        // #10 tx_start = 0;         // Deassert transmit start signal
        // wait (rx_ready_out);      // Wait for reception to complete
        // #10;
        // if (crc_valid_out)        // Check if CRC is valid
        //     $display("Test Case 3 Passed: Received data: %b, CRC valid", rx_data_out); // Print received data
        // else
        //     $display("Test Case 3 Failed: CRC not valid"); // Print error message

        // // Test case 4: Mixed pattern
        // #100;                     // Wait before next test case
        // tx_data_in = 8'b01010101; // Load another different data to be transmitted
        // tx_start = 1;             // Start transmission
        // #10 tx_start = 0;         // Deassert transmit start signal
        // wait (rx_ready_out);      // Wait for reception to complete
        // #10;
        // if (crc_valid_out)        // Check if CRC is valid
        //     $display("Test Case 4 Passed: Received data: %b, CRC valid", rx_data_out); // Print received data
        // else
        //     $display("Test Case 4 Failed: CRC not valid"); // Print error message

        // // Test case 5: Random pattern
        // #100;                           // Wait before next test case
        // tx_data_in = 8'b10101100;       // Load a random data pattern to be transmitted
        // tx_start = 1;                   // Start transmission
        // #10 tx_start = 0;               // Deassert transmit start signal
        // wait (rx_ready_out);            // Wait for reception to complete
        // #10;
        // if (crc_valid_out)              // Check if CRC is valid
        //     $display("Test Case 5 Passed: Received data: %b, CRC valid", rx_data_out); // Print received data
        // else
        //     $display("Test Case 5 Failed: CRC not valid"); // Print error message

        #100;
        $finish;                 // End simulation
    end

    // Value Change Dump (VCD) statements 
    initial begin
        $dumpfile("uart_crc_top_tb.vcd"); // Specify the VCD file name
        $dumpvars(0, uart_crc_top_tb);    // Dump all variables in the testbench
    end

endmodule

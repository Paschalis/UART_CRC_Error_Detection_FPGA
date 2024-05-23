# UART with CRC Error Detection on FPGA

This repository contains the code and materials for the "Implement and evaluate an error resilient technique on hardware (RTL/Synthesis)" project, part of the course "ΜΔΕ618 Αξιόπιστα Συστήματα" (PGS618 Dependable Systems), as part of the curriculum of the Department of Electrical and Computer Engineering which belongs to the School of Engineering of the University of Thessaly.

## Introduction

UART (Universal Asynchronous Receiver/Transmitter) is a hardware communication protocol that allows asynchronous serial communication between devices. CRC (Cyclic Redundancy Check) is an error-detecting code commonly used to detect accidental changes to raw data. By combining UART with CRC, we can ensure that the data transmitted is received correctly, thus enhancing the reliability of communication.

## Files

- **uart_transmitter.v**: UART transmitter module with CRC integration.
- **uart_receiver.v**: UART receiver module with CRC extraction.
- **crc_generator.v**: CRC generator module using the CRC-16 polynomial (0x1021).
- **crc_checker.v**: CRC checker module that validates the received CRC.
- **uart_crc_top.v**: Top-level module integrating the UART and CRC components.
- **uart_crc_top_tb.v**: Testbench for the top-level module.

## Hardware Setup

1. **Nexys A7 FPGA Board**: Connect it to your computer via USB.
2. **UART-to-USB Adapter (optional)**: For easier UART communication with a PC.
3. **Computer**: To write, synthesize, and upload the Verilog code using Xilinx Vivado.
4. **Connection Cables**: For connecting the FPGA board to the UART adapter (if used).

## Steps to Implement and Evaluate

1. **Write the Verilog Code**: Copy the provided Verilog files into your project directory.
2. **Open Xilinx Vivado**: Create a new project and add the Verilog files.
3. **Synthesize and Implement**: Run synthesis and implementation in Vivado.
4. **Generate Bitstream**: Generate the bitstream file for your FPGA.
5. **Program FPGA**: Use Vivado to program the Nexys A7 FPGA with the generated bitstream.
6. **Test the Design**: Observe the UART transmission and reception. Verify that the CRC detects errors correctly.

## Testing

The provided testbench (`uart_crc_top_tb.v`) tests the UART communication and CRC error detection. Run the simulation in Vivado to ensure the data is transmitted and received correctly, and the CRC is validated.

## Authors

- [![Paschalis Moschogiannis](https://img.shields.io/badge/GitHub-Paschalis_Moschogiannis-00FFFF?style=flat&logo=github)](https://github.com/Paschalis)

- [![Vasileios Dimitriou](https://img.shields.io/badge/GitHub-Vasileios_Dimitriou-7FFF00?style=flat&logo=github)](https://github.com/Vasilisdi)

### Notes

- Ensure the correct baud rate is set for your system clock.
- Modify the testbench to include various test cases, including erroneous data for robust testing.

## License

This project is licensed under the [MIT License](LICENSE).

- [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
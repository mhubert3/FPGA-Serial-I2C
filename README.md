# FPGA I2C Master Communication Interface

## Description
This project implements an I²C master controller on a Xilinx Artix-7 FPGA (Digilent Cmod A7-35T). It features precise FSM control to manage start/stop conditions, ACK/NACK handling, and dynamic open-drain SDA/SCL signaling. The system interfaces with a PIC microcontroller to verify bidirectional serial data transfer protocols and timing compliance in hardware.

## Features
* **Cycle-Accurate FSM:** Handles all standard I2C protocol phases (Start, Address, Read/Write, Data, Repeated Start, Stop) with dynamic timing counters.
* **Open-Drain Signaling:** Implements bidirectional `inout` buffers (Vivado `IOBUF` primitives) and properly supports clock stretching by monitoring physical bus states.
* **Hardware Validation:** Integrates with a MATLAB GUI via UART to trigger real-time I2C transactions and visualize the received data payload.

## Directory Structure
* `src/`: Contains the VHDL design source files (`lab08.vhd`, `lab08_gui.vhd`).
* `tb/`: Contains the VHDL simulation testbench (`lab08_tb.vhd`).
* `constraints/`: Xilinx constraints mapping for the Cmod A7 (`lab08.xdc`).
* `scripts/`: MATLAB GUI script for hardware interfacing (`gui08.m`).
* `docs/`: Project specifications and datasheets.

## Tools Used
* **Languages:** VHDL, MATLAB
* **Hardware:** Digilent Cmod A7-35T (Artix-7), PIC16F18326 Microcontroller
* **Software:** Xilinx Vivado
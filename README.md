# VHDL I2C Master Controller

## Overview
This repository contains a fully synthesizable I2C Master controller implemented in VHDL. The project features a customized finite state machine (FSM) architecture designed to interface with peripheral microcontrollers and a host PC via a UART-based software GUI. 

This project was developed and tested on an FPGA development board, utilizing cycle-accurate simulations and hardware-in-the-loop verification to ensure strict protocol compliance over an open-drain bus.

## Architecture & State Machine Design



The design is broken into modular components:
* **`lab08` (Top-Level & I/O Buffering):** Integrates the GUI handler and the core I2C FSM. To bypass Vivado's power-on initialization limitations with `inout` ports, this module explicitly instantiates Xilinx `IOBUF` primitives. This cleanly separates the bidirectional open-drain `scl` and `sda` lines into distinct input and output paths.
* **I2C FSM (Master Controller):** A cycle-accurate state machine governing the generation of Start, Address (7-bit), Read/Write, Data, Acknowledge, Repeated Start, and Stop conditions. It implements dynamic clock stretching by actively polling the physical bus state (`scl_in = '0'`) before advancing internal timers, ensuring robust operation regardless of bus capacitance.
* **`lab08_gui` (UART-to-I2C Bridge):** Handles asynchronous serial communication with the host PC to trigger I2C transactions and relay the received payloads.

## Clock Domain & Timing Calculations



The system operates on a 12 MHz system clock (83.33 ns period). Standard I2C protocol strictly dictates that SCL and SDA lines must be held for a minimum of 5.0µs, with SDA transitions occurring at least 2.5µs after SCL transitions complete.

To achieve this without a static clock divider, the FSM utilizes integer delay thresholds calculated as follows:
* **5.0µs Delay:** `12,000,000 Hz / 1,000,000 * 5.0 = 60 clock cycles`
* **2.5µs Delay:** `12,000,000 Hz / 1,000,000 * 2.5 = 30 clock cycles`

The FSM resets and counts these exact cycles *only after* the physical bus lines transition to the correct logic levels, inherently supporting standard clock stretching.

## Verification
The design includes a robust VHDL testbench (`lab08_tb.vhd`) to validate open-drain signaling prior to synthesis. 
* The testbench instantiates the top-level module and explicitly drives the open-drain `scl` and `sda` lines to a weak high (`'H'`). 
* This accurately models the physical pull-up resistors on an actual I2C bus, verifying the FSM's ability to drive the bus low (`'0'`) and successfully release it to a high-impedance state, allowing it to float back to `'1'`.
* Hardware-in-the-loop verification was subsequently conducted by sending 8-bit payloads through a PIC16F18326 microcontroller to confirm real-time acknowledgment and data translation.

## Repository Structure
* `/src` - Synthesizable VHDL source code.
* `/tb` - VHDL simulation testbench modeling open-drain pull-ups.
* `/constraints` - XDC pin mapping for the 12 MHz clock and PMOD headers.
* `/scripts` - MATLAB GUI script for hardware interfacing.
* `/docs` - Project specifications and I2C datasheets.

## Technologies & Tools
* **Hardware Description Language:** VHDL
* **Development Board:** Digilent Cmod A7-35T (Xilinx Artix-7 XC7A35T FPGA)
* **Peripheral Hardware:** Microchip PIC16F18326 Microcontroller (Target Slave Device)
* **EDA Tools:** Xilinx Vivado (Synthesis, Place & Route, Bitstream Generation), Vivado XSIM (RTL Simulation)
* **Software Integration:** MATLAB (Hardware-in-the-Loop UART GUI)
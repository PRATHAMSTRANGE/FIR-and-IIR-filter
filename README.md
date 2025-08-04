# FIR-and-IIR-filter
# Real-Time FIR and IIR Filters on FPGA

This project implements **real-time FIR and IIR digital filters** on the **ZedBoard FPGA** (xc7z020clg484-1) using **Vivado**. It captures audio input through a PMOD microphone and outputs filtered audio using a PMOD DAC. The system supports runtime configuration of filter coefficients and enables direct comparison with software-based filtering for validation and performance analysis.

## 🎯 Objectives

- Implement real-time **FIR** and **IIR** filters on FPGA
- Support **dynamic coefficient configuration**
- Perform **live audio filtering** using PMOD peripherals
- Compare hardware and software filtered outputs for performance analysis

## 🛠️ Tools & Hardware

- **FPGA Board**: ZedBoard (Zynq-7000 SoC, xc7z020clg484-1)
- **Software**: Vivado (for design and synthesis), MATLAB/Python (for comparison)
- **Peripherals**:
  - [PMOD MIC3](https://digilent.com/shop/pmod-mic3-digital-microphone/)
  - [PMOD DA2](https://digilent.com/shop/pmod-da2-four-channel-12-bit-dac/)

## ⚙️ System Architecture

[PMOD MIC] → [ADC Interface] → [FIR/IIR Filter on FPGA] → [DAC Interface] → [PMOD DA2]
↑
[Coefficient Configuration (HDL or AXI-mapped)]

## 🧠 Filter Architecture

### FIR Filter
- Finite impulse response
- Feedforward structure only
- Stable and can be designed with linear phase
- More coefficients required for sharp roll-off

### IIR Filter
- Infinite impulse response with feedback
- Requires fewer coefficients for comparable performance
- Higher efficiency but potential for instability
- Designed based on analog filter prototypes (e.g., Butterworth)

## ✅ Features
- Real-time digital filtering on audio inputs
- Configurable coefficients (HDL parameters or AXI-lite interface)
- ILA-based signal probing for debug and verification
- Software reference models for comparison

## 🧪 Validation
- Input signals filtered using both FPGA and MATLAB/Python
- Time-domain and frequency-domain plots analyzed
- Internal FPGA signals observed using Vivado ILA

## 🚀 Getting Started
1. Clone the repository and open in Vivado
2. Connect PMOD MIC to JA, PMOD DA2 to JB on ZedBoard
3. Generate bitstream and program the FPGA
4. Inject test audio or signal into PMOD MIC
5. Observe output via oscilloscope or speaker through PMOD DA2


**Developed by**: Prathamesh Pise  
**Institute**: BITS Pilani, Goa Campus


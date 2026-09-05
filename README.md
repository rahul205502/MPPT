# FPGA-Based Solar MPPT Controller

An FPGA-based Maximum Power Point Tracking (MPPT) controller for a photovoltaic (PV) system using the **Perturb and Observe (P&O)** algorithm.

The project implements the MPPT control logic in SystemVerilog and is intended to interface with voltage/current measurement data and a PWM-controlled power stage.

---

## Overview

A solar panel does not operate at its maximum power point under all operating conditions. The maximum power point changes with factors such as solar irradiance and temperature.

This project implements a digital MPPT controller that continuously measures the PV voltage and current, calculates the generated power, and adjusts the converter duty cycle to track the maximum power point.

The basic control loop is:

```text
       PV Voltage (V)
              │
              │
              ▼
       ┌─────────────┐
       │             │
       │ Power       │◄──── PV Current (I)
       │ Calculation │
       │             │
       └──────┬──────┘
              │
              ▼
       ┌─────────────┐
       │ Averaging   │
       └──────┬──────┘
              │
              ▼
       ┌─────────────┐
       │ P&O MPPT    │
       │ Controller  │
       └──────┬──────┘
              │
        ┌─────┴─────┐
        │           │
    inc_duty     dec_duty
        │           │
        └─────┬─────┘
              │
              ▼
       ┌─────────────┐
       │ Duty Cycle  │
       │ Controller  │
       └──────┬──────┘
              │
              ▼
       ┌─────────────┐
       │ PWM         │
       │ Generator   │
       └──────┬──────┘
              │
              ▼
        Power Converter
              │
              ▼
          PV System

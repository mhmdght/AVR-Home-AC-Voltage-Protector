# ⚡ AC Voltage Protector for AVR Microcontrollers

A compact and reliable **AC mains voltage protection system** designed for **220V / 50Hz** power systems.

This repository contains two independent implementations of the same voltage protection circuit, targeting different AVR microcontrollers and development environments while sharing the same protection logic.

* **ATtiny13** — Firmware written in **C (CodeVisionAVR)**
* **ATtiny25** — Firmware written in **BASCOM-AVR (BASIC)**

The project continuously monitors the mains voltage through an analog sensing circuit. If the measured voltage moves outside the predefined safe operating range, the relay disconnects the load to protect connected equipment. After the voltage returns to a safe level, the controller reconnects the output following the configured protection sequence.

---

# Features

* Under-voltage protection
* Over-voltage protection
* Automatic recovery after voltage normalization
* Relay-controlled output
* LED status indication
* Low-cost AVR implementation
* Complete Proteus simulation
* Two firmware implementations
* Easy to modify and customize

---

# Repository Structure

```text
Voltage-Protector/
│
├── Firmware/
│   ├── ATtiny13/
│   │   ├── code.c
│   │   └── protector.hex
│   │
│   └── ATtiny25/
│       ├── code.bas
│       └── protector.hex
│
├── Proteus/
│
├── Images/
│
└── README.md
```

---

# Project Overview

The controller samples the output of an AC voltage sensing circuit using its internal Analog-to-Digital Converter (ADC).

The measured voltage is continuously compared with predefined protection thresholds.

Depending on the measured voltage, the controller performs one of the following actions:

* Enables the relay during normal operating conditions
* Disconnects the load during under-voltage
* Disconnects the load during over-voltage
* Indicates the current operating state using LEDs
* Automatically reconnects the load once the voltage becomes stable again

The protection algorithm is identical in both firmware versions, while the implementation differs according to the selected microcontroller and programming language.

---

## Firmware Specifications

| Parameter | ATtiny13 Version | ATtiny25 Version |
|-----------|------------------|------------------|
| Microcontroller | ATtiny13 | ATtiny25 |
| Programming Language | C | BASIC |
| Development Environment | CodeVisionAVR | BASCOM-AVR |
| CPU Clock | **9.6 MHz** | **8 MHz** |
| Clock Source | Internal RC Oscillator | Internal RC Oscillator |
| ADC Resolution | 8-bit (Left Adjusted) | 10-bit |
| ADC Reference Voltage | **AVCC (VCC)** | **Internal 1.1 V** |
| Voltage Sensing Input | ADC2 (PB4) | ADC2 (PB4) |
| Output Control | Relay | Relay |
| Status Indicators | Green / Yellow / Red LEDs | Green / Yellow / Red LEDs |
| Target AC System | 220 V / 50 Hz | 220 V / 50 Hz |
| Proteus Simulation | ✔ Included | ✔ Included |

### Notes

- Both firmware versions implement the same voltage protection algorithm while targeting different AVR microcontrollers and development environments.
- The **ATtiny13** firmware is written in **C** using **CodeVisionAVR** and uses an **8-bit left-adjusted ADC** with **AVCC (VCC)** as the ADC reference.
- The **ATtiny25** firmware is written in **BASCOM-AVR (BASIC)** and uses the **full 10-bit ADC resolution** with the **internal 1.1 V reference**, providing higher measurement precision.
- The firmware source code, compiled HEX files, and Proteus simulation projects are included for both implementations.

---

# Operating States

The firmware operates in several logical states:

### Normal

* Relay ON
* Green LED ON
* Load connected

---

### Warning

* Relay OFF
* Red LED indicates a voltage fault
* Load disconnected

---

### Recovery

After the input voltage returns to the acceptable operating range, the controller executes its recovery procedure before reconnecting the load.

---

# LED Indicators

| LED       | Description              |
| --------- | ------------------------ |
| 🟢 Green  | Normal operation         |
| 🟡 Yellow | Recovery / waiting state |
| 🔴 Red    | Voltage fault            |

---

# Hardware

The project is built around a simple analog front-end and an AVR microcontroller.

Typical hardware consists of:

* AVR Microcontroller
* AC voltage sensing circuit
* Relay
* Relay driver transistor
* Indicator LEDs
* Power supply section
* Protection components

---

# Proteus Simulation

The repository includes complete Proteus simulation files for both firmware versions.

Simulation allows testing of:

* Normal voltage operation
* Under-voltage condition
* Over-voltage condition
* Relay switching
* LED indications
* Complete protection sequence

---

# Building the Firmware

## ATtiny13

* IDE: CodeVisionAVR
* Language: C

Compile the project and generate the HEX file for programming.

---

## ATtiny25

* IDE: BASCOM-AVR
* Language: BASIC

Compile the BASCOM project to generate the HEX file.

---

# Project Goals

This project was developed as a simple and inexpensive household voltage protection solution.

It is intended for:

* Learning AVR programming
* Learning ADC-based voltage monitoring
* Relay control applications
* Proteus simulation studies
* Embedded systems education
* Personal and hobby projects

---

# Possible Improvements

Future enhancements may include:

* EEPROM configurable parameters
* User-adjustable voltage thresholds
* LCD/OLED display
* Digital voltage measurement
* Event logging
* Watchdog support
* Brown-Out Detection (BOD)
* Timer-based software architecture
* Additional fault diagnostics

---

# Images

It is recommended to include the following images inside the repository:

```text
Images/
├── ActoDC.png
├── System.png
└── relay-operation.gif
```

These images help users understand the hardware and simulation without opening Proteus.

---

## License

This project is licensed under the GNU General Public License v3.0 (GPL-3.0).

You are free to use, modify, and distribute this project under the terms of the GPL-3.0 license.

Any derivative work distributed to others must also be released under the GPL-3.0 license, with its corresponding source code made available.

---

# Contributing

Contributions, improvements, bug reports and pull requests are always welcome.

If you discover an issue or have an idea for improving the project, feel free to open an Issue or submit a Pull Request.

---

# Disclaimer

⚠️ **Warning**

This project interfaces with **AC mains voltage**.

Working with high-voltage circuits can be dangerous.

The Proteus simulations are provided for educational and development purposes. Any real-world implementation should be thoroughly tested and follow appropriate electrical safety practices.

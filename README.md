# PicoRV32 RISC-V Core — RTL-to-GDSII Physical Design using OpenLane

![Status](https://img.shields.io/badge/Status-In%20Progress-yellow)
![PDK](https://img.shields.io/badge/PDK-SkyWater%20130nm-blue)
![Tool](https://img.shields.io/badge/Tool-OpenLane%20v2-green)
![Design](https://img.shields.io/badge/Design-PicoRV32%20RISC--V-orange)

---

## Overview

This project implements the complete Physical Design flow for the **PicoRV32 RISC-V processor**,
taking it from RTL (Verilog) all the way to GDSII layout using the **OpenLane** open-source
RTL-to-GDSII framework on the **SkyWater 130nm (sky130A)** process node.

The project covers every stage of the ASIC Physical Design flow:
Synthesis → Floorplanning → Placement → CTS → Routing → STA → DRC/LVS → GDSII

---

## Project Specifications

| Parameter          | Details                            |
|--------------------|------------------------------------|
| Design             | PicoRV32 RISC-V Processor          |
| RTL Source         | picorv32.v (YosysHQ/picorv32)      |
| EDA Framework      | OpenLane v2                        |
| PDK                | SkyWater 130nm (sky130A)           |
| Target Frequency   | 40 MHz (25ns clock period)         |
| Core Utilization   | 40%                                |
| Placement Density  | 0.4                                |
| Synthesis Strategy | Area Optimized (AREA 0)            |
| Host OS            | Ubuntu 22.04 (WSL2 on Windows 10)  |

---

## Tools Used

| Tool         | Purpose                                    |
|--------------|--------------------------------------------|
| OpenLane v2  | RTL-to-GDSII automated flow framework      |
| Yosys        | RTL Synthesis                              |
| OpenROAD     | Floorplan, Placement, CTS, Routing, STA    |
| TritonCTS    | Clock Tree Synthesis                       |
| FastRoute    | Global Routing                             |
| TritonRoute  | Detailed Routing                           |
| OpenSTA      | Static Timing Analysis                     |
| Magic        | DRC, LVS, GDSII streaming                 |
| Netgen       | LVS netlist comparison                     |
| KLayout      | Layout viewer                              |
| sky130A PDK  | SkyWater 130nm process design kit          |
| Docker       | Container environment for OpenLane         |

---

## RTL-to-GDSII Flow

```
PicoRV32 RTL (picorv32.v)
         │
         ▼
  ┌─────────────┐
  │  Synthesis  │  Yosys — RTL → gate-level netlist (sky130 cells)
  └──────┬──────┘
         │
         ▼
  ┌─────────────┐
  │ Floorplan   │  OpenROAD — die area, core area, I/O pins, PDN
  └──────┬──────┘
         │
         ▼
  ┌─────────────┐
  │  Placement  │  RePlAce + OpenDP — global + detailed placement
  └──────┬──────┘
         │
         ▼
  ┌─────────────┐
  │     CTS     │  TritonCTS — clock tree, skew minimization
  └──────┬──────┘
         │
         ▼
  ┌─────────────┐
  │   Routing   │  FastRoute + TritonRoute — global + detailed routing
  └──────┬──────┘
         │
         ▼
  ┌─────────────┐
  │     STA     │  OpenSTA — setup/hold timing, WNS, TNS
  └──────┬──────┘
         │
         ▼
  ┌─────────────┐
  │  DRC / LVS  │  Magic + Netgen — physical verification
  └──────┬──────┘
         │
         ▼
  ┌─────────────┐
  │    GDSII    │  Magic — final layout streaming
  └─────────────┘
```

---

## Flow Stages — Detailed

### Stage 1 — Synthesis
- **Tool:** Yosys + ABC
- Converts PicoRV32 Verilog RTL into a gate-level netlist using sky130 standard cell library
- Technology mapping performed by ABC
- Optimization strategy: AREA 0 (minimize cell count and area)
- Output: gate-level netlist (.v), synthesis statistics report

### Stage 2 — Floorplanning
- **Tool:** OpenROAD (ioplacer, pdn)
- Defines die boundary and core area based on target utilization (40%)
- Places I/O pins around the die boundary
- Generates Power Delivery Network (PDN):
  - VDD/VSS rings around the core
  - Horizontal and vertical power stripes across the core
  - Standard cell rails connecting to stripes
- Output: floorplan DEF file

### Stage 3 — Placement
- **Tool:** OpenROAD (RePlAce, OpenDP, Resizer)
- **Global Placement:** cells placed approximately to minimize wire length (HPWL)
- **Resizer:** inserts buffers, resizes cells for timing and design optimization
- **Detailed Placement:** legalizes all cells onto placement grid, removes overlaps
- Output: placed DEF file, placement reports

### Stage 4 — Clock Tree Synthesis (CTS)
- **Tool:** TritonCTS
- Builds a balanced clock distribution network from clock source to all flip-flops
- Inserts clock buffers in a hierarchical tree structure
- Minimizes clock skew (target < 200ps) and clock latency
- Output: CTS DEF file, clock tree report

### Stage 5 — Routing
- **Tool:** FastRoute (global) + TritonRoute (detailed)
- **Global Routing:** assigns each net to specific routing layers and GCell regions
- **Detailed Routing:** places actual metal wire shapes on routing grid
- Handles via insertion between layers
- Antenna violation detection and diode insertion
- Output: routed DEF file, routing congestion report

### Stage 6 — Static Timing Analysis (STA)
- **Tool:** OpenSTA
- Analyzes every timing path for setup and hold violations
- Performed at typical, best, and worst PVT corners
- Reports WNS (Worst Negative Slack) and TNS (Total Negative Slack)
- Output: timing reports per corner

### Stage 7 — Physical Verification
- **DRC (Design Rule Check):** Magic verifies layout against sky130 manufacturing rules
- **LVS (Layout vs Schematic):** Netgen compares extracted netlist with gate-level netlist
- **Antenna Check:** OpenROAD verifies no antenna rule violations remain
- **ERC (Electrical Rule Check):** checks for electrical validity
- Output: DRC report, LVS report, antenna report

### Stage 8 — GDSII Streaming
- **Tool:** Magic
- Streams out the final GDSII file from the routed DEF
- GDSII is the industry-standard format sent to the semiconductor foundry for fabrication
- Output: picorv32.gds

---

## Results

> Flow currently in progress. Results will be updated after successful run completion.

### Timing Summary

| Metric               | Value   |
|----------------------|---------|
| Target Clock Period  | 25 ns   |
| Target Frequency     | 40 MHz  |
| WNS (Setup Slack)    | TBD     |
| TNS                  | TBD     |
| Hold WNS             | TBD     |
| Clock Skew           | TBD     |

### Area Summary

| Metric               | Value   |
|----------------------|---------|
| Die Area             | TBD     |
| Core Area            | TBD     |
| Core Utilization     | TBD     |
| Total Cell Count     | TBD     |
| Sequential Cells     | TBD     |
| Combinational Cells  | TBD     |

### Physical Verification Summary

| Check                | Status  |
|----------------------|---------|
| DRC Violations       | TBD     |
| LVS                  | TBD     |
| Antenna Violations   | TBD     |

---

## Output Files

| File                    | Description                                 |
|-------------------------|---------------------------------------------|
| `picorv32.gds`          | Final GDSII layout — fabrication-ready      |
| `picorv32.def`          | Design Exchange Format — placed and routed  |
| `picorv32.lef`          | Abstract view for hierarchical integration  |
| `picorv32.v`            | Gate-level netlist post-synthesis           |
| `picorv32.sdc`          | Timing constraints file                     |
| `metrics.csv`           | Summary of all flow metrics                 |
| `manufacturability.rpt` | DRC, LVS, antenna check summary             |

---

## Repository Structure

```
picorv32-physical-design/
├── README.md
├── SETUP.md
├── designs/
│   └── picorv32/
│       ├── config.json          # OpenLane design configuration
│       └── src/
│           └── picorv32.v       # PicoRV32 RTL source
├── results/
│   ├── reports/                 # Timing, area, power reports
│   ├── picorv32.gds             # Final GDSII (added after flow)
│   └── screenshots/             # Layout screenshots
└── docs/
    └── flow_notes.md            # Personal observations and learnings
```

---

## Setup & Reproduction

### Prerequisites
- Windows 10/11 with WSL2 (Ubuntu 22.04)
- Docker Desktop 4.76+ with WSL2 integration enabled
- Minimum 8GB RAM, 50GB free disk space

### Quick Start

```bash
# 1. Clone OpenLane
git clone https://github.com/The-OpenROAD-Project/OpenLane.git
cd OpenLane

# 2. Install dependencies
sudo apt install make python3-venv -y

# 3. Build OpenLane (pulls Docker images ~25GB, takes 30-60 min)
make

# 4. Verify installation
make test
# Expected: "Basic test passed"

# 5. Set up PicoRV32 design
mkdir -p designs/picorv32/src
git clone https://github.com/YosysHQ/picorv32.git ~/picorv32_src
cp ~/picorv32_src/picorv32.v designs/picorv32/src/

# 6. Create config.json (see designs/picorv32/config.json in this repo)

# 7. Run the full RTL-to-GDSII flow
./flow.tcl -design picorv32
```

For detailed step-by-step setup instructions, see [SETUP.md](SETUP.md)

---

## About PicoRV32

PicoRV32 is a small, open-source RISC-V RV32IMC processor core written in Verilog,
developed by YosysHQ. It is widely used in academic and research physical design
projects due to its clean, well-documented RTL structure and compact size.

- ISA: RISC-V RV32IMC
- Single-file Verilog implementation (~3000 lines)
- Configurable via parameters (enable/disable multiply, counters, etc.)
- Source: https://github.com/YosysHQ/picorv32

---

## Key Learnings

- Setting up OpenLane on WSL2 with Docker Desktop on Windows 10
- Understanding each stage of the RTL-to-GDSII physical design flow
- Reading and interpreting timing reports (WNS, TNS, slack paths)
- Analyzing placement density and routing congestion
- Physical verification using DRC and LVS
- Working with the SkyWater 130nm open-source PDK

---

## Author

**Dakshaa Sreerama**
B.E. Electronics Engineering (VLSI Design and Technology)
Nitte Meenakshi Institute of Technology, Bengaluru
CGPA: 9.5 | Graduating 2027

LinkedIn: 
GitHub:
## References

- [OpenLane Documentation](https://openlane.readthedocs.io)
- [PicoRV32 Repository](https://github.com/YosysHQ/picorv32)
- [SkyWater PDK Documentation](https://skywater-pdk.readthedocs.io)
- [OpenROAD Project](https://theopenroadproject.org)

# Setup Guide

## Prerequisites

* Windows 10/11 (64-bit)
* WSL2
* Docker Desktop
* Git

## 1. Install WSL2

Open PowerShell as Administrator:

```powershell
wsl --install
```

Restart your PC and create an Ubuntu username and password.

Verify WSL version:

```powershell
wsl --list --verbose
```

Ensure Ubuntu is using **WSL2**.

---

## 2. Install Docker Desktop

* Download and install Docker Desktop.
* Select **All Users Installation**.
* Enable **WSL Integration** for Ubuntu in Docker settings.

Verify Docker:

```bash
docker run hello-world
```

---

## 3. Install Dependencies

```bash
sudo apt update
sudo apt install git make python3-venv -y
```

---

## 4. Clone OpenLane

```bash
git clone https://github.com/The-OpenROAD-Project/OpenLane.git
cd OpenLane
```

---

## 5. Build OpenLane

```bash
make
```

This downloads the required Docker images and Sky130 PDK.

---

## 6. Verify Installation

```bash
make test
```

---

## 7. Add PicoRV32 Design

```bash
mkdir -p ~/OpenLane/designs/picorv32/src

git clone https://github.com/YosysHQ/picorv32.git ~/picorv32_src

cp ~/picorv32_src/picorv32.v \
~/OpenLane/designs/picorv32/src/
```

---

## 8. Run RTL-to-GDSII Flow

```bash
cd ~/OpenLane
./flow.tcl -design picorv32
```

The flow performs:

* Synthesis
* Floorplanning
* Placement
* CTS
* Routing
* DRC/LVS
* GDSII Generation

Runtime: ~30–60 minutes depending on system resources.

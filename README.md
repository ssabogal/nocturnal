# NoCTurnal - ECE2140
Network-on-Chip (NoC) - 3x3 2D Mesh with Wormhole-switching and XY-routing

## Directory Structure

+ **documentation/** Documents
+ **ip_repo/** Custom IP
	+ **nic_1.0/** Vivado-packaged Network Interface Card (NIC) with AXI4-Lite interface
	+ **router/** Vivado-packaged router IP with AXI4-Stream interface
+ **noc_dev/** Vivado 2016.4 project with 3x3 2D mesh
+ **extra/** Software-based NoC Simulation and Octave script for generating graphs based on baremetal application output

## Usage

1. **Clone this repository**
2. **Open Project with Vivado 2016.4**
3. **Generate Bitstream; Export to SDK**
    + **Note:** This project targets the Zedboard (Zynq-7020).
        + If a **different** Zynq device is used, then the pblocks in the constraints.xdc file must be removed (the ranges may be incompatible).
        + Change the target platform in the project settings menu.
4. **Program FPGA**
5. **Run Baremetal Program**
    + The baremetal application exercises the NoC using three tests:
        + Test 0 (1-to-1): Each endpoint sends a packet to its next logical neighbor.
        + Test 1 (N-to-N): Each endpoint sends packets to all endpoints (including self).
        + Test 2 (Worst-case Zero-Load): Under no congestion, an endpoint at one corner sends packets to another endpoint at the opposite corner).
    + The tests to perform, number of packets, and number of words are all automated by the application.
    + **Note:** The run configuration assumes an external serial connection (i.e., serial IO is not connected to the SDK's integrated console).
    + **Note:** When prompted "start [Y/n]" in a serial console, press any key to start the application.
    
6. **Testbench** Router-level testbenches are included with the router IP (click "Edit in IP Packager").

## Notes

1. **Packet Structure**
    + Destination address ([31:30] X partition, [29:28] Y partition, [27:0] partition offset)
    + Source address ([31:30] X partition, [29:28] Y partition, [27:0] partition offset)
    + Packet size (in 32-bit words; includes packet header words)
    + Payload words

2. The partition address (XY) starts at the southwest router.

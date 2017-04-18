connect -url tcp:127.0.0.1:3121
source /home/virtual/noc_dev/noc_dev/noc_dev.sdk/sys_wrapper_hw_platform_0/ps7_init.tcl
targets -set -nocase -filter {name =~"APU*" && jtag_cable_name =~ "Digilent Zed 210248585707"} -index 0
loadhw /home/virtual/noc_dev/noc_dev/noc_dev.sdk/sys_wrapper_hw_platform_0/system.hdf
targets -set -nocase -filter {name =~"APU*" && jtag_cable_name =~ "Digilent Zed 210248585707"} -index 0
stop
ps7_init
ps7_post_config
targets -set -nocase -filter {name =~ "ARM*#0" && jtag_cable_name =~ "Digilent Zed 210248585707"} -index 0
rst -processor
targets -set -nocase -filter {name =~ "ARM*#0" && jtag_cable_name =~ "Digilent Zed 210248585707"} -index 0
dow /home/virtual/noc_dev/noc_dev/noc_dev.sdk/noc_dev/Debug/noc_dev.elf
targets -set -nocase -filter {name =~ "ARM*#0" && jtag_cable_name =~ "Digilent Zed 210248585707"} -index 0
con

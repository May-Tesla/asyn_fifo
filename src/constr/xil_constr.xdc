#######################################
##
## Engineer: Mei Xuexiao
##
## Create Data: 2023/04/23 13:30:00
## Project Name: asyn_fifo
## Target Devices: ZYNQ-7 ZC706
## Tool Versions: 2021.02
##
#######################################

create_clock -period 10.000 -name wclk -waveform {0.000 5.000} -add [get_ports clk_in1_p]
create_clock -period 20.000 -name rclk -waveform {0.000 10.000} -add [get_ports clk_in2_p]

set_clock_groups -name async_wclk_rclk -asynchronous -group \
[get_clocks -include_generated_clocks wclk] -group [get_clocks -include_generated_clocks rclk]

set_property PACKAGE_PIN H9 [get_ports clk_in1_p]
set_property IOSTANDARD LVDS [get_ports clk_in1_p]
set_property IOSTANDARD LVDS [get_ports clk_in1_n]

set_property PACKAGE_PIN AF14 [get_ports clk_in2_p]
set_property IOSTANDARD LVDS_25 [get_ports clk_in2_p]
set_property IOSTANDARD LVDS_25 [get_ports clk_in2_n]

set_property PACKAGE_PIN A8 [get_ports sys_rst]
set_property IOSTANDARD LVCMOS15 [get_ports sys_rst]

set_property PACKAGE_PIN K15 [get_ports winc]
set_property IOSTANDARD LVCMOS18 [get_ports winc]

set_property PACKAGE_PIN AK25 [get_ports rinc]
set_property IOSTANDARD LVCMOS25 [get_ports rinc]

set_property PACKAGE_PIN W21 [get_ports rempty]
set_property IOSTANDARD LVCMOS25 [get_ports rempty]

set_property PACKAGE_PIN A17 [get_ports wfull]
set_property IOSTANDARD LVCMOS18 [get_ports wfull]

# set_property PACKAGE_PIN AK21 [get_ports ]
# set_property IOSTANDARD LVCMOS25 [get_ports ]

# set_property PACKAGE_PIN AJ21 [get_ports ]
# set_property IOSTANDARD LVCMOS25 [get_ports ]
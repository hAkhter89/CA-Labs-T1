## CLOCK (100 MHz)
set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 10.00 -name sys_clk -waveform {0 5} [get_ports clk]


## RESET BUTTON (BTN0)
set_property PACKAGE_PIN U18 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports rst]


## ALU OPERATION SWITCHES
set_property PACKAGE_PIN V17 [get_ports {alu_op_switch[0]}]
set_property PACKAGE_PIN V16 [get_ports {alu_op_switch[1]}]
set_property PACKAGE_PIN W16 [get_ports {alu_op_switch[2]}]
set_property PACKAGE_PIN W17 [get_ports {alu_op_switch[3]}]

set_property IOSTANDARD LVCMOS33 [get_ports {alu_op_switch[*]}]


## WRITE ENABLE SWITCH
set_property PACKAGE_PIN W15 [get_ports write_en_switch]
set_property IOSTANDARD LVCMOS33 [get_ports write_en_switch]


## DESTINATION REGISTER SWITCHES
set_property PACKAGE_PIN V15 [get_ports {rd_switch[0]}]
set_property PACKAGE_PIN W14 [get_ports {rd_switch[1]}]
set_property PACKAGE_PIN W13 [get_ports {rd_switch[2]}]
set_property PACKAGE_PIN V2  [get_ports {rd_switch[3]}]
set_property PACKAGE_PIN T3  [get_ports {rd_switch[4]}]

set_property IOSTANDARD LVCMOS33 [get_ports {rd_switch[*]}]


## LED OUTPUTS
set_property PACKAGE_PIN U16 [get_ports {leds[0]}]
set_property PACKAGE_PIN E19 [get_ports {leds[1]}]
set_property PACKAGE_PIN U19 [get_ports {leds[2]}]
set_property PACKAGE_PIN V19 [get_ports {leds[3]}]
set_property PACKAGE_PIN W18 [get_ports {leds[4]}]
set_property PACKAGE_PIN U15 [get_ports {leds[5]}]
set_property PACKAGE_PIN U14 [get_ports {leds[6]}]
set_property PACKAGE_PIN V14 [get_ports {leds[7]}]

set_property IOSTANDARD LVCMOS33 [get_ports {leds[*]}]

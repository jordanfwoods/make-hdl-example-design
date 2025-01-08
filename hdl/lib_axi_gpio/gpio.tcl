if { [file isdirectory ./gpio] } {
   read_ip ./gpio/gpio.xci
} else {
   create_project -in_memory -part xc7a12ticsg325-1L
   create_ip -name axi_gpio -vendor xilinx.com -library ip -version 2.0 -module_name gpio -dir .
   set_property -dict [list \
     CONFIG.C_ALL_INPUTS {1} \
     CONFIG.C_ALL_OUTPUTS_2 {1} \
     CONFIG.C_IS_DUAL {1} \
   ] [get_ips gpio]
   generate_target {instantiation_template} [get_files ./gpio_1/gpio.xci]
   synth_ip [get_ips]
   close_project
}

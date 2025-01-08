if { [file isdirectory ./no_changes2] } {
   read_ip ./no_changes2/no_changes2.xci
} else {
   create_project -in_memory -part xc7a12ticsg325-1L
   create_ip -name axi_gpio -vendor xilinx.com -library ip -version 2.0 -module_name no_changes2 -dir .
   generate_target {instantiation_template} [get_files ./no_changes2/no_changes2.xci]
   synth_ip [get_ips]
   close_project
}

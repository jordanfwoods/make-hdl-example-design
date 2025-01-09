create_project -in_memory -part xc7a12ticsg325-1L
create_ip -name axi_gpio -vendor xilinx.com -library ip -version 2.0 -module_name no_changes -dir .
generate_target {instantiation_template} [get_files ./no_changes/no_changes.xci]
if { [string compare [lindex  0] "no"] != 0 } { synth_ip [get_ips] }
close_project

# Check axi_gpio
if { [file isdirectory ../"axi_gpio"] } {
   # if the axi_gpio files exist, we already generated the axi_gpio, so we can just
   # read the axi_gpio definition (.xci)
   read_ip ../axi_gpio/axi_gpio.xci
} else {
   # axi_gpio folder does not exist. Create axi_gpio folder
   file mkdir ../axi_gpio
    
   # create_ip requires that a project is open in memory. Create project 
   # but don't do anything with it
   create_project -in_memory 
    
   # paste commands from Journal file to recreate axi_gpio
   create_ip -name axi_gpio -vendor xilinx.com -library axi_gpio -version 2.0 -module_name axi_gpio_0
   set_property -dict [list \
     CONFIG.C_ALL_INPUTS {1} \
     CONFIG.C_ALL_OUTPUTS_2 {1} \
     CONFIG.C_IS_DUAL {1} \
   ] [get_ips axi_gpio_0]
   generate_target {instantiation_template} [get_files /home/jwoods/temp/project_1/project_1.srcs/sources_1/axi_gpio/axi_gpio_0/axi_gpio_0.xci]

   # Synthesize all the axi_gpio
   synth_ip [get_ips]
}





















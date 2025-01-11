# Define target part and create output directory
set  partNum   xc7a12ticsg325-1L
set  outputDir ./vivado
file mkdir     $outputDir
set  files     [glob -nocomplain "$outputDir/*"]

# Clear folder contents
if {[llength $files] != 0} {
   puts "deleting contents of $outputDir"
   file delete -force {*}[glob -directory $outputDir *];
} else {
   puts "$outputDir is empty"
}

#Reference HDL and constraint source files
read_vhdl    -library lib_top     hdl/top.vhd
read_vhdl    -library lib_main    ../lib_main/hdl/main.vhd
read_vhdl    -library lib_and     ../lib_and/hdl/and2.vhd
read_vhdl    -library lib_common  ../lib_common/hdl/common_pkg.vhd
add_files                         ../lib_axi_gpio/gpio/gpio.dcp
read_xdc                          top.xdc
read_bd                           ../lib_bd/bd/bd.bd
set_property LIBRARY lib_bd       [get_files -all ../lib_bd/bd/bd.bd]
set_property LIBRARY lib_axi_gpio [get_files -all ../lib_axi_gpio/gpio/gpio.dcp]

#Run Synthesis
synth_design          -top top -part $partNum
write_checkpoint      -force $outputDir/post_synth.dcp
report_timing_summary -file $outputDir/post_synth_timing_summary.rpt
report_utilization    -file $outputDir/post_synth_util.rpt

#run optimization
opt_design
place_design
report_clock_utilization -file $outputDir/clock_util.rpt

#get timing violations and run optimizations if needed
puts "JQZU: get_runs - [get_runs]"
puts "JQZU: get_timing_paths - [get_timing_paths -max_paths 1 -nworst 1 -setup]"
# if {[get_property SLACK [get_timing_paths -max_paths 1 -nworst 1 -setup]] < 0} {
#    puts "Found setup timing violations => running physical optimization"
#    phys_opt_design
# }
write_checkpoint      -force $outputDir/post_place.dcp
report_utilization    -file  $outputDir/post_place_util.rpt
report_timing_summary -file  $outputDir/post_place_timing_summary.rpt

#Route design and generate bitstream
route_design          -directive Explore
write_checkpoint      -force $outputDir/post_route.dcp
report_route_status   -file  $outputDir/post_route_status.rpt
report_timing_summary -file  $outputDir/post_route_timing_summary.rpt
report_power          -file  $outputDir/post_route_power.rpt
report_drc            -file  $outputDir/post_imp_drc.rpt
write_verilog         -force $outputDir/cpu_impl_netlist.v -mode timesim -sdf_anno true
write_bitstream       -force $outputDir/nameOfBitstream.bit


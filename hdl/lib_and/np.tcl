# Define target part and create output directory
set  partNum   xc7a12ticsg325-1L
set  outputDir ./vivado
file mkdir     $outputDir
set  files     [glob -nocomplain "$outputDir/*"]

# Clear folder contents
if {[llength $files] != 0} {
   puts "deleting contents of $outputDir"
   file delete -force {*}[glob -directory $outputDir *.dcp];
} else {
   puts "$outputDir is empty"
}

#Reference HDL and constraint source files
# read_vhdl -library osvvm [glob -directory ../osvvm/hdl *.vhd]
read_vhdl                [glob -directory hdl *]

#Run Synthesis
foreach top {and1 and2} {
   synth_design          -top $top -part $partNum
   opt_design
   write_checkpoint      -force $outputDir/post_synth_$top.dcp
   report_timing_summary -file $outputDir/post_synth_timing_summary_$top.rpt
   report_utilization    -file $outputDir/post_synth_util_$top.rpt
   write_checkpoint      -force $outputDir/post_post_synth_$top.dcp
   write_checkpoint      -force $outputDir/post_post2_synth_$top.dcp
}


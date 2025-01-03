# Go to lib_tb_a
cd hdl/lib_tb_a

# clean the dirs
rm -rf ../osvvm/sim ../osvvm/modelsim.ini ../osvvm/work
rm -rf ../lib_and/sim ../lib_and/modelsim.ini ../lib_and/work
rm -rf ../lib_tb_a/sim ../lib_tb_a/modelsim.ini ../lib_tb_a/work

# compile osvvm
cd ../osvvm
vlib -quiet ../osvvm/sim/
vmap -quiet work ../osvvm/sim/
vcom -work ../osvvm/sim/ -quiet -pedanticerrors -2008  ../osvvm/hdl/IfElsePkg.vhd ../osvvm/hdl/OsvvmTypesPkg.vhd ../osvvm/hdl/OsvvmScriptSettingsPkg.vhd ../osvvm/hdl/OsvvmScriptSettingsPkg_default.vhd ../osvvm/hdl/OsvvmSettingsPkg.vhd ../osvvm/hdl/TextUtilPkg.vhd ../osvvm/hdl/ResolutionPkg.vhd ../osvvm/hdl/NamePkg.vhd ../osvvm/hdl/OsvvmGlobalPkg.vhd ../osvvm/hdl/CoverageVendorApiPkg_default.vhd ../osvvm/hdl/deprecated/LanguageSupport2019Pkg_c.vhd ../osvvm/hdl/TranscriptPkg.vhd ../osvvm/hdl/AlertLogPkg.vhd ../osvvm/hdl/TbUtilPkg.vhd ../osvvm/hdl/NameStorePkg.vhd ../osvvm/hdl/MessageListPkg.vhd ../osvvm/hdl/SortListPkg_int.vhd ../osvvm/hdl/RandomBasePkg.vhd ../osvvm/hdl/RandomPkg.vhd ../osvvm/hdl/RandomProcedurePkg.vhd ../osvvm/hdl/CoveragePkg.vhd ../osvvm/hdl/DelayCoveragePkg.vhd ../osvvm/hdl/ClockResetPkg.vhd ../osvvm/hdl/deprecated/ClockResetPkg_2024_05.vhd ../osvvm/hdl/ResizePkg.vhd ../osvvm/hdl/ScoreboardGenericPkg.vhd ../osvvm/hdl/ScoreboardPkg_slv.vhd ../osvvm/hdl/ScoreboardPkg_int.vhd ../osvvm/hdl/ScoreboardPkg_signed.vhd ../osvvm/hdl/ScoreboardPkg_unsigned.vhd ../osvvm/hdl/ScoreboardPkg_IntV.vhd ../osvvm/hdl/MemorySupportPkg.vhd ../osvvm/hdl/deprecated/MemoryGenericPkg_xilinx.vhd ../osvvm/hdl/MemoryPkg.vhd ../osvvm/hdl/ReportPkg.vhd ../osvvm/hdl/OsvvmTypesPkg.vhd ../osvvm/hdl/OsvvmSettingsPkg_default.vhd ../osvvm/hdl/deprecated/RandomPkg2019_c.vhd ../osvvm/hdl/OsvvmContext.vhd

# make lib_and modelsim.ini
cd ../lib_and
vmap -quiet osvvm ../osvvm/sim

# compile lib_and
vlib -quiet ../lib_and/sim/
vmap -quiet work ../lib_and/sim/
vcom -work ../lib_and/sim/ -quiet -pedanticerrors -2008  ../lib_and/hdl/and1.vhd ../lib_and/hdl/and2.vhd

# make lib_tb_a modelsim.ini
cd ../lib_tb_a
vmap -quiet lib_and ../lib_and/sim
vmap -quiet osvvm   ../osvvm/sim

# compile lib_tb_a
vlib -quiet ../lib_tb_a/sim/
vmap -quiet work ../lib_tb_a/sim/
vlog -work ../lib_tb_a/sim/ -quiet -pedanticerrors -sv  ../lib_tb_a/hdl/long_name.sv ../lib_tb_a/hdl/tb.sv ../lib_tb_a/hdl/tc1.sv ../lib_tb_a/hdl/tc2.sv

# run simulations
vsim work.tc1       -l results/tc1.log       -L work -L osvvm -L lib_and -L lib_tb_a -pedanticerrors -c -do 'run -all; quit -code [coverage attribute -name TESTSTATUS -concise]'
vsim work.tc2       -l results/tc2.log       -L work -L osvvm -L lib_and -L lib_tb_a -pedanticerrors -c -do 'run -all; quit -code [coverage attribute -name TESTSTATUS -concise]'
vsim work.long_name -l results/long_name.log -L work -L osvvm -L lib_and -L lib_tb_a -pedanticerrors -c -do 'run -all; quit -code [coverage attribute -name TESTSTATUS -concise]'

# Compile Regression
result="Library #Testcase Name #Errors #Warnings\n"
result+="--------#--------------#-------#---------\n"
for j in tc1 tc2 long_name; do
   tmp=`tail -n 1 results/$j.log | grep "# Errors: "`
   errors=`echo $tmp | sed 's@# Errors: \([0-9]\+\).*@\1@'`
   warn=`echo  $tmp | sed 's@# Errors: .*, Warnings: \([0-9]\+\).*@\1@'`
   ((error_cnt+=errors))
   ((warn_cnt+=warn))
   result+="lib_tb_a #$j #$errors #$warn\n"
done
result+="--------#--------------#-------#---------\n"
result+="`echo lib_tb_a | wc -w` Libs #`echo tc1 tc2 long_name | wc -w` Tests #$error_cnt#$warn_cnt\n"
echo -e $result | column -t -s '#' -o '| '
echo "REGRESSION RESULTS: `echo tc1 tc2 long_name | wc -w` tests run with $error_cnt errors and $warn_cnt warnings found!"
if [ $error_cnt -eq 0 ] ; then
   echo -e "REGRESSION PASSED!\n~~ End of Regression Results! ~~\n"
else
   echo -e "REGRESSION FAILED!\n~~ End of Regression Results! ~~\n"
   exit 1;
fi

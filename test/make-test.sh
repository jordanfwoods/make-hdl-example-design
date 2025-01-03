# Go to lib_tb_a
cd hdl/lib_tb_a

# Do it all and see the regression results
make recursiveclean regression | tee >(grep -e "^REGRESSION" > tmp.txt)
if grep -q "^REGRESSION" tmp.txt ; then
   echo "PASS: REGRESSION COMPLETED!"
else
   echo "FAIL: REGRESSION DID NOT COMPLETE!"
   exit 1
fi

# Just compile and verify that nothing gets recompiled.
make compile | tee tmp.txt
if grep -q "^make: Nothing to be done for 'compile'." tmp.txt ; then
   echo "PASS: RE-COMPILE CHECK COMPLETED!"
else
   echo "FAIL: MAKE DID NOT FIND 'NOTHING TO BE DONE'!"
   exit 2
fi

# Touch a file in one sub-dir
touch ../../hdl/lib_and/hdl/and1.vhd
make compile | tee tmp.txt
if grep -q -Pzl "^~~ Starting Compiling lib_and  ~~\n~~ Starting Compiling lib_tb_a  ~~" tmp.txt ; then
   if grep -vq "^~~ Starting Compiling osvvm  ~~" tmp.txt ; then
      echo "PASS: ONLY LIB_AND and LIB_TB_A ARE RE-COMPILED AFTER 'AND1.VHD' WAS TOUCHED!"
   else
      echo "FAIL: OSVVM WAS RE-COMPILED AFTER 'AND1.VHD' WAS TOUCHED!"
      exit 3
   fi
else
   echo "FAIL: MISSING COMPILES AFTER TOUCHING 'AND1.VHD'!"
   exit 4
fi

echo "PASS: EVERY TEST COMPLETED SUCCESSFULLY!"
rm tmp.txt

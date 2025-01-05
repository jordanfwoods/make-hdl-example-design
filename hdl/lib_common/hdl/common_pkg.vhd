--------------------------------------------------------------------------------
--
-- Filename          : common_pkg.vhd
-- VHDL Entity       : common_pkg
--      Architecture : rtl
--      Library      : lib_common
--
-- Created:
--          by - Jordan Woods
--          at - Fri, 03 Jan 2025
--
--------------------------------------------------------------------------------
-- make-hdl © 2025 by Jordan Woods is licensed under CC BY-NC-SA 4.0. --
-- To view a copy of this license, visit                              --
-- https://creativecommons.org/licenses/by-nc-sa/4.0/                 --
--------------------------------------------------------------------------------
-- Purpose      : Simple common level package to contain common records / constants
--                to prove out the makefiles.
--
--------------------------------------------------------------------------------
-- History:
-- Date               Author         Comment
-- Fri, 03 Jan 2025   Jordan Woods   Initial design
--
--------------------------------------------------------------------------------
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package common_pkg is
   type axi4_lite_master_driven is record
      awaddr  : std_logic_vector(31 downto 0);
      awvalid : std_logic;
      wdata   : std_logic_vector(31 downto 0);
      wstrb   : std_logic_vector( 3 downto 0);
      wvalid  : std_logic;
      bready  : std_logic;
      araddr  : std_logic_vector(31 downto 0);
      arvalid : std_logic;
      rready  : std_logic;
   end record axi4_lite_master_driven;

   type axi4_lite_slave_driven is record
      awready : std_logic;
      wready  : std_logic;
      bresp   : std_logic_vector( 1 downto 0);
      bvalid  : std_logic;
      arready : std_logic;
      rdata   : std_logic_vector(31 downto 0);
      rresp   : std_logic_vector( 1 downto 0);
      rvalid  : std_logic;
   end record axi4_lite_slave_driven;

end common_pkg;


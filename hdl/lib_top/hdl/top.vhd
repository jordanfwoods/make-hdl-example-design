--------------------------------------------------------------------------------
--
-- Filename          : top.vhd
-- VHDL Entity       : top
--      Architecture : rtl
--      Library      : lib_top
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
-- Purpose      : Simple top level entity to prove out the makefiles.
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

library lib_main;

library lib_common;
use lib_common.common_pkg.all;

library lib_bd;

entity top is
   port (
      -- PS Stuff --
      ddr_addr            : inout std_logic_vector(14 downto 0);
      ddr_ba              : inout std_logic_vector(2 downto 0);
      ddr_cas_n           : inout std_logic;
      ddr_ck_n            : inout std_logic;
      ddr_ck_p            : inout std_logic;
      ddr_cke             : inout std_logic;
      ddr_cs_n            : inout std_logic;
      ddr_dm              : inout std_logic_vector(3 downto 0);
      ddr_dq              : inout std_logic_vector(31 downto 0);
      ddr_dqs_n           : inout std_logic_vector(3 downto 0);
      ddr_dqs_p           : inout std_logic_vector(3 downto 0);
      ddr_odt             : inout std_logic;
      ddr_ras_n           : inout std_logic;
      ddr_reset_n         : inout std_logic;
      ddr_we_n            : inout std_logic;
      fixed_io_ddr_vrn    : inout std_logic;
      fixed_io_ddr_vrp    : inout std_logic;
      fixed_io_mio        : inout std_logic_vector(53 downto 0);
      fixed_io_ps_clk     : inout std_logic;
      fixed_io_ps_porb    : inout std_logic;
      fixed_io_ps_srstb   : inout std_logic;
      -- Actual I/O --
      o_led               : out   std_logic_vector(0 downto 0)
    );
end entity top;

architecture rtl of top is

signal clk        : std_logic;
signal ps_rstn    : std_logic_vector(0 downto 0);
alias  rstn       : std_logic is ps_rstn(0);

signal axi_m_gpio : axi4_lite_master_driven;
signal axi_s_gpio : axi4_lite_slave_driven;

begin

-- u_ps_bd : entity lib_bd.bd
--    port map (
--       DDR_addr            => ddr_addr,
--       DDR_ba              => ddr_ba,
--       DDR_cas_n           => ddr_cas_n,
--       DDR_ck_n            => ddr_ck_n,
--       DDR_ck_p            => ddr_ck_p,
--       DDR_cke             => ddr_cke,
--       DDR_cs_n            => ddr_cs_n,
--       DDR_dm              => ddr_dm,
--       DDR_dq              => ddr_dq,
--       DDR_dqs_n           => ddr_dqs_n,
--       DDR_dqs_p           => ddr_dqs_p,
--       DDR_odt             => ddr_odt,
--       DDR_ras_n           => ddr_ras_n,
--       DDR_reset_n         => ddr_reset_n,
--       DDR_we_n            => ddr_we_n,
--       FIXED_IO_ddr_vrn    => fixed_io_ddr_vrn,
--       FIXED_IO_ddr_vrp    => fixed_io_ddr_vrp,
--       FIXED_IO_mio        => fixed_io_mio,
--       FIXED_IO_ps_clk     => fixed_io_ps_clk,
--       FIXED_IO_ps_porb    => fixed_io_ps_porb,
--       FIXED_IO_ps_srstb   => fixed_io_ps_srstb,
--       clk                 => clk,
--       m_axi_araddr        => axi_m_gpio.araddr,
--       m_axi_arprot        => open,
--       m_axi_arready       => axi_s_gpio.arready,
--       m_axi_arvalid       => axi_m_gpio.arvalid,
--       m_axi_awaddr        => axi_m_gpio.awaddr,
--       m_axi_awprot        => open,
--       m_axi_awready       => axi_s_gpio.awready,
--       m_axi_awvalid       => axi_m_gpio.awvalid,
--       m_axi_bready        => axi_m_gpio.bready,
--       m_axi_bresp         => axi_s_gpio.bresp,
--       m_axi_bvalid        => axi_s_gpio.bvalid,
--       m_axi_rdata         => axi_s_gpio.rdata,
--       m_axi_rready        => axi_m_gpio.rready,
--       m_axi_rresp         => axi_s_gpio.rresp,
--       m_axi_rvalid        => axi_s_gpio.rvalid,
--       m_axi_wdata         => axi_m_gpio.wdata,
--       m_axi_wready        => axi_s_gpio.wready,
--       m_axi_wstrb         => axi_m_gpio.wstrb,
--       m_axi_wvalid        => axi_m_gpio.wvalid,
--       rstn                => ps_rstn
--    );

   u_main : entity lib_main.main
   port map (
      clk        => clk,
      rstn       => rstn,
      axi_m_gpio => axi_m_gpio,
      axi_s_gpio => axi_s_gpio,
      o_led      => o_led
   );

end architecture rtl;

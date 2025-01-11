--------------------------------------------------------------------------------
--
-- Filename          : main.vhd
-- VHDL Entity       : main
--      Architecture : rtl
--      Library      : lib_main
--
-- Created:
--          by - Jordan Woods
--          at - Sat, 04 Jan 2025
--
--------------------------------------------------------------------------------
-- make-hdl © 2025 by Jordan Woods is licensed under CC BY-NC-SA 4.0. --
-- To view a copy of this license, visit                              --
-- https://creativecommons.org/licenses/by-nc-sa/4.0/                 --
--------------------------------------------------------------------------------
-- Purpose      : Simple wrapper to house main code base (i.e. everything that
--                is easily simulatable). Notably, this does not have the PS)
--
--------------------------------------------------------------------------------
-- History:
-- Date               Author         Comment
-- Sat, 04 Jan 2025   Jordan Woods   Initial design
--
--------------------------------------------------------------------------------
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library lib_and;
library lib_axi_gpio;
library lib_common;
use lib_common.common_pkg.all;


entity main is
   port (
      clk        : in  std_logic;
      rstn       : in  std_logic;
      -- PS AXI-4 Lite --
      axi_m_gpio : in  axi4_lite_master_driven;
      axi_s_gpio : out axi4_lite_slave_driven;
      -- Actual I/O of Device --
      o_led      : out   std_logic_vector(0 downto 0)
   );
end entity main;

architecture rtl of main is

-- component decalrations
component gpio
  port (
    s_axi_aclk    : in std_logic;
    s_axi_aresetn : in std_logic;
    s_axi_awaddr  : in std_logic_vector(8 downto 0);
    s_axi_awvalid : in std_logic;
    s_axi_awready : out std_logic;
    s_axi_wdata   : in std_logic_vector(31 downto 0);
    s_axi_wstrb   : in std_logic_vector(3 downto 0);
    s_axi_wvalid  : in std_logic;
    s_axi_wready  : out std_logic;
    s_axi_bresp   : out std_logic_vector(1 downto 0);
    s_axi_bvalid  : out std_logic;
    s_axi_bready  : in std_logic;
    s_axi_araddr  : in std_logic_vector(8 downto 0);
    s_axi_arvalid : in std_logic;
    s_axi_arready : out std_logic;
    s_axi_rdata   : out std_logic_vector(31 downto 0);
    s_axi_rresp   : out std_logic_vector(1 downto 0);
    s_axi_rvalid  : out std_logic;
    s_axi_rready  : in std_logic;
    gpio_io_i     : in std_logic_vector(31 downto 0);
    gpio2_io_o    : out std_logic_vector(31 downto 0)
  );
end component gpio;

component and2
   port (
      a : in  std_logic_vector(15 downto 0);
      b : in  std_logic_vector(15 downto 0);
      c : out std_logic_vector(15 downto 0)
   );
end component and2;

signal gpio1        : std_logic_vector(31 downto 0);
signal gpio2        : std_logic_vector(31 downto 0);
alias  gpio_used    : std_logic_vector(15 downto 0) is gpio1( 15 downto  0);
alias  gpio_unused  : std_logic_vector(15 downto 0) is gpio1( 31 downto 16);
alias  gpio2_msb    : std_logic_vector(15 downto 0) is gpio2(31 downto 16);
alias  gpio2_lsb    : std_logic_vector(15 downto 0) is gpio2(15 downto  0);

begin

u_gpio : gpio
   port map (
      s_axi_aclk    => clk,
      s_axi_aresetn => rstn,
      s_axi_awaddr  => axi_m_gpio.awaddr(8 downto 0),
      s_axi_awvalid => axi_m_gpio.awvalid,
      s_axi_awready => axi_s_gpio.awready,
      s_axi_wdata   => axi_m_gpio.wdata,
      s_axi_wstrb   => axi_m_gpio.wstrb,
      s_axi_wvalid  => axi_m_gpio.wvalid,
      s_axi_wready  => axi_s_gpio.wready,
      s_axi_bresp   => axi_s_gpio.bresp,
      s_axi_bvalid  => axi_s_gpio.bvalid,
      s_axi_bready  => axi_m_gpio.bready,
      s_axi_araddr  => axi_m_gpio.araddr(8 downto 0),
      s_axi_arvalid => axi_m_gpio.arvalid,
      s_axi_arready => axi_s_gpio.arready,
      s_axi_rdata   => axi_s_gpio.rdata,
      s_axi_rresp   => axi_s_gpio.rresp,
      s_axi_rvalid  => axi_s_gpio.rvalid,
      s_axi_rready  => axi_m_gpio.rready,
      gpio_io_i     => gpio1,
      gpio2_io_o    => gpio2
   );

u_and : and2
   port map (
      a => gpio2_msb,
      b => gpio2_lsb,
      c => gpio_used
   );

gpio_unused <= (others => '0');
o_led(0) <= gpio1(0);

end architecture rtl; -- of main

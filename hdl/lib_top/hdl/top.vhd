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

library work;
use work.top_pkg.all;

library lib_and;
library lib_bd;

entity top is
   port (
      o_led1 : out std_logic
    );
end entity top;

architecture rtl of top is

component axi_gpio_0
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
end component axi_gpio_0;

signal clk250     : std_logic;
signal rst        : std_logic_vector(0 downto 0);
alias  rst250     : std_logic is rst(0);
signal axi_m_gpio : axi4_lite_master_driven;
signal axi_s_gpio : axi4_lite_slave_driven;

signal gpio         : std_logic_vector(31 downto 0);
signal gpio2        : std_logic_vector(31 downto 0);
alias  gpio_msb     : std_logic_vector(15 downto 0) is gpio( 31 downto 16);
alias  gpio_lsb     : std_logic_vector(15 downto 0) is gpio( 15 downto  0);
alias  gpio2_used   : std_logic_vector(15 downto 0) is gpio2(15 downto  0);
alias  gpio2_unused : std_logic_vector(15 downto 0) is gpio2(31 downto 16);

signal ddr_addr            : std_logic_vector(14 downto 0);
signal ddr_ba              : std_logic_vector(2 downto 0);
signal ddr_cas_n           : std_logic;
signal ddr_ck_n            : std_logic;
signal ddr_ck_p            : std_logic;
signal ddr_cke             : std_logic;
signal ddr_cs_n            : std_logic;
signal ddr_dm              : std_logic_vector(3 downto 0);
signal ddr_dq              : std_logic_vector(31 downto 0);
signal ddr_dqs_n           : std_logic_vector(3 downto 0);
signal ddr_dqs_p           : std_logic_vector(3 downto 0);
signal ddr_odt             : std_logic;
signal ddr_ras_n           : std_logic;
signal ddr_reset_n         : std_logic;
signal ddr_we_n            : std_logic;
signal fixed_io_ddr_vrn    : std_logic;
signal fixed_io_ddr_vrp    : std_logic;
signal fixed_io_mio        : std_logic_vector(53 downto 0);
signal fixed_io_ps_clk     : std_logic;
signal fixed_io_ps_porb    : std_logic;
signal fixed_io_ps_srstb   : std_logic;
signal usb0_port_indctl    : std_logic_vector(1 downto 0);
signal usb0_vbus_pwrfault  : std_logic;
signal usb0_vbus_pwrselect : std_logic;

begin

u_ps_bd : entity lib_bd.design_1_wrapper
   port map (
      DDR_addr            => ddr_addr,
      DDR_ba              => ddr_ba,
      DDR_cas_n           => ddr_cas_n,
      DDR_ck_n            => ddr_ck_n,
      DDR_ck_p            => ddr_ck_p,
      DDR_cke             => ddr_cke,
      DDR_cs_n            => ddr_cs_n,
      DDR_dm              => ddr_dm,
      DDR_dq              => ddr_dq,
      DDR_dqs_n           => ddr_dqs_n,
      DDR_dqs_p           => ddr_dqs_p,
      DDR_odt             => ddr_odt,
      DDR_ras_n           => ddr_ras_n,
      DDR_reset_n         => ddr_reset_n,
      DDR_we_n            => ddr_we_n,
      FIXED_IO_ddr_vrn    => fixed_io_ddr_vrn,
      FIXED_IO_ddr_vrp    => fixed_io_ddr_vrp,
      FIXED_IO_mio        => fixed_io_mio,
      FIXED_IO_ps_clk     => fixed_io_ps_clk,
      FIXED_IO_ps_porb    => fixed_io_ps_porb,
      FIXED_IO_ps_srstb   => fixed_io_ps_srstb,
      USB0_port_indctl    => usb0_port_indctl,
      USB0_vbus_pwrfault  => usb0_vbus_pwrfault,
      USB0_vbus_pwrselect => usb0_vbus_pwrselect,
      clk250              => clk250,
      m_axi_araddr        => axi_m_gpio.araddr,
      m_axi_arprot        => open,
      m_axi_arready       => axi_s_gpio.arready,
      m_axi_arvalid       => axi_m_gpio.arvalid,
      m_axi_awaddr        => axi_m_gpio.awaddr,
      m_axi_awprot        => open,
      m_axi_awready       => axi_s_gpio.awready,
      m_axi_awvalid       => axi_m_gpio.awvalid,
      m_axi_bready        => axi_m_gpio.bready,
      m_axi_bresp         => axi_s_gpio.bresp,
      m_axi_bvalid        => axi_s_gpio.bvalid,
      m_axi_rdata         => axi_s_gpio.rdata,
      m_axi_rready        => axi_m_gpio.rready,
      m_axi_rresp         => axi_s_gpio.rresp,
      m_axi_rvalid        => axi_s_gpio.rvalid,
      m_axi_wdata         => axi_m_gpio.wdata,
      m_axi_wready        => axi_s_gpio.wready,
      m_axi_wstrb         => axi_m_gpio.wstrb,
      m_axi_wvalid        => axi_m_gpio.wvalid,
      rstn250             => rst
    );

u_axi_gpio_0 : axi_gpio_0
   port map (
      s_axi_aclk    => clk250,
      s_axi_aresetn => rst250,
      s_axi_awaddr  => axi_m_gpio.awaddr,
      s_axi_awvalid => axi_m_gpio.awvalid,
      s_axi_awready => axi_s_gpio.awready,
      s_axi_wdata   => axi_m_gpio.wdata,
      s_axi_wstrb   => axi_m_gpio.wstrb,
      s_axi_wvalid  => axi_m_gpio.wvalid,
      s_axi_wready  => axi_s_gpio.wready,
      s_axi_bresp   => axi_s_gpio.bresp,
      s_axi_bvalid  => axi_s_gpio.bvalid,
      s_axi_bready  => axi_m_gpio.bready,
      s_axi_araddr  => axi_m_gpio.araddr,
      s_axi_arvalid => axi_m_gpio.arvalid,
      s_axi_arready => axi_s_gpio.arready,
      s_axi_rdata   => axi_s_gpio.rdata,
      s_axi_rresp   => axi_s_gpio.rresp,
      s_axi_rvalid  => axi_s_gpio.rvalid,
      s_axi_rready  => axi_m_gpio.rready,
      gpio_io_i     => gpio,
      gpio2_io_o    => gpio2
   );

u_and : entity lib_and.and2
   generic map (
      G_WIDTH => 16
   ) port map (
      a => gpio_msb,
      b => gpio_lsb,
      c => gpio2_used
   );

gpio2_unused <= (others => '0');
o_led1 <= gpio2(0);

end architecture rtl;

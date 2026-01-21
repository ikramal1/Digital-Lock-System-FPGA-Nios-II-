-- DigitalLock_top.vhd (TOP LEVEL) - matches the REAL ports in DigitalLock.vhd

library ieee;
use ieee.std_logic_1164.all;

entity DigitalLock_top is
  port(
    CLOCK_50 : in  std_logic;
    KEY      : in  std_logic_vector(3 downto 0);
    SW       : in  std_logic_vector(9 downto 0);

    LEDR     : out std_logic_vector(9 downto 0);
    LEDG     : out std_logic_vector(7 downto 0);

    HEX0     : out std_logic_vector(6 downto 0);
    HEX1     : out std_logic_vector(6 downto 0);
    HEX2     : out std_logic_vector(6 downto 0);
    HEX3     : out std_logic_vector(6 downto 0)
  );
end entity DigitalLock_top;

architecture rtl of DigitalLock_top is
  signal hex_bus : std_logic_vector(27 downto 0);
begin

  -- split the 28-bit bus into 4x 7-seg
  HEX0 <= hex_bus(6 downto 0);
  HEX1 <= hex_bus(13 downto 7);
  HEX2 <= hex_bus(20 downto 14);
  HEX3 <= hex_bus(27 downto 21);

  u0 : entity work.DigitalLock
    port map (
      clk_clk             => CLOCK_50,
      hex_external_export  => hex_bus,
      ledg_external_export => LEDG,
      ledr_external_export => LEDR,
      key_external_export  => KEY,
      sw_external_export   => SW
    );

end architecture rtl;


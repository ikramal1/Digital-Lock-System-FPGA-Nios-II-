-- DigitalLock_top.vhd  (TOP LEVEL)
-- Works with your Qsys-generated sys_DigitalLock_top.vhd ports:
--   clk_clk, hex_export[27:0], ledr_export[9:0], ledg_export[7:0],
--   sw_export[9:0], key_export[3:0]

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

  -- Split the 28-bit bus into 4 seven-seg displays (7 bits each)
  HEX0 <= hex_bus(6 downto 0);
  HEX1 <= hex_bus(13 downto 7);
  HEX2 <= hex_bus(20 downto 14);
  HEX3 <= hex_bus(27 downto 21);

  u0 : entity work.DigitalLock
    port map (
      clk_clk       => CLOCK_50,
      hex_external_export    => hex_bus,
      ledr_external_export   => LEDR,
      ledg_external_export   => LEDG,
      sw_external_export     => SW,
      key_external_export    => KEY
    );

end architecture rtl;

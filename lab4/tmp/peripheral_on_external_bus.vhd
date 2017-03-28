-- Written by Gregg Guarino, Ph.D.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity peripheral_on_external_bus is
  port (
    clk           : in  std_logic;
    reset_n       : in  std_logic;
    i_address     : in  std_logic_vector (10 downto 0);
    i_addressWave : in  std_logic_vector (7 downto 0);
    i_bus_enable  : in  std_logic;
    i_byte_enable : in  std_logic_vector (3 downto 0);
    i_rw_n        : in  std_logic;
    i_write_data  : in  std_logic_vector (31 downto 0);
    o_acknowledge : out std_logic;
    o_read_data   : out std_logic_vector (31 downto 0);
    o_wave_data   : out std_logic_vector (31 downto 0)
  );
end entity peripheral_on_external_bus;

architecture peripheral_on_external_bus_arch of peripheral_on_external_bus is

begin

  -- Insert your code here

end peripheral_on_external_bus_arch;
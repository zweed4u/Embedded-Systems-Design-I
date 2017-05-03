-------------------------------------------------------------------------
-- Author: Gregg Guarino Ph.D.
-- January, 2017
-------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

ENTITY accum_mod is
  port (
    i_switch : in std_logic_vector(7 downto 0);
    i_trigger : in std_logic;
    i_reset_n : in std_logic;
    i_clk : in std_logic;
    o_accumulator : out std_logic_vector(15 downto 0)
  );
end entity accum_mod;

architecture accum_mod_arch of accum_mod is
  
  -- Signals
  signal accumulator : std_logic_vector(15 downto 0);

begin
  o_accumulator <= accumulator;

  -- Code
  accum_proc : process(i_clk) begin
    if (rising_edge(i_clk)) then
      if (i_reset_n = '0') then
        accumulator <= x"0000";
      elsif (i_trigger = '1') then
        accumulator <= accumulator + (x"00" & i_switch);
      end if;
    end if;
  end process accum_proc;
  
end architecture accum_mod_arch;
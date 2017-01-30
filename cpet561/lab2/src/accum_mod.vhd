library ieee;
use ieee.std_logic_1164.all;
--needs editting
entity accum_mod is
  port (
      i_switch : in std_logic_vector(7 downto 0);
      i_trigger : in std_logic;
      i_reset_n : in std_logic;
      i_clk : in std_logic;
      o_accumulator : out std_logic_vector(15 downto 0)
    );
end entity accum_mod;

architecture accum_mod_arch of accum_mod is

signal result_temp : std_logic_vector(15 downto 0);
begin
  process(i_clk,i_reset_n)
  begin
    if (i_reset_n='0') then                     --reset btn
        o_accumulator<=(others=>'0');           --all 0s
    elsif (i_clk'event and i_clk ='1') then     --not reset and clk
        if (i_trigger='1') then                 --switch pressed
            result_temp<=result_temp+i_switch;  --padding for the 16 bit number
            o_accumulator<=result_temp;         --adding the other switch
        end if;
    end if;
  end process;
end architecture accum_mod_arch;


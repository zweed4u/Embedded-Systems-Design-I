library ieee;
use ieee.std_logic_1164.all;
--needs editting
entity accum_mod is
  port (
    i_switch : in std_logic_vector(7 downto 0);
    i_trigger : in std_logic;
    i_clk : in std_logic;
    i_reset_n : in std_logic;
    o_accumulator : out std_logic_vector(15 downto 0)
  );
end entity accum_mod;

architecture accum_mod_arch of accum_mod is

signal SW_d1 : std_logic_vector(9 downto 0);
signal SW_d2 : std_logic_vector(9 downto 0);
signal KEY_d1 : std_logic_vector(3 downto 0);
signal KEY_d2 : std_logic_vector(3 downto 0);

begin

  o_SWsync <= SW_d2;
  o_KEYsync <= KEY_d2;

  sync_proc : process (i_CLOCK2_50) begin
    if (rising_edge(i_CLOCK2_50)) then
      SW_d1 <= i_SW;
      SW_d2 <= SW_d1;
      KEY_d1 <= i_KEY;
      KEY_d2 <= KEY_d1;
    end if;
  end process sync_proc;

end architecture accum_mod_arch;


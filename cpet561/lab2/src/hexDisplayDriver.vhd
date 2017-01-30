library ieee;
use ieee.std_logic_1164.all;
--needs editting
entity hexDisplayDriver is
  port (
    i_SW : in std_logic_vector(9 downto 0);
    i_KEY : in std_logic_vector(3 downto 0);
    i_CLOCK2_50 : in std_logic;
    o_SWsync : out std_logic_vector(9 downto 0);
    o_KEYsync : out std_logic_vector(3 downto 0)
  );
end entity hexDisplayDriver;

architecture hexDisplayDriver_arch of hexDisplayDriver is

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

end architecture hexDisplayDriver_arch;


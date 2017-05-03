library  IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

entity modulator is
  port (
    i_clock                  : in  std_logic;
    i_reset                  : in  std_logic;
    i_signalA                : in  std_logic_vector(15 DOWNTO 0);
    i_signalB                : in  std_logic_vector(15 DOWNTO 0);
    i_signalC                : in  std_logic_vector(15 DOWNTO 0);
    i_select                 : in  std_logic;
    o_dataOut               : out std_logic_vector(31 DOWNTO 0)
  );  
end entity modulator;

architecture rtl of modulator is 

  begin
  -- Do the math completely cominatorial, with no pipelining
  modulate : process (i_clock) is 
    variable signalMuxOut : std_logic_vector(15 DOWNTO 0);
    variable dataOut     : std_logic_vector(31 DOWNTO 0);
  begin
    if (rising_edge(i_clock)) then
      if (i_reset = '0') then
        o_dataOut   <= (others => '0');
      else
        if (i_select = '0') then
          signalMuxOut := i_signalA;
        else 
          signalMuxOut := i_signalB;
        end if;
          dataOut := signalMuxOut * i_signalC;
          o_dataOut <= dataOut;
      end if;
    end if;
  end process;
  
end rtl;
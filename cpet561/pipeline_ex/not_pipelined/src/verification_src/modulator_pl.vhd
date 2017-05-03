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

  signal signalMuxOut_d1 : std_logic_vector(15 DOWNTO 0);
  signal signalC_d1      : std_logic_vector(15 DOWNTO 0);
  signal dataOut_d2      : std_logic_vector(31 DOWNTO 0);

  begin
  -- Do the math completely cominatorial, with no pipelining
  modulate : process (i_clock) is 
    --variable signalMuxOut : std_logic_vector(15 DOWNTO 0);
    --variable dataOut     : std_logic_vector(31 DOWNTO 0);
  begin
    if (rising_edge(i_clock)) then
      if (i_reset = '0') then
        signalMuxOut_d1 <= x"0000";
        signalC_d1      <= x"0000";
        dataOut_d2      <= x"00000000";
      else
        if (i_select = '0') then
          signalMuxOut_d1 <= i_signalA;
        else 
          signalMuxOut_d1 <= i_signalB;
        end if;
        signalC_d1 <= i_signalC;
		dataOut_d2 <= signalMuxOut_d1 * signalC_d1;
      end if;
    end if;
  end process;
  
  o_dataOut <= dataOut_d2;
  
end rtl;
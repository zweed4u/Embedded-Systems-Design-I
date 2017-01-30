--------------------------------------------------------------
-- Written by Gregg Guarino Ph.D.
-- January 2017
--------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity debounce is
  port (
    i_pushButton : in std_logic;
    i_reset_n : in std_logic;
    i_clk : in std_logic;
    o_keypulse : out std_logic
  );
end entity debounce;

architecture debounce_arch of debounce is

  -- State Variable
  type state_type is (
    s_waitForLow,
    s_delayLow,
    s_delayHigh,
    s_waitForHigh
  );
  signal state : state_type;
  
  -- Signal declarations
  signal delayCntr : std_logic_vector(21 downto 0);

begin
  
  -- state machine
  stateMachine_proc : process(i_clk) begin
    if (rising_edge(i_clk)) then
      if (i_reset_n = '0') then
        state <= s_waitForLow;
        delayCntr <= "00" & x"00000";
        o_keypulse <= '0';
      else
        case state is
          when s_waitForLow =>
            if (i_pushButton = '0') then
              state <= s_delayLow;
              delayCntr <= "11" & x"93870";
              o_keypulse <= '1';
            end if;
          when s_delayLow =>
            o_keypulse <= '0';
            if (delayCntr = ("00" & x"00000")) then
              state <= s_waitForHigh;
            else
              delayCntr <= delayCntr - ("00" & x"00001");
            end if;
          when s_waitForHigh =>
            if (i_pushButton = '1') then
              state <= s_delayHigh;
              delayCntr <= "11" & x"93870";
            end if;
          when s_delayHigh =>
            if (delayCntr = ("00" & x"00000")) then
              state <= s_waitForLow;
            else
              delayCntr <= delayCntr - ("00" & x"00001");
            end if;
          when others =>
            o_keypulse <= '0';
            state <= s_waitForLow;
        end case;
      end if;
    end if;
  end process stateMachine_proc;
  
end architecture debounce_arch;



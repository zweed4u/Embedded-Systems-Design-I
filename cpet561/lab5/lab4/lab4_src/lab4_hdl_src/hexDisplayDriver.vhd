library ieee;
use ieee.std_logic_1164.all;

entity hexDisplayDriver is
  port (
    i_hex : in std_logic_vector(3 downto 0);
    o_sevenSeg : out std_logic_vector(6 downto 0)
  );
end entity hexDisplayDriver;

architecture hexDisplayDriver_arch of hexDisplayDriver is

  constant ZERO  : std_logic_vector(6 downto 0) := "1000000";
  constant ONE   : std_logic_vector(6 downto 0) := "1111001";
  constant TWO   : std_logic_vector(6 downto 0) := "0100100";
  constant THREE : std_logic_vector(6 downto 0) := "0110000";
  constant FOUR  : std_logic_vector(6 downto 0) := "0011001";
  constant FIVE  : std_logic_vector(6 downto 0) := "0010010";
  constant SIX   : std_logic_vector(6 downto 0) := "0000010";
  constant SEVEN : std_logic_vector(6 downto 0) := "1111000";
  constant EIGHT : std_logic_vector(6 downto 0) := "0000000";
  constant NINE  : std_logic_vector(6 downto 0) := "0010000";
  constant HEX_A : std_logic_vector(6 downto 0) := "0001000";
  constant HEX_B : std_logic_vector(6 downto 0) := "0000011";
  constant HEX_C : std_logic_vector(6 downto 0) := "1000110";
  constant HEX_D : std_logic_vector(6 downto 0) := "0100001";
  constant HEX_E : std_logic_vector(6 downto 0) := "0000110";
  constant HEX_F : std_logic_vector(6 downto 0) := "0001110";
  constant BLANK : std_logic_vector(6 downto 0) := "1111111";

begin

  hex2SevenSeg_proc : process (i_hex) begin
    case i_hex is
      when x"0" =>
        o_sevenSeg <= ZERO;
      when x"1" =>
        o_sevenSeg <= ONE;
      when x"2" =>
        o_sevenSeg <= TWO;
      when x"3" =>
        o_sevenSeg <= THREE;
      when x"4" =>
        o_sevenSeg <= FOUR;
      when x"5" =>
        o_sevenSeg <= FIVE;
      when x"6" =>
        o_sevenSeg <= SIX;
      when x"7" =>
        o_sevenSeg <= SEVEN;
      when x"8" =>
        o_sevenSeg <= EIGHT;
      when x"9" =>
        o_sevenSeg <= NINE;
      when x"A" =>
        o_sevenSeg <= HEX_A;
      when x"B" =>
        o_sevenSeg <= HEX_B;
      when x"C" =>
        o_sevenSeg <= HEX_C;
      when x"D" =>
        o_sevenSeg <= HEX_D;
      when x"E" =>
        o_sevenSeg <= HEX_E;
      when x"F" =>
        o_sevenSeg <= HEX_F;
      when OTHERS =>
        o_sevenSeg <= BLANK;
    end case;
  end process hex2SevenSeg_proc;

end architecture hexDisplayDriver_arch;


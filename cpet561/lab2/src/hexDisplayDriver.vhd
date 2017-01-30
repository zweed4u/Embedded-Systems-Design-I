library ieee;
use ieee.std_logic_1164.all;

entity hexDisplayDriver is
  port (
      i_hex : in std_logic_vector(3 downto 0);
      o_sevenSeg : out std_logic_vector(6 downto 0)
    );
end entity hexDisplayDriver;

architecture hexDisplayDriver_arch of hexDisplayDriver is
begin
process(i_hex)
    begin
    case i_hex is
    when "0000"=>--0
        o_sevenSeg<="1000000";
    when "0001"=>--1
        o_sevenSeg<="1111001";
    when "0010"=>--2
        o_sevenSeg<="0100100";
    when "0011"=>--3
        o_sevenSeg<="0110000";
    when "0100"=>--4
        o_sevenSeg<="0011001";
    when "0101"=>--5
        o_sevenSeg<="0010010";
    when "0110"=>--6
        o_sevenSeg<="0000010";
    when "0111"=>--7
        o_sevenSeg<="1111000";
    when "1000"=>--8
        o_sevenSeg<="0000000";
    when "1001"=>--9
        o_sevenSeg<="011000";
    when "1010"=>--10 a
        o_sevenSeg<="0001000";
    when "1011"=>--11 b
        o_sevenSeg<="0000011";
    when "1100"=>--12 c
        o_sevenSeg<="1000110";
    when "1101"=>--13 d
        o_sevenSeg<="0100001";
    when "1110"=>--14 e
        o_sevenSeg<="0000110";
    when "1111"=>--15 f
        o_sevenSeg<="0001110";
    when others =>
        o_sevenSeg<="1111111";
    end case;
end process;
end architecture hexDisplayDriver_arch;

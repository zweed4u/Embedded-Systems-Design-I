--
-- YOUR HEADER GOES HERE
--
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
ENTITY raminfr IS
  PORT (
    clk : IN std_logic;
    reset_n : IN std_logic;
    we_n : IN std_logic;
    be_n : IN std_logic_vector(3 DOWNTO 0);
    addr : IN std_logic_vector(11 DOWNTO 0);
    din : IN std_logic_vector(31 DOWNTO 0);
    dout : OUT std_logic_vector(31 DOWNTO 0)
);
END ENTITY raminfr;

ARCHITECTURE rtl OF raminfr IS
  TYPE ram_type IS ARRAY (4095 DOWNTO 0) OF std_logic_vector (31 DOWNTO 0);
  SIGNAL RAM : ram_type;
  SIGNAL read_addr : std_logic_vector(11 DOWNTO 0);
BEGIN
  RamBlock : PROCESS(clk) BEGIN
    IF (clk'event AND clk = '1') THEN
      IF (reset_n = '0') THEN
        read_addr <= (OTHERS => '0');
      ELSIF (we_n = '0') THEN      -- Might need to have rams be => 0 after subsequent passes
        CASE be_n IS
          when "0000" => 
            RAM(conv_integer(addr)) <= din;
          when "0001" => 
            RAM(conv_integer(addr)) <= din(31 DOWNTO 8) & (others => '0');
          when "0010" =>
            RAM(conv_integer(addr)) <= din(31 DOWNTO 16) & "00000000" & din(7 DOWNTO 0);
          when "0011" =>
            RAM(conv_integer(addr)) <= din(31 DOWNTO 16) & (others => '0');
          when "0100" =>
            RAM(conv_integer(addr)) <= din(31 DOWNTO 24) & "00000000" & din(15 DOWNTO 0);      
          when "0101" =>
            RAM(conv_integer(addr)) <= din(31 DOWNTO 24) & "00000000" & din(15 DOWNTO 8) &  "00000000";
          when "0110" =>
            RAM(conv_integer(addr)) <= din(31 DOWNTO 24) & "0000000000000000" & din(7 DOWNTO 0);
          when "0111" =>
            RAM(conv_integer(addr)) <= din(31 DOWNTO 24) & (others => '0');      
          when "1000" =>
            RAM(conv_integer(addr)) <= "00000000" & din(23 DOWNTO 0);     
          when "1001" =>
            RAM(conv_integer(addr)) <= "00000000" & din(23 DOWNTO 8) & "00000000";     
          when "1010" =>
            RAM(conv_integer(addr)) <= "00000000" & din(23 DOWNTO 16) & "00000000"  & din(7 DOWNTO 0);     
          when "1011" =>
            RAM(conv_integer(addr)) <= "00000000" & din(23 DOWNTO 16) & "0000000000000000";     
          when "1100" =>
            RAM(conv_integer(addr)) <= "0000000000000000" & din(15 DOWNTO 0);     
          when "1101" =>
            RAM(conv_integer(addr)) <= "0000000000000000" & din(15 DOWNTO 8) & "00000000";     
          when "1110" =>
            RAM(conv_integer(addr)) <= "000000000000000000000000" & din(7 DOWNTO 0);
          when "1111" =>
            RAM(conv_integer(addr)) <= (others => '0');
          when others =>
            RAM(conv_integer(addr)) <= (others => '0');        
        END CASE;
      END IF;
      read_addr <= addr;
    END IF;
  END PROCESS RamBlock;
  dout <= RAM(conv_integer(read_addr));
END ARCHITECTURE rtl;

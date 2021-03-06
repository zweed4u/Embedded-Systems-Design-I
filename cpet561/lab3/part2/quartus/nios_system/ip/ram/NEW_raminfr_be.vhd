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
  TYPE ram_type IS ARRAY (4095 DOWNTO 0) OF std_logic_vector (7 DOWNTO 0);
  SIGNAL ram_byte_lane0 : ram_type := (OTHERS=> (OTHERS=>'0'));
  SIGNAL ram_byte_lane1 : ram_type := (OTHERS=> (OTHERS=>'0'));
  SIGNAL ram_byte_lane2 : ram_type := (OTHERS=> (OTHERS=>'0'));
  SIGNAL ram_byte_lane3 : ram_type := (OTHERS=> (OTHERS=>'0'));
  SIGNAL ram0 : std_logic_vector(7 DOWNTO 0) := "00000000";
  SIGNAL ram1 : std_logic_vector(7 DOWNTO 0) := "00000000";
  SIGNAL ram2 : std_logic_vector(7 DOWNTO 0) := "00000000";
  SIGNAL ram3 : std_logic_vector(7 DOWNTO 0) := "00000000";
  SIGNAL read_addr : std_logic_vector(11 DOWNTO 0);
BEGIN
  RamBlock : PROCESS(clk) BEGIN
    IF (clk'event AND clk = '1') THEN
      IF (reset_n = '0') THEN
        read_addr <= (OTHERS => '0');
      ELSIF (we_n = '0') THEN
          IF (be_n(0) = '0') THEN -- lowest byte line written to
            ram_byte_lane0(conv_integer(addr))  <= din(7 DOWNTO 0);
          END IF; 
          IF (be_n(1) = '0') THEN -- 2nd lowest byte line written to
            ram_byte_lane1(conv_integer(addr))  <= din(15 DOWNTO 8);
          END IF;  
          IF (be_n(2) = '0') THEN -- 2nd highest byte line written to
            ram_byte_lane2(conv_integer(addr))  <= din(23 DOWNTO 16);
          END IF;  
          IF (be_n(3) = '0') THEN -- highest byte line written to
            ram_byte_lane3(conv_integer(addr))  <= din(31 DOWNTO 24);
          END IF;
      END IF;
      read_addr <= addr;
    END IF;
  END PROCESS RamBlock;
  ram0 <= ram_byte_lane0(conv_integer(read_addr)); 
  ram1 <= ram_byte_lane1(conv_integer(read_addr));
  ram2 <= ram_byte_lane2(conv_integer(read_addr));
  ram3 <= ram_byte_lane3(conv_integer(read_addr));
  dout <= ram3 & ram2 & ram1 & ram0;
END ARCHITECTURE rtl;
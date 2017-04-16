-------------------------------------------------------------------------
-- Author: Zachary Weeden
-- March, 2017
-------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;

ENTITY secondStage is
  port (
    clk               : in std_logic;
    i_dataReq         : in std_logic;
    i_reset           : in std_logic;
    secondStageInput  : in signed(35 downto 0); 
    secondStageOutput : out signed(35 downto 0)
  );
end entity secondStage;

architecture secondStage_arch of secondStage is
  signal B_in  : signed (35 DOWNTO 0);
  signal B_1   : signed (35 DOWNTO 0);
  signal B_2   : signed (35 DOWNTO 0);
  signal B_out : signed (35 DOWNTO 0);
  signal x1_d0 : signed (35 DOWNTO 0);-- <= (others => '0');
  signal x1_d1 : signed (35 DOWNTO 0);-- <= (others => '0');
  signal x1_d2 : signed (35 DOWNTO 0);-- <= (others => '0');
  
  signal multOutb12      : signed (35 DOWNTO 0);
  signal multOutb12_full : STD_LOGIC_VECTOR (71 DOWNTO 0);
  
  signal multOuta22      : signed (35 DOWNTO 0);
  signal multOuta22_full : STD_LOGIC_VECTOR (71 DOWNTO 0);
  
  signal multOutb22      : signed (35 DOWNTO 0);
  signal multOutb22_full : STD_LOGIC_VECTOR (71 DOWNTO 0);
  
  signal multOuta32      : signed (35 DOWNTO 0);
  signal multOuta32_full : STD_LOGIC_VECTOR (71 DOWNTO 0);
  
  signal multOutb32      : signed (35 DOWNTO 0);
  signal multOutb32_full : STD_LOGIC_VECTOR (71 DOWNTO 0);
  
  constant b12_const : signed(35 downto 0) := x"00000015B"; -- 0.0026446*(2^17) = 347
  constant b22_const : signed(35 downto 0) := x"0000002B5"; -- 0.0052893*(2^17) = 693
  constant b32_const : signed(35 downto 0) := x"00000015B"; -- 0.0026446*(2^17) = 347
  constant a22_const : signed(35 downto 0) := x"FFFFC2155"; -- -1.9349*(2^17) = -253611
  constant a32_const : signed(35 downto 0) := x"00001E316"; -- 0.94353*(2^17) = 123670
  
  
  COMPONENT filter_mult IS
    PORT
    (
        dataa   : IN STD_LOGIC_VECTOR (35 DOWNTO 0);
        datab   : IN STD_LOGIC_VECTOR (35 DOWNTO 0);
        result  : OUT STD_LOGIC_VECTOR (71 DOWNTO 0)
    );
  END COMPONENT filter_mult;  
  
  begin
  
  process (clk) begin
    --clk'd process
    if (rising_edge(clk)) then
      if (i_reset='0') then
        x1_d1 <= (others => '0');
      elsif (i_dataReq = '1') then
        x1_d1 <= x1_d0;
      end if;
    end if;
  end process;
  
  process (clk) begin
    --clk'd process (should this be nested in above process or its own?)
    if (rising_edge(clk)) then
      if (i_reset='0') then
        x1_d2 <= (others => '0');
      elsif (i_dataReq = '1') then
        x1_d2 <= x1_d1;
      end if;
    end if;
  end process;
  
  
  filter_mult_b12 : filter_mult
  port map (
    dataa  => std_logic_vector(x1_d0),
    datab  => std_logic_vector(b12_const),
    result => (multOutb12_full)
  );
  multOutb12 <= signed(multOutb12_full(52 downto 17));
  
  filter_mult_a22 : filter_mult
  port map (
    dataa  => std_logic_vector(x1_d1),
    datab  => std_logic_vector(a22_const),
    result => (multOuta22_full)
  );
  multOuta22 <= signed(multOuta22_full(52 downto 17));
  
  filter_mult_b22 : filter_mult
  port map (
    dataa  => std_logic_vector(x1_d1),
    datab  => std_logic_vector(b22_const),
    result => (multOutb22_full)
  );
  multOutb22 <= signed(multOutb22_full(52 downto 17));
  
  filter_mult_a32 : filter_mult
  port map (
    dataa  => std_logic_vector(x1_d2),
    datab  => std_logic_vector(a32_const),
    result => (multOuta32_full)
  );
  multOuta32 <= signed(multOuta32_full(52 downto 17));
  
  filter_mult_b32 : filter_mult
  port map (
    dataa  => std_logic_vector(x1_d2),
    datab  => std_logic_vector(b32_const),
    result => (multOutb32_full)
  );
  multOutb32 <= signed(multOutb32_full(52 downto 17));
  
  B_in  <= secondStageInput;
  B_1   <= B_in - (multOuta22);
  x1_d0 <= B_1 - (multOuta32);
  B_2   <= (multOutb12) + (multOutb22);
  B_out <= B_2 + (multOutb32);

  secondStageOutput <= B_out;
end architecture secondStage_arch;
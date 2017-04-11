-------------------------------------------------------------------------
-- Author: Zachary Weeden
-- March, 2017
-------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;

ENTITY thirdStage is
  port (
    clk              : in std_logic;
    i_dataReq        : in std_logic;
    i_reset          : in std_logic;
    thirdStageInput  : in signed(35 downto 0); 
    thirdStageOutput : out signed(35 downto 0)
  );
end entity thirdStage;

architecture thirdStage_arch of thirdStage is
  signal C_in  : signed (35 DOWNTO 0);
  signal C_1   : signed (35 DOWNTO 0);
  signal C_2   : signed (35 DOWNTO 0);
  signal C_out : signed (35 DOWNTO 0);
  signal x1_d0 : signed (35 DOWNTO 0);
  signal x1_d1 : signed (35 DOWNTO 0);
  signal x1_d2 : signed (35 DOWNTO 0);

  signal multOutb13      : signed (35 DOWNTO 0);
  signal multOutb13_full : signed (71 DOWNTO 0);
  
  signal multOuta23      : signed (35 DOWNTO 0);
  signal multOuta23_full : signed (71 DOWNTO 0);
  
  signal multOutb23      : signed (35 DOWNTO 0);
  signal multOutb23_full : signed (71 DOWNTO 0);
  
  signal multOuta33      : signed (35 DOWNTO 0);
  signal multOuta33_full : signed (71 DOWNTO 0);
  
  signal multOutb33      : signed (35 DOWNTO 0);
  signal multOutb33_full : signed (71 DOWNTO 0);
  
  constant b13_const : signed(35 downto 0) := x"00000800A"; -- 0.25008*(2^17) = 32778
  constant b23_const : signed(35 downto 0) := x"000010014"; -- 0.50015*(2^17) = 65556
  constant b33_const : signed(35 downto 0) := x"00000800A"; -- 0.25008*(2^17) = 32778
  constant a23_const : signed(35 downto 0) := x"FFFFC4C98"; -- -1.8504*(2^17) = -242536
  constant a33_const : signed(35 downto 0) := x"00001B79C"; -- 0.85861*(2^17) = 112540
  
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
      if (i_reset='1') then
        x1_d1 <= (others => '0');
      elsif (i_dataReq = '1') then
        x1_d1 <= x1_d0;
      end if;
    end if;
  end process;
  
  process (clk) begin
    --clk'd process (should this be nested in above process or its own?)
    if (rising_edge(clk)) then
      if (i_reset='1') then
        x1_d2 <= (others => '0');
      elsif (i_dataReq = '1') then
        x1_d2 <= x1_d1;
      end if;
    end if;
  end process;
  
  filter_mult_b13 : filter_mult
  port map (
    dataa  => std_logic_vector(x1_d0),
    datab  => std_logic_vector(b13_const),
    result => std_logic_vector(multOutb13_full)
  );
  multOutb13 <= signed(multOutb13_full(52 downto 17));
  
  filter_mult_a23 : filter_mult
  port map (
    dataa  => std_logic_vector(x1_d1),
    datab  => std_logic_vector(a23_const),
    result => std_logic_vector(multOuta23_full)
  );
  multOuta23 <= signed(multOuta23_full(52 downto 17));
  
  filter_mult_b23 : filter_mult
  port map (
    dataa  => std_logic_vector(x1_d1),
    datab  => std_logic_vector(b23_const),
    result => std_logic_vector(multOutb23_full)
  );
  multOutb23 <= signed(multOutb23_full(52 downto 17));
  
  filter_mult_a33 : filter_mult
  port map (
    dataa  => std_logic_vector(x1_d2),
    datab  => std_logic_vector(a33_const),
    result => std_logic_vector(multOuta33_full)
  );
  multOuta33 <= signed(multOuta33_full(52 downto 17));
  
  filter_mult_b33 : filter_mult
  port map (
    dataa  => std_logic_vector(x1_d2),
    datab  => std_logic_vector(b33_const),
    result => std_logic_vector(multOutb33_full)
  );
  multOutb33 <= signed(multOutb33_full(52 downto 17));
  
  C_in  <= thirdStageInput;
  C_1   <= C_in-(multOuta23);
  x1_d0 <= C_1-(multOuta33);
  C_2   <= (multOutb13)+(multOutb23);
  C_out <= C_2+(multOutb33);

  thirdStageOutput <= C_out;
end architecture thirdStage_arch;
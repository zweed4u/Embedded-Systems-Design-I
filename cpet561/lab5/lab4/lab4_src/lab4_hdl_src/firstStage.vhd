-------------------------------------------------------------------------
-- Author: Zachary Weeden
-- March, 2017
-------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;

ENTITY firstStage is
  port (
    clk              : in std_logic;
    i_dataReq        : in std_logic;
    i_reset          : in std_logic;
    firstStageInput  : in signed(35 downto 0); 
    firstStageOutput : out signed(35 downto 0)
  );
end entity firstStage;

architecture firstStage_arch of firstStage is
  signal A_in            : signed (35 DOWNTO 0);
  signal x1_d0           : signed (35 DOWNTO 0);-- <= (others => '0');
  signal x1_d1           : signed (35 DOWNTO 0);-- <= (others => '0');
  signal A_out           : signed (35 DOWNTO 0);
  signal multOuta21      : signed (35 DOWNTO 0);
  signal multOuta21_full : STD_LOGIC_VECTOR (71 DOWNTO 0);
  
  signal multOutb21      : signed (35 DOWNTO 0);
  signal multOutb21_full : STD_LOGIC_VECTOR (71 DOWNTO 0);
  
  signal multOutb11      : signed (35 DOWNTO 0);
  signal multOutb11_full : STD_LOGIC_VECTOR (71 DOWNTO 0);
  
  
  constant b11_const : signed(35 downto 0) := x"0000001B7"; -- 0.0033507*(2^17) = 439
  constant b21_const : signed(35 downto 0) := x"0000001B7"; -- 0.0033507*(2^17) = 439
  constant b31_const : signed(35 downto 0) := x"000000000";
  constant a21_const : signed(35 downto 0) := x"FFFFE2E14"; -- -0.91*(2^17) = 119276
  constant a31_const : signed(35 downto 0) := x"000000000";
  
  
  COMPONENT filter_mult IS
    PORT
    (
        dataa   : IN STD_LOGIC_VECTOR (35 DOWNTO 0);
        datab   : IN STD_LOGIC_VECTOR (35 DOWNTO 0);
        result  : OUT STD_LOGIC_VECTOR (71 DOWNTO 0)
    );
  END COMPONENT filter_mult;
  
  begin
  
  filter_mult_a21 : filter_mult
  port map (
    dataa  => std_logic_vector(x1_d1),
    datab  => std_logic_vector(a21_const),
    result => (multOuta21_full)
  );
  multOuta21 <= signed(multOuta21_full(52 downto 17));
  
  
  filter_mult_b21 : filter_mult
  port map (
    dataa  => std_logic_vector(x1_d1),
    datab  => std_logic_vector(b21_const),
    result => (multOutb21_full)
  );
  multOutb21 <= signed(multOutb21_full(52 downto 17));
  
  
  filter_mult_b11 : filter_mult
  port map (
    dataa  => std_logic_vector(x1_d0),
    datab  => std_logic_vector(b11_const),
    result => (multOutb11_full)
  );
  multOutb11 <= signed(multOutb11_full(52 downto 17));
  
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

  A_in  <= firstStageInput;
  x1_d0 <= A_in - (multOuta21);
  A_out <= (multOutb11) + (multOutb21);
  firstStageOutput <= A_out;
  
end architecture firstStage_arch;
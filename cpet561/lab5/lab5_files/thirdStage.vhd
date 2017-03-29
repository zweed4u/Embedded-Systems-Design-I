-------------------------------------------------------------------------
-- Author: Zachary Weeden
-- March, 2017
-------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

ENTITY thirdStage is
  port (
    clk : in std_logic;
    i_dataReq : in std_logic;
    i_reset : in std_logic;
    thirdStageInput : in std_logic; 
    thirdStageOutput : out std_logic
  );
end entity thirdStage;

architecture thirdStage_arch of thirdStage is
  signal C_in : std_logic;
  signal C_1 : std_logic;
  signal C_2 : std_logic;
  signal C_out : std_logic;
  signal x_d0 : std_logic;
  signal x_d1 : std_logic;
  signal x_d2 : std_logic;

  constant b13_const : signed(35 downto 0) := x"000007FF6";
  constant b23_const : signed(35 downto 0) := x"00000FFEC";
  constant b33_const : signed(35 downto 0) := x"000007FF6";
  constant a23_const : signed(35 downto 0) := x"FFFFF4C98";
  constant a33_const : signed(35 downto 0) := x"000004864";
  
  begin 
  C_in <= thirdStageInput;
  C_1 <= C_in-(x_d1*a23_const);
  x_d0 <= C_1-(x_d2*a33_const);
  C_2 <= (x_d0*b13_const)+(x_d1*b23_const);
  C_out <= C_2+(x_d2*b33_const);

  --clk'd process
  if (rising_edge(clk)) then
    if (i_reset='1') then
      x_d1 <= '0';
    elsif (i_dataReq = '1') then
      x_d1 <= x_d0;
    end if;
  end if;

  --clk'd process (should this be nested in above process or its own?)
  if (rising_edge(clk)) then
    if (i_reset='1') then
      x_d2 <= '0';
    elsif (i_dataReq = '1') then
      x_d2 <= x_d1;
    end if;
  end if;

  thirdStageOutput <= C_out;
end architecture thirdStage_arch;
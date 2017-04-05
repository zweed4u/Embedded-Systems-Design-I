-------------------------------------------------------------------------
-- Author: Zachary Weeden
-- March, 2017
-------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

ENTITY secondStage is
  port (
    clk : in std_logic;
    i_dataReq : in std_logic;
    i_reset : in std_logic;
    secondStageInput : in std_logic; 
    secondStageOutput : out std_logic
  );
end entity secondStage;

architecture secondStage_arch of secondStage is
  signal B_in : std_logic;
  signal B_1 : std_logic;
  signal B_2 : std_logic;
  signal B_out : std_logic;
  signal x_d0 : std_logic;
  signal x_d1 : std_logic;
  signal x_d2 : std_logic;

  constant b12_const : signed(35 downto 0) := x"00000015B"; -- 0.0026446*(2^17) = 347
  constant b22_const : signed(35 downto 0) := x"00000027F"; -- 0.0052893*(2^17) = 639
  constant b32_const : signed(35 downto 0) := x"00000015B"; -- 0.0026446*(2^17) = 347
  constant a22_const : signed(35 downto 0) := x"FFFFC2155"; -- -1.9349*(2^17) = -253611
  constant a32_const : signed(35 downto 0) := x"00001E316"; -- 0.94353*(2^17) = 123670
  
  begin
  B_in <= secondStageInput;
  B_1 <= B_in-(x_d1*a22_const);
  x_d0 <= B_1-(x_d2*a32_const);
  B_2 <= (x_d0*b12_const)+(x_d1*b22_const);
  B_out <= B_2+(x_d2*b32_const);

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


  secondStageOutput <= B_out;
end architecture secondStage_arch;
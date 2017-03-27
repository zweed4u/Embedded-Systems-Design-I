-------------------------------------------------------------------------
-- Author: Zachary Weeden
-- March, 2017
-------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

ENTITY firstStage is
  port (
    clk : in std_logic;
    i_dataReq : in std_logic;
    i_reset : in std_logic;
    firstStageInput : in std_logic; 
    firstStageOutput : out std_logic
  );
end entity firstStage;

architecture firstStage_arch of firstStage is
  signal A' : std_logic;
  signal x_d0 : std_logic;
  signal x_d1 : std_logic;
  signal A0 : std_logic;
  
  constant b11_const : signed(35 downto 0) := x"000000049";
  constant b21_const : signed(35 downto 0) := x"000000049";
  constant b31_const : signed(35 downto 0) := x"000000000";
  constant a21_const : signed(35 downto 0) := x"FFFFE2E14";
  constant a31_const : signed(35 downto 0) := x"000000000";
  
  begin
  x_d0 <= A'-(a21_const*x_d1);
  A0 <= (b11_const*x_d0)+(b21_const*x_d1);
  
  --clk'd process
  if (rising_edge(clk)) then
    if (i_reset='1') then
      x_d1 <= '0';
    elsif (i_dataReq = '1') then
      x_d1 <= x_d0;
    end if;
  end if;

  firstStageOutput<=A0;
end architecture firstStage_arch;
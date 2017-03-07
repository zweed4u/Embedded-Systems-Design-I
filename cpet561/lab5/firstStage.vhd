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
    firstStageInput : in std_logic; 
    firstStageOutput : out std_logic
  );
end entity firstStage;

architecture firstStage_arch of firstStage is
  signal A : std_logic;
  signal B : std_logic;
  signal C : std_logic;
  signal D : std_logic;
  signal E : std_logic;
  signal F : std_logic;
  signal G : std_logic;
  signal H : std_logic;
  
  begin
  A<=firstStageInput;
  B<=s(1)*A;
  C<=B-F;
  D<=b(1)(1)*C;
  if (rising_edge(clk)) then
    if (data_reg='1') then
      E<=C;
    end if;
  end if;
  F<=a(2)(1)*E;
  G<=b(2)(1)*E;
  H<=D+G;
  firstStageOutput<=H;
end architecture firstStage_arch;
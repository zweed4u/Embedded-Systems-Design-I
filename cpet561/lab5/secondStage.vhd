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
    secondStageInput : in std_logic; 
    secondStageOutput : out std_logic
  );
end entity secondStage;

architecture secondStage_arch of secondStage is
  signal H : std_logic;
  signal I : std_logic;
  signal J : std_logic;
  signal K : std_logic;
  signal L : std_logic;
  signal M : std_logic;
  signal N : std_logic;
  signal O : std_logic;
  signal P : std_logic;
  signal Q : std_logic;
  signal R : std_logic;
  signal S : std_logic;

  begin
  H<=secondStageInput;
  I<=H-O;
  J<=I-Q;
  K<=b(1)(2)*J;
  L<=K+M;
  M<=b(2)(2)*N;
  if (rising_edge(clk)) then
  	if (data_reg='1') then
  	  N<= J;
  	end if;
  end if;
  O<=a(2)(2)*N;
  if (rising_edge(clk)) then
  	if (data_reg='1') then
  	  P<= N;
  	end if;
  end if;
  Q<=a(3)(2)*P;
  R<=b(3)(2)*P;
  S<=L+R;
  secondStageOutput<=S;
end architecture secondStage_arch;
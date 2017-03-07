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
    thirdStageInput : in std_logic; 
    thirdStageOutput : out std_logic
  );
end entity thirdStage;

architecture thirdStage_arch of thirdStage is
  signal S : std_logic;
  signal T : std_logic;
  signal U : std_logic;
  signal V : std_logic;
  signal W : std_logic;
  signal X : std_logic;
  signal Y : std_logic;
  signal Z : std_logic;
  signal AA : std_logic;
  signal BB : std_logic;
  signal CC : std_logic;
  signal DD : std_logic;
  
  begin 
  S<=thirdStageInput;
  T<=S-AA;
  U<=T-DD;
  V<=b(1)(3)*U;
  X<=V+Y;
  Y<=b(2)(3)*Z;
  if (rising_edge(clk)) then
  	if (data_reg='1') then
  	  Z<=U;
  	end if;
  end if;
  AA<=a(2)(3)*Z
  if (rising_edge(clk)) then
    if (data_reg='1') then
      BB<=Z;
    end if;
  end if;
  CC<=b(3)(3)*BB;
  DD<=a(3)(3)*BB;
  W<=X+CC;
  thirdStageOutput<=W;
end architecture thirdStage_arch;
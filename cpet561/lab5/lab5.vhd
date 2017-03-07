-------------------------------------------------------------------------
-- Author: Zachary Weeden
-- March, 2017
-------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

ENTITY lab5 is
  port (
    clk : in std_logic;
    topInput : in std_logic; 
    topOutput : out std_logic
  );
end entity lab5;

architecture lab5_arch of lab5 is
  signal firstToSecondIntermediary : std_logic;
  signal secondToThirdIntermediary : std_logic;

  component firstStage is
    port(
      clk : in std_logic;
      firstStageInput : in std_logic;
      firstStageOutput : out std_logic
      );
   end component firstStage;

   component secondStage is
    port(
      clk : in std_logic;
      secondStageInput : in std_logic;
      secondStageOutput : out std_logic
      );
   end component secondStage;

   component thirdStage is
    port(
      clk : in std_logic;	
      thirdStageInput : in std_logic;
      thirdStageOutput : out std_logic
      );
   end component thirdStage;

  begin
  firstStage_inst1 : firstStage
    port map (
      clk => clk,
      firstStageInput => topInput,
      firstStageOutput => firstToSecondIntermediary
    );

  secondStage_inst1 : secondStage
    port map (
      clk => clk,
      secondStageInput => firstToSecondIntermediary,
      secondStageOutput => secondToThirdIntermediary
    );

  thirdStage_inst1 : thirdStage
    port map (
      clk => clk,
      thirdStageInput => secondToThirdIntermediary,
      thirdStageOutput => topOutput
    );
end architecture lab5_arch;
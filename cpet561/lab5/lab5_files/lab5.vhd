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
    i_clk_50 : in std_logic;
    i_reset : in std_logic;
    i_audioSample : in signed(31 downto 0);
    i_dataReq : in std_logic;
    o_audioSampleFiltered : out signed(31 downto 0)
  );

end entity lab5;

architecture lab5_arch of lab5 is
  signal firstToSecondIntermediary : std_logic;
  signal secondToThirdIntermediary : std_logic;

  component firstStage is
    port(
      clk : in std_logic;
      i_reset : in std_logic;
      i_dataReq : in std_logic;
      firstStageInput : in std_logic;
      firstStageOutput : out std_logic
      );
   end component firstStage;

   component secondStage is
    port(
      clk : in std_logic;
      i_reset : in std_logic;
      i_dataReq : in std_logic;
      secondStageInput : in std_logic;
      secondStageOutput : out std_logic
      );
   end component secondStage;

   component thirdStage is
    port(
      clk : in std_logic;   
      i_reset : in std_logic;
      i_dataReq : in std_logic;
      thirdStageInput : in std_logic;
      thirdStageOutput : out std_logic
      );
   end component thirdStage;

  begin
  firstStage_inst1 : firstStage
    port map (
      clk => clk,
      i_dataReq => i_dataReq,
      i_reset => i_reset,
      firstStageInput => i_audioSample,
      firstStageOutput => firstToSecondIntermediary
    );

  --add delay between stages z^-1
  --like...
  --if (rising_edge(clk)) then
  --  if (i_reset='1') then
  --    x_d1 <= '0';
  --  elsif (i_dataReq = '1') then
  --    x_d1 <= x_d0;
  --  end if;
  --end if;

  secondStage_inst1 : secondStage
    port map (
      clk => clk,
      i_dataReq => i_dataReq,
      i_reset => i_reset,
      secondStageInput => firstToSecondIntermediary,
      secondStageOutput => secondToThirdIntermediary
    );

  --add delay between stages z^-1
  --like...
  --if (rising_edge(clk)) then
  --  if (i_reset='1') then
  --    x_d1 <= '0';
  --  elsif (i_dataReq = '1') then
  --    x_d1 <= x_d0;
  --  end if;
  --end if;

  thirdStage_inst1 : thirdStage
    port map (
      clk => clk,
      i_dataReq => i_dataReq,
      i_reset => i_reset,
      thirdStageInput => secondToThirdIntermediary,
      thirdStageOutput => o_audioSampleFiltered
    );
end architecture lab5_arch;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_textio.all;
use std.textio.all; 

entity audio_filter is
  port (
    i_clk_50              : in std_logic;
    i_reset               : in std_logic;
    i_audioSample         : in signed(31 downto 0);
    i_dataReq             : in std_logic;
    o_audioSampleFiltered : out signed(31 downto 0)
  );
end entity;

architecture audio_filter_arch of audio_filter is

-- Signal declarations
signal firstToSecondIntermediary : signed(35 downto 0);
signal secondToThirdIntermediary : signed(35 downto 0);

signal filterInOneChannel : signed(15 downto 0);
signal filterInResized    : signed(35 downto 0);
signal filterSection_1in  : signed(35 downto 0);
signal filterOutput       : signed(35 downto 0);

component firstStage is
    port(
      clk              : in std_logic;
      i_reset          : in std_logic;
      i_dataReq        : in std_logic;
      firstStageInput  : in signed(35 downto 0); 
      firstStageOutput : out signed(35 downto 0)
      );
end component firstStage;

component secondStage is
    port(
      clk               : in std_logic;
      i_reset           : in std_logic;
      i_dataReq         : in std_logic;
      secondStageInput  : in signed(35 downto 0); 
      secondStageOutput : out signed(35 downto 0)
      );
end component secondStage;

component thirdStage is
    port(
      clk              : in std_logic;   
      i_reset          : in std_logic;
      i_dataReq        : in std_logic;
      thirdStageInput  : in signed(35 downto 0); 
      thirdStageOutput : out signed(35 downto 0)
      );
end component thirdStage;


begin
-- Grab just one channel from input
filterInOneChannel <= i_audioSample(15 downto 0);

-- Simply resize the 16 bit input to 36 bits. There is an implied
-- divide by 4 involved in this, since we are going from 15 bits to
-- 17 bits after the implied decimal point. This will be canceled by
-- the multiply by 4 on the output.
filterInResized <= resize(filterInOneChannel, filterInResized'length);

-- Implement the divide by 16 which is multiplier s(1)
filterSection_1in <= shift_right(filterInResized, 4);

-- Grab the lowest 16 bits of your filter output and place them
-- into the output port. There is an implied multiply by 4 here
-- due to going from 15 bits to 17 bits after the decimal. This cancels
-- the previous divide by 4.
o_audioSampleFiltered <= filterOutput(15 downto 0) & filterOutput(15 downto 0);
firstStage_inst1 : firstStage
    port map (
      clk => i_clk_50,
      i_dataReq => i_dataReq,
      i_reset => i_reset,
      firstStageInput => filterSection_1in,
      firstStageOutput => firstToSecondIntermediary
    );

--delay between stages
process (clk) begin
--clk'd process
  if (rising_edge(i_clk_50)) then
    if (i_reset='1') then
      secondStageInput <= '0';
    elsif (i_dataReq = '1') then
      secondStageInput <= firstToSecondIntermediary;
    end if;
  end if;
end process;

secondStage_inst1 : secondStage
    port map (
      clk => i_clk_50,
      i_dataReq => i_dataReq,
      i_reset => i_reset,
      secondStageInput => firstToSecondIntermediary,
      secondStageOutput => secondToThirdIntermediary
    );

--delay between stages
process (i_clk_50) begin
--clk'd process
  if (rising_edge(i_clk_50)) then
    if (i_reset='1') then
      thirdStageInput <= '0';
    elsif (i_dataReq = '1') then
      thirdStageInput <= secondToThirdIntermediary;
    end if;
  end if;
end process;
  
thirdStage_inst1 : thirdStage
    port map (
      clk => i_clk_50,
      i_dataReq => i_dataReq,
      i_reset => i_reset,
      thirdStageInput => secondToThirdIntermediary,
      thirdStageOutput => o_audioSampleFiltered
    );

end architecture audio_filter_arch;

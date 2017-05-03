----------------------------------------------------------------------
-- CODEC DAC interface
-- Copyright (c) 2016 Evergreen Embedded Development Inc.
-- Written by Gregg Guarino Ph.D.
-- February 29, 2016
----------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity codec_dac_interface is
  port (
    i_clk_50             : in std_logic;
    i_audioSample        : in std_logic_vector(31 downto 0); 
    i_daclrckFallingEdge : in std_logic;
    i_daclrckRisingEdge  : in std_logic;
    i_bclkRisingEdge     : in std_logic;
    o_dataReq            : out std_logic; 
    o_AUD_DACDAT         : out std_logic
  );
end entity codec_dac_interface;

architecture codec_dac_interface_arch of codec_dac_interface is

  -- Internal signals
  signal  audioSample : std_logic_vector(31 downto 0);
  signal  shiftReg : std_logic_vector(16 downto 0);
  signal  AUD_BCLK_d1 : std_logic;
  signal  AUD_BCLK_d2 : std_logic;
  signal  AUD_BCLK_d3 : std_logic;
  signal  AUD_BCLK_d4 : std_logic;
  signal  AUD_DACLRCK_d1 : std_logic;
  signal  AUD_DACLRCK_d2 : std_logic;
  signal  AUD_DACLRCK_d3 : std_logic;
  signal  AUD_DACLRCK_d4 : std_logic;
  signal  dataReq : std_logic;
  signal  latchAudioSample : std_logic;

begin

  -- Assignments
  o_AUD_DACDAT <= shiftReg(16);
  o_dataReq <= dataReq;

  -- Load the shift register on the edge of DACLRC
  process (i_clk_50) begin
    if (rising_edge (i_clk_50)) then
      if (i_daclrckFallingEdge = '1') then
        -- Falling edge, left channel
        dataReq <= '1';
        audioSample <= i_audioSample;
      elsif (dataReq = '1') then
        latchAudioSample <= '1';
        dataReq <= '0';
      elsif (latchAudioSample = '1') then
        latchAudioSample <= '0';
        shiftReg(15 downto 0) <= audioSample(31 downto 16);
      elsif (i_daclrckRisingEdge = '1') then
        -- Rising edge, right channel
        shiftReg(15 downto 0) <= audioSample(15 downto 0);
      elsif (i_bclkRisingEdge = '1') then
        -- Rising edge of audio bit clock
        shiftReg(16 downto 1) <= shiftReg(15 downto 0);
        shiftReg(0) <= '0';
      end if;
    end if;
  end process;
  
end architecture;
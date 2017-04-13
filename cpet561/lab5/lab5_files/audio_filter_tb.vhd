-- Example test bench
-- Written by Gregg Guarino
-- March 16, 2015
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_textio.all;
use std.textio.all; 

ENTITY audio_filter_tb IS
END;

ARCHITECTURE TEST_BENCH OF audio_filter_tb IS

  -- component ports
  SIGNAL i_clk_50              : std_logic				:= '0';
  SIGNAL i_reset               : std_logic				:= '0';
  SIGNAL i_audioSample         : signed(31 downto 0)	:= (OTHERS => '1');
  SIGNAL i_dataReq             : std_logic				:= '0';
  SIGNAL o_audioSampleFiltered : signed(31 downto 0)	:= (OTHERS => '0');
  --


  -- signals for test bench control
  SIGNAL sim_done : boolean := false;
  SIGNAL PERIOD   : time    := 20 ns;   -- 50MHz
  type array_type1  is array (0 to 39) of signed(15 downto 0);
  signal audioSampleArray : array_type1 ;

  COMPONENT audio_filter IS
    PORT(
      i_clk_50              : in std_logic;
      i_reset               : in std_logic;
      i_audioSample         : in signed(31 downto 0);
      i_dataReq             : in std_logic;
      o_audioSampleFiltered : out signed(31 downto 0)
    );
  END COMPONENT;
  
BEGIN
  -----------------------------------------------------------------------
  -- Instantiate the unit under test
  -----------------------------------------------------------------------
  -- Port Mapping the ramninfr_be
  UUT : audio_filter
    PORT MAP (
      i_clk_50              => i_clk_50,
      i_reset               => i_reset,
      i_audioSample         => i_audioSample ,       
      i_dataReq             => i_dataReq,
      o_audioSampleFiltered => o_audioSampleFiltered
      );

  -----------------------------------------------------------------------
  -- Creates a clock that will shut off at the end of the simulation
  -----------------------------------------------------------------------
  i_clk_50 <= NOT i_clk_50 AFTER PERIOD/2 WHEN (NOT sim_done) ELSE '0';

  ---------------------------------------------------------------------------
  -- Generate the stimulus to the unit under test
  ---------------------------------------------------------------------------
  stimulus : process is 
  file read_file : text open read_mode is "one_cycle_200_8k.csv";
  file results_file : text open write_mode is "output_waveform.csv";
  variable lineIn : line;
  variable lineOut : line;
  variable readValue : integer;
  variable writeValue : integer;
  
begin
  wait for 100 ns;
  i_reset <= '1';
  -- Read data from file into an array
  for i in 0 to 39 loop
    readline(read_file, lineIn);
    read(lineIn, readValue);
    audioSampleArray(i) <= to_signed(readValue, 16);
    wait for 50 ns;
  end loop;
  file_close(read_file);
  
  -- Apply the test data and put the result into an output file
  for i in 1 to 100 loop
    for j in 0 to 39 loop
      WAIT UNTIL rising_edge (i_clk_50);
      -- Your code here...
      i_audioSample <= (audioSampleArray(j) & audioSampleArray(j)); --32 bits
	  
      -- Write filter output to file
      writeValue := to_integer(o_audioSampleFiltered);
      write(lineOut, writeValue);
      writeline(results_file, lineOut);
      
      -- Your code here...
      i_dataReq <= '1';
      WAIT UNTIL rising_edge (i_clk_50);
      i_dataReq <= '0';
      
    end loop;
  end loop;

  file_close(results_file);

  -- end simulation
  sim_done <= true;
  wait for 100 ns;

  -- last wait statement needs to be here to prevent the process
  -- sequence from re starting at the beginning
  wait;

end process stimulus;

  
END;


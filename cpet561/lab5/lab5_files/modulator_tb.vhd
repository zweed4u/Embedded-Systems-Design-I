LIBRARY ieee;
 USE ieee.std_logic_1164.ALL;
 USE ieee.numeric_std.ALL; 

-- Writen by Gregg Guarino Ph.D.
-- Modulator 

entity modulator_tb is
end entity modulator_tb;

architecture test of modulator_tb is

  component modulator is
    port (
      i_clock                  : in  std_logic;
      i_reset                  : in  std_logic;
      i_signalA                : in  std_logic_vector(15 downto 0);
      i_signalB                : in  std_logic_vector(15 downto 0);
      i_signalC                : in  std_logic_vector(15 downto 0);
      i_select                 : in  std_logic;
      o_dataOut               : out std_logic_vector(31 downto 0)
    );
  end component;

  signal clock                  : std_logic := '0';
  signal reset_n                : std_logic := '0';
  signal sim_done               : boolean := false;
  signal PERIOD_c               : time := 20 ns;   -- 50 Hz
  signal dataOut                : std_logic_vector(31 downto 0);
  signal inSelect               : std_logic := '0';
  type sineWave_type is array (0 to 19) of std_logic_vector(15 downto 0);
  constant sineWaveA : sineWave_type := (x"0000", x"278D", x"4B3B", x"678D", x"79BB", x"7FFF", x"79BB", x"678D", x"4B3B", x"278D",
                                         x"0000", x"D873", x"B4C4", x"9873", x"8644", x"8000", x"8644", x"9873", x"B4C4", x"D873");
  constant sineWaveB : sineWave_type := (x"0001", x"0001", x"0001", x"0001", x"0001", x"0001", x"0001", x"0001", x"0001", x"0001",
                                         x"0001", x"0001", x"0001", x"0001", x"0001", x"0001", x"0001", x"0001", x"0001", x"0001");
  constant sineWaveC : sineWave_type := (x"8000", x"8644", x"9873", x"B4C4", x"D873", x"0000", x"278D", x"4B3B", x"678D", x"79BB",
                                         x"7FFF", x"79BB", x"678D", x"4B3B", x"278D", x"0000", x"D873", x"B4C4", x"9873", x"8644");
  signal signalA                : std_logic_vector(15 downto 0);
  signal signalB                : std_logic_vector(15 downto 0);
  signal signalC                : std_logic_vector(15 downto 0);

begin

  clock <= NOT clock after PERIOD_C/2 when (NOT sim_done) else '0';

  uut : modulator port map(
    i_clock        => clock,
    i_reset        => reset_n,
    i_signalA      => signalA,
    i_signalB      => signalB,
    i_signalC      => signalC,
    i_select       => inSelect,
    o_dataOut     => dataOut
  );

  stimulus : process is 
    type write_file_type is file of string;
    file write_file : write_file_type open write_mode is "modulator_out.csv";
    variable write_value : integer;
  begin
    -- assert reset for 50 n
    reset_n <= '0';
    wait for 50 ns;

    -- release reset 5 nanosecends after next edge
    wait until rising_edge (clock);
    reset_n              <= '1';
    wait until rising_edge (clock);

    ----------------------
    -- apply test vectors
    ----------------------
    signalA <= sineWaveA(0);
    signalB <= sineWaveB(0);
    signalC <= sineWaveC(0);
    wait until rising_edge (clock);
    for i in 0 to 19 loop
      signalA <= sineWaveA(i);
      signalB <= sineWaveB(i);
      signalC <= sineWaveC(i);
      wait for 2 ns;
      wait until rising_edge (clock);
      wait for 2 ns;
      write_value := to_integer(signed(dataOut));
      write(write_file, integer'image(write_value) & ",");
    end loop;
    
    -- close file
    file_close(write_file);
    
    -- end simulation
    sim_done <= true;
    wait for 100 ns;

    -- last wait statement needs to be here to prevent the process
    -- sequence from re starting at the beginning
    wait;

  end process stimulus;

end architecture test;

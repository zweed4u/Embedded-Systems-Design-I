-- Example test bench
-- Written by Gregg Guarino
-- March 16, 2015
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY raminfr_be_tb IS
END;

ARCHITECTURE TEST_BENCH OF raminfr_be_tb IS

  -- component ports
  SIGNAL clock   : std_logic                   := '0';
  SIGNAL reset_n : std_logic                   := '0';
  SIGNAL we_n : std_logic                      := '1';
  SIGNAL be_n : std_logic_vector (3 DOWNTO 0)  := (OTHERS => '1');
  SIGNAL addr : std_logic_vector (11 DOWNTO 0) := (OTHERS => '0');
  SIGNAL din  : std_logic_vector (31 DOWNTO 0) := (OTHERS => '0');
  --
  SIGNAL dout : std_logic_vector (31 DOWNTO 0);


  -- signals for test bench control
  SIGNAL sim_done : boolean := false;
  SIGNAL PERIOD   : time    := 37 ns;   -- 27MHz

  -- TEST DATA
  CONSTANT RAM_SIZE_IN_WORDS : integer := 4095;
  CONSTANT BITS_PER_ADDRESS  : integer := 12;
  CONSTANT TEST_DATA      : std_logic_vector (31 DOWNTO 0) := x"AAAAAAAA";

  COMPONENT raminfr_be IS
    PORT(
      clock    : IN  std_logic;
      reset_n  : IN  std_logic;
      we_n     : IN  std_logic;
      be_n     : IN  std_logic_vector (3 DOWNTO 0);
      addr     : IN  std_logic_vector(11 DOWNTO 0);
      din      : IN  std_logic_vector(31 DOWNTO 0);
      --
      dout     : OUT std_logic_vector(31 DOWNTO 0)
    );
  END COMPONENT;
  
BEGIN

  -----------------------------------------------------------------------
  -- Instantiate the unit under test
  -----------------------------------------------------------------------
  -- Port Mapping the ramninfr_be
  UUT : raminfr_be
    PORT MAP (
      clock   => clock,
      reset_n => reset_n,
      we_n    => we_n,
      be_n    => be_n,
      addr    => addr,
      din     => din,
      dout    => dout
      );

  -----------------------------------------------------------------------
  -- Creates a clock that will shut off at the end of the simulation
  -----------------------------------------------------------------------
  clock <= NOT clock AFTER PERIOD/2 WHEN (NOT sim_done) ELSE '0';

  ---------------------------------------------------------------------------
  -- Generate the stimulus to the unit under test
  ---------------------------------------------------------------------------
  stimulus : PROCESS IS
  BEGIN
    -- initialize the signals
    reset_n <= '1';
    we_n <= '1';
    be_n <= (OTHERS => '1');
    addr <= (OTHERS => '0');
    din  <= (OTHERS => '0');
    WAIT FOR 3 ns;

    -- Write data to the RAM
    be_n <= "0000";
    we_n <= '0';
    din  <= TEST_DATA;
    FOR i IN 0 TO RAM_SIZE_IN_WORDS LOOP
      WAIT UNTIL rising_edge (clock);
      WAIT FOR 3 ns;
      addr <= conv_std_logic_vector(i, BITS_PER_ADDRESS);
    END LOOP;

    we_n <= '1';
    be_n <= (OTHERS => '1');
    addr <= (OTHERS => '0');
    din  <= (OTHERS => '0');
    WAIT FOR 3 ns;

    -- read back verify
    FOR i IN 0 TO RAM_SIZE_IN_WORDS LOOP
      WAIT UNTIL rising_edge (clock);
      WAIT FOR 3 ns;
      addr <= conv_std_logic_vector(i, BITS_PER_ADDRESS);
      ASSERT (TEST_DATA = dout) 
        REPORT "ERROR: Read back failure on word test" severity error;
    END LOOP;

    -- End the simulation by shutting down the clock
    WAIT FOR PERIOD;
    sim_done <= true;
    REPORT "Simulation over" severity note;

    -----------------------------------------------------------------------
    -- This Last WAIT statement needs to be here to prevent the PROCESS
    -- sequence from re starting.
    -----------------------------------------------------------------------
    WAIT;

  END PROCESS stimulus;
  
END;


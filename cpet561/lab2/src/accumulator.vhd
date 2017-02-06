-------------------------------------------------------------------------
-- Author: Gregg Guarino Ph.D.
-- January, 2017
-------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

ENTITY accumulator is
  port (
    ----- Audio -----
    AUD_ADCDAT : in std_logic; 
    AUD_ADCLRCK : inout std_logic;
    AUD_BCLK : inout std_logic;
    AUD_DACDAT : out std_logic;
    AUD_DACLRCK : inout std_logic;
    AUD_XCK : out std_logic;

    ----- CLOCK -----
    CLOCK_50 : in std_logic;
    CLOCK2_50 : in std_logic;
    CLOCK3_50 : in std_logic;
    CLOCK4_50 : in std_logic;

    ----- SDRAM -----
    DRAM_ADDR : out std_logic_vector(12 downto 0);
    DRAM_BA : out std_logic_vector(1 downto 0);
    DRAM_CAS_N : out std_logic;
    DRAM_CKE : out std_logic;
    DRAM_CLK : out std_logic;
    DRAM_CS_N : out std_logic;
    DRAM_DQ : inout std_logic_vector(15 downto 0);
    DRAM_LDQM : out std_logic;
    DRAM_RAS_N : out std_logic;
    DRAM_UDQM : out std_logic;
    DRAM_WE_N : out std_logic;

    ----- I2C for Audio and Video-In -----
    FPGA_I2C_SCLK : out std_logic;
    FPGA_I2C_SDAT : inout std_logic;

    ----- SEG7 -----
    HEX0 : out std_logic_vector(6 downto 0);
    HEX1 : out std_logic_vector(6 downto 0);
    HEX2 : out std_logic_vector(6 downto 0);
    HEX3 : out std_logic_vector(6 downto 0);
    HEX4 : out std_logic_vector(6 downto 0);
    HEX5 : out std_logic_vector(6 downto 0);

    ----- KEY -----
    KEY : in std_logic_vector(3 downto 0);

    ----- LED -----
    LEDR : out  std_logic_vector(9 downto 0);

    ----- SW -----
    SW : in  std_logic_vector(9 downto 0);

    ----- GPIO_0, GPIO_0 connect to GPIO Default -----
    GPIO_0 : inout  std_logic_vector(35 downto 0);

    ----- GPIO_1, GPIO_1 connect to GPIO Default -----
    GPIO_1 : inout  std_logic_vector(35 downto 0)
  );
end entity accumulator;

architecture accumulator_arch of accumulator is
  -- signal declarations
  signal led0 : std_logic;
  signal cntr : std_logic_vector(25 downto 0);
  signal ledNios : std_logic_vector(4 downto 0);
  signal reset_n : std_logic;
  signal accumPulse : std_logic;
  signal accum_sig : std_logic_vector(15 downto 0);
  signal SWsync : std_logic_vector(9 downto 0);
  signal KEYsync : std_logic_vector(3 downto 0);
  
  -- component declarations
  component synchronizer is
    port (
      i_SW : in std_logic_vector(9 downto 0);
      i_KEY : in std_logic_vector(3 downto 0);
      i_CLOCK2_50 : in std_logic;
      o_SWsync : out std_logic_vector(9 downto 0);
      o_KEYsync : out std_logic_vector(3 downto 0)
    );
  end component synchronizer;
  
  component debounce is
    port (
      i_pushButton : in std_logic;
      i_reset_n : in std_logic;
      i_clk : in std_logic;
      o_keyPulse : out std_logic
    );
  end component debounce;
  
  component accum_mod is
    port (
      i_switch : in std_logic_vector(7 downto 0);
      i_trigger : in std_logic;
      i_reset_n : in std_logic;
      i_clk : in std_logic;
      o_accumulator : out std_logic_vector(15 downto 0)
    );
  end component accum_mod;
  
  component hexDisplayDriver is
    port (
      i_hex : in std_logic_vector(3 downto 0);
      o_sevenSeg : out std_logic_vector(6 downto 0)
    );
  end component hexDisplayDriver;
  
  component nios_system is
    port (
        clk_clk              : in  std_logic                     := 'X';             -- clk
        reset_reset_n        : in  std_logic                     := 'X';             -- reset_n
        i_switch_export      : in  std_logic_vector(7 downto 0)  := (others => 'X'); -- export
        i_trigger_export     : in  std_logic                     := 'X';             -- export
        o_accumulator_export : out std_logic_vector(15 downto 0)                     -- export
    );
    end component nios_system;
  
begin

  ----- Control the 10 LEDs
  LEDR(9 downto 5) <= ledNios;
  LEDR(4 downto 0) <= "1111" & led0;
  led0 <= cntr(25);
  ledNios <= "10101";
  
  ----- Syncronize the user inputs i.e. slide switches(SW) and pushbuttons(KEYS) 
  synchronizer_inst : synchronizer
    port map (
      i_SW        => SW,
      i_KEY       => KEY,
      i_CLOCK2_50 => CLOCK2_50,
      o_SWsync    => SWsync,
      o_KEYsync   => KEYsync
    );
    
  ----- Pushbutton KEY0 is the reset
  reset_n <= KEYsync(0);
  
  ----- Debounce the pushbutton which will add the switches input to the accumulator
  debounce_inst1 : debounce
    port map (
      i_pushButton => KEYsync(1),
      i_reset_n    => reset_n,
      i_clk        => CLOCK2_50,
      o_keyPulse   => accumPulse
    );

  ----- The accumulator module
--  accum_mod_inst : accum_mod
--    port map (
--      i_switch      => SWsync(7 downto 0),
--      i_trigger     => accumPulse,
--      i_reset_n     => reset_n,
--      i_clk         => CLOCK2_50,
--      o_accumulator => accum_sig
--    );
    
  ----- Hex display drivers
  hexDisplayDriver_inst0 : hexDisplayDriver
    port map (
      i_hex      => accum_sig(3 downto 0),
      o_sevenSeg => HEX0
    );

  hexDisplayDriver_inst1 : hexDisplayDriver
    port map (
      i_hex      => accum_sig(7 downto 4),
      o_sevenSeg => HEX1
    );

  hexDisplayDriver_inst2 : hexDisplayDriver
    port map (
      i_hex      => accum_sig(11 downto 8),
      o_sevenSeg => HEX2
    );

  hexDisplayDriver_inst3 : hexDisplayDriver
    port map (
      i_hex      => accum_sig(15 downto 12),
      o_sevenSeg => HEX3
    );
    
    ----- Instantiate the nios processor
    accum_mod_inst : component nios_system
    port map (
        clk_clk              => CLOCK2_50,              --           clk.clk
        reset_reset_n        => reset_n,        --         reset.reset_n
        i_switch_export      => SWsync(7 downto 0),      --      i_switch.export
        i_trigger_export     => accumPulse,     --     i_trigger.export
        o_accumulator_export => accum_sig  -- o_accumulator.export
    );

  ----- Increment counter
  counter_proc : process (CLOCK2_50) begin
    if (rising_edge(CLOCK2_50)) then
      if (reset_n = '0') then
        cntr <= "00" & x"000000";
      else
        cntr <= cntr + ("00" & x"000001");
      end if;
    end if;
  end process counter_proc;
    
end architecture accumulator_arch;
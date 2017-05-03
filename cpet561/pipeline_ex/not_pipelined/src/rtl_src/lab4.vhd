-------------------------------------------------------------------------
-- Author: Gregg Guarino Ph.D.
-- January, 2017
-------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_textio.all;
use std.textio.all;

ENTITY lab4 is
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
end entity lab4;

architecture lab4_arch of lab4 is
  -- signal declarations
  signal cntr : std_logic_vector(25 downto 0);
  signal reset_n : std_logic;
  signal key1Pulse : std_logic;
  signal accum_sig : std_logic_vector(15 downto 0);
  signal SWsync : std_logic_vector(9 downto 0);
  signal KEYsync : std_logic_vector(3 downto 0);
  signal address     : std_logic_vector (10 downto 0);
  signal bus_enable  : std_logic;
  signal byte_enable : std_logic_vector (3 downto 0);
  signal rw_n        : std_logic;
  signal write_data  : std_logic_vector (31 downto 0);
  signal acknowledge : std_logic;
  signal read_data   : std_logic_vector (31 downto 0);
  signal wave_data   : std_logic_vector (31 downto 0);
  signal wave_data_cos   : std_logic_vector (31 downto 0);
  signal wave_data_cos_d1   : std_logic_vector (31 downto 0);
  signal wave_data_codec   : std_logic_vector (31 downto 0);
  signal AUD_BCLK_d1 : std_logic;
  signal AUD_BCLK_d2 : std_logic;
  signal AUD_BCLK_d3 : std_logic;
  signal AUD_BCLK_d4 : std_logic;
  signal AUD_DACLRCK_d1 : std_logic;
  signal AUD_DACLRCK_d2 : std_logic;
  signal AUD_DACLRCK_d3 : std_logic;
  signal AUD_DACLRCK_d4 : std_logic;
  signal AUD_ADCLRCK_d1 : std_logic;
  signal AUD_ADCLRCK_d2 : std_logic;
  signal AUD_ADCLRCK_d3 : std_logic;
  signal AUD_ADCLRCK_d4 : std_logic;
  signal audioSampleAddr : std_logic_vector(7 downto 0);
  signal addrIncrement : std_logic_vector(7 downto 0);
  signal daclrckFallingEdge : std_logic;
  signal daclrckRisingEdge : std_logic;
  signal adclrckFallingEdge : std_logic;
  signal adclrckRisingEdge : std_logic;
  signal bclkRisingEdge : std_logic;
  signal dataReq : std_logic;
  --pipeline signals
  signal plSignalMuxOut : signed(31 DOWNTO 0);
  signal pl_wave_data_cos : std_logic_vector(31 downto 0);
		
  component codec_dac_interface is
    port (
      i_clk_50             : in std_logic;
      i_audioSample        : in std_logic_vector(31 downto 0); 
      i_daclrckFallingEdge : in std_logic;
      i_daclrckRisingEdge  : in std_logic;
      i_bclkRisingEdge     : in std_logic;
      o_dataReq            : out std_logic; 
      o_AUD_DACDAT         : out std_logic
    );
  end component codec_dac_interface;

  component peripheral_on_external_bus is
    port (
      clk           : in  std_logic;
      reset_n       : in  std_logic;
      i_address     : in  std_logic_vector (10 downto 0);
      i_addressWave : in  std_logic_vector (7 downto 0);
      i_bus_enable  : in  std_logic;
      i_byte_enable : in  std_logic_vector (3 downto 0);
      i_rw_n        : in  std_logic;
      i_write_data  : in  std_logic_vector (31 downto 0);
      o_acknowledge : out std_logic;
      o_read_data   : out std_logic_vector (31 downto 0);
      o_wave_data   : out std_logic_vector (31 downto 0)
    );
  end component peripheral_on_external_bus;

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
  
	component nios_sytem is
		port (
			clk_clk                   : in  std_logic                     := 'X';             -- clk
			reset_reset_n             : in  std_logic                     := 'X';             -- reset_n
			eight_bit_input_export    : in  std_logic_vector(7 downto 0)  := (others => 'X'); -- export
			sixteen_bit_output_export : out std_logic_vector(15 downto 0);                    -- export
			bus_bridge_acknowledge    : in  std_logic                     := 'X';             -- acknowledge
			bus_bridge_irq            : in  std_logic                     := 'X';             -- irq
			bus_bridge_address        : out std_logic_vector(10 downto 0);                    -- address
			bus_bridge_bus_enable     : out std_logic;                                        -- bus_enable
			bus_bridge_byte_enable    : out std_logic_vector(3 downto 0);                     -- byte_enable
			bus_bridge_rw             : out std_logic;                                        -- rw
			bus_bridge_write_data     : out std_logic_vector(31 downto 0);                    -- write_data
			bus_bridge_read_data      : in  std_logic_vector(31 downto 0) := (others => 'X');  -- read_data
			iicdatabit_export         : inout std_logic                     := 'X';             -- export
			iicclockbit_export        : out   std_logic                                         -- export
		);
	end component nios_sytem;

  component hexDisplayDriver is
    port (
      i_hex : in std_logic_vector(3 downto 0);
      o_sevenSeg : out std_logic_vector(6 downto 0)
    );
  end component hexDisplayDriver;
  
  component wave_ram_cos is
    port (
      address		: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
      clock		: IN STD_LOGIC  := '1';
      q		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
    );
  end component wave_ram_cos;
  
begin

  -- ***************************************************
  -- Code from first 3 labs.
  -- ***************************************************
  ----- Control the 10 LEDs
  LEDR(0) <= cntr(25);
  
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
      o_keyPulse   => key1Pulse
    );

	u0 : component nios_sytem
		port map (
			clk_clk                   => CLOCK2_50,                   --                clk.clk
			reset_reset_n             => reset_n,             --              reset.reset_n
			eight_bit_input_export    => SWsync(7 downto 0),    --    eight_bit_input.export
			sixteen_bit_output_export => accum_sig, -- sixteen_bit_output.export
			bus_bridge_acknowledge    => acknowledge,    --         bus_bridge.acknowledge
			bus_bridge_irq            => '0',            --                   .irq
			bus_bridge_address        => address,        --                   .address
			bus_bridge_bus_enable     => bus_enable,     --                   .bus_enable
			bus_bridge_byte_enable    => byte_enable,    --                   .byte_enable
			bus_bridge_rw             => rw_n,             --                   .rw
			bus_bridge_write_data     => write_data,     --                   .write_data
			bus_bridge_read_data      => read_data,       --                   .read_data
			iicdatabit_export         => FPGA_I2C_SDAT,         --         iicdatabit.export
			iicclockbit_export        => FPGA_I2C_SCLK         --        iicclockbit.export
		);

  peripheral_on_external_bus_inst : peripheral_on_external_bus
    port map (
      clk           => CLOCK2_50,
      reset_n       => reset_n,
      i_address     => address,
      i_addressWave => audioSampleAddr,
      i_bus_enable  => bus_enable,  
      i_byte_enable => byte_enable,
      i_rw_n        => rw_n,
      i_write_data  => write_data,
      o_acknowledge => acknowledge,
      o_read_data   => read_data,
      o_wave_data   => wave_data
    );
    
  wave_ram_cos_inst : wave_ram_cos
    port map (
      address	 => "00" & audioSampleAddr,
      clock	 => CLOCK2_50,
      q	 => wave_data_cos
    );
   
  
  
	
	
	modulate : process (CLOCK2_50) is
	   variable dataOutSigned     : signed(31 DOWNTO 0); --local to process
      variable signalMuxOut : signed(31 DOWNTO 0);
	begin 
	if (rising_edge(CLOCK2_50)) then
      if (reset_n = '0') then
        wave_data_codec   <= (others => '0');
      else
        if (KEYsync(2) = '0') then
          signalMuxOut := signed(wave_data); --:= used for variables SEQUENTIAL - NOT CONCURRENT - HAPPENS IN SINGLE CLOCK  - change vars to signals and move out of process and defines to be CONCURRENT function as latch - pipeline
        elsif (rising_edge(CLOCK2_50)) then
		    pl_wave_data_cos<=wave_data_cos;
			 plSignalMuxOut<=signalMuxOut;
		  else  -- still need synchromize c flipflop
          signalMuxOut := x"40004000";
        end if;
		  dataOutSigned := signed(plSignalMuxOut(15 downto 0)) * signed(pl_wave_data_cos(15 downto 0));
        dataOutSigned(15 downto 0) := dataOutSigned(31 downto 16);
        wave_data_codec <= std_logic_vector(dataOutSigned);	
	   end if;
    end if;
  end process;

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
  
  -- ***************************************************
  -- New code for audio codec.
  -- ***************************************************
  AUD_XCK <= cntr(1);

  -- Synchronize the inputs from the codec to the fast 50MHz clock
  syncAudioProc : process (CLOCK2_50) begin
    if (rising_edge(CLOCK2_50)) then
      AUD_BCLK_d1 <= AUD_BCLK;
      AUD_BCLK_d2 <= AUD_BCLK_d1;
      AUD_BCLK_d3 <= AUD_BCLK_d2;
      AUD_BCLK_d4 <= AUD_BCLK_d3;
      AUD_DACLRCK_d1 <= AUD_DACLRCK;
      AUD_DACLRCK_d2 <= AUD_DACLRCK_d1;
      AUD_DACLRCK_d3 <= AUD_DACLRCK_d2;
      AUD_DACLRCK_d4 <= AUD_DACLRCK_d3;
      AUD_ADCLRCK_d1 <= AUD_ADCLRCK;
      AUD_ADCLRCK_d2 <= AUD_ADCLRCK_d1;
      AUD_ADCLRCK_d3 <= AUD_ADCLRCK_d2;
      AUD_ADCLRCK_d4 <= AUD_ADCLRCK_d3;
    end if;
  end process;
  
  -- When the button is pressed, increase the ammount of the waveform
  -- increment per sample period. This will change the frequency of the
  -- tone.
  waveformIncrementProc : process (CLOCK2_50) begin
    if (rising_edge(CLOCK2_50)) then
      if (reset_n = '0') then
        addrIncrement <= x"00";
      elsif (key1Pulse = '1') then
        addrIncrement <= addrIncrement + x"01";
      end if;
    end if;
  end process;
  
  -- Edge detect inputs from the codec
  edgeDetDacProc : process (CLOCK2_50) begin
    if (rising_edge(CLOCK2_50)) then
      if ((AUD_DACLRCK_d3 = '0') and (AUD_DACLRCK_d4 = '1')) then
        -- Falling edge, left channel
        daclrckFallingEdge <= '1';
      elsif ((AUD_DACLRCK_d3 = '1') and (AUD_DACLRCK_d4 = '0')) then
        -- Rising edge, right channel
        daclrckRisingEdge <= '1';
      else
        daclrckFallingEdge <= '0';
        daclrckRisingEdge <= '0';
      end if;
    end if;
  end process;
  
  edgeDetClkProc : process (CLOCK2_50) begin
    if (rising_edge(CLOCK2_50)) then
      if ((AUD_BCLK_d3 = '1') and (AUD_BCLK_d4 = '0')) then
        -- Rising edge of audio bit clock
        bclkRisingEdge <= '1';
      else
        bclkRisingEdge <= '0';
      end if;
    end if;
  end process;
  
  edgeDetAdcProc : process (CLOCK2_50) begin
    if (rising_edge(CLOCK2_50)) then
      if ((AUD_ADCLRCK_d3 = '0') and (AUD_ADCLRCK_d4 = '1')) then
        -- Falling edge, left channel
        adclrckFallingEdge <= '1';
      elsif ((AUD_ADCLRCK_d3 = '1') and (AUD_ADCLRCK_d4 = '0')) then
        -- Rising edge, right channel
        adclrckRisingEdge <= '1';
      else
        adclrckFallingEdge <= '0';
        adclrckRisingEdge <= '0';
      end if;
    end if;
  end process;

  -- Every sample move into the waveform by "addrIncrement"
  waveformAdvanceProc : process (CLOCK2_50) begin
    if (rising_edge(CLOCK2_50)) then
      if (reset_n = '0') then
        audioSampleAddr <= x"00";
      elsif (dataReq = '1') then
        audioSampleAddr <= audioSampleAddr + addrIncrement;
      end if;
    end if;
  end process;
  
  codec_dac_inst : codec_dac_interface
    port map (
      i_clk_50 => CLOCK2_50,
      i_audioSample => wave_data_codec,
      i_daclrckFallingEdge => daclrckFallingEdge,
      i_daclrckRisingEdge => daclrckRisingEdge,
      i_bclkRisingEdge => bclkRisingEdge,
      o_dataReq => dataReq,
      o_AUD_DACDAT => AUD_DACDAT
    );

end architecture lab4_arch;
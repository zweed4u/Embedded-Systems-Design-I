-- Written by Gregg Guarino, Ph.D.

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity peripheral_on_external_bus is
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
end entity peripheral_on_external_bus;

architecture peripheral_on_external_bus_arch of peripheral_on_external_bus is
  -- signal and component declarations
  signal wren_sig : std_logic;
  signal address_sig : std_logic_vector(9 DOWNTO 0);
  signal bus_enable_d1 : std_logic;
  signal bus_enable_d2 : std_logic;
  
  component wave_ram is
    PORT
    (
        address_a : IN STD_LOGIC_VECTOR (9 DOWNTO 0);
        address_b : IN STD_LOGIC_VECTOR (9 DOWNTO 0);  
        clock     : IN STD_LOGIC  := '1';
        data_a    : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        data_b    : IN STD_LOGIC_VECTOR (31 DOWNTO 0); 
        wren_a    : IN STD_LOGIC  := '0';
        wren_b    : IN STD_LOGIC  := '0';             
        q_a       : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
        q_b       : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
    );
  end component wave_ram;

begin

  address_a_sig <= '0' & i_address(10 DOWNTO 2);
  address_b_sig <= "00" & i_addressWave
  wren_sig <= (NOT i_rw_n) AND i_bus_enable;
  process (clk) begin
    if (rising_edge(clk)) then
      if (reset_n = '0') then
        o_acknowledge <= '0';
      else
		    bus_enable_d1 <= i_bus_enable;
		    bus_enable_d2 <= bus_enable_d1;
        o_acknowledge <= bus_enable_d1 AND (NOT bus_enable_d2)
		  end if;
    end if;
  end process;
  
  wave_ram_inst : wave_ram 
  PORT MAP (
        address_a => address_a_sig,
        address_b => address_b_sig, --
        clock     => clk,
        data_a    => i_write_data, --
        data_b    => x"00000000", --
        wren_a    => wren_sig,
        wren_b    => wren_sig, --
        q_a       => o_read_data, --
        q_b       => o_wave_data
    );
end peripheral_on_external_bus_arch;
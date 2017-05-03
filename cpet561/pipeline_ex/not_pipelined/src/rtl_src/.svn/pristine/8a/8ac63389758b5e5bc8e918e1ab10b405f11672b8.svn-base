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

  signal wren : std_logic;
  signal address : std_logic_vector(9 downto 0);
  signal bus_enable_d1 : std_logic;
  signal bus_enable_d2 : std_logic;
  signal acknowledge : std_logic;
  signal addressWave : std_logic_vector(9 downto 0);

  component wave_ram IS
    port (
      address_a		: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
      address_b		: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
      clock		: IN STD_LOGIC  := '1';
      data_a		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      data_b		: IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      wren_a		: IN STD_LOGIC  := '0';
      wren_b		: IN STD_LOGIC  := '0';
      q_a		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
      q_b		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
    );
  end component wave_ram;

begin

  wren <= (not i_rw_n) and i_bus_enable;
  o_acknowledge <= acknowledge;
  address <= '0' & i_address(10 downto 2);
  addressWave <= "00" & i_addressWave(7 downto 0);
  
  ack_process : process(clk) begin
    if (rising_edge(clk)) then
      bus_enable_d1 <= i_bus_enable;
      bus_enable_d2 <= bus_enable_d1;
      if ((bus_enable_d1 = '1') and (bus_enable_d2 = '0')) then
        acknowledge <= '1';
      else
        acknowledge <= '0';
      end if;
    end if;
  end process;

  wave_ram_inst : wave_ram
    port map (
      address_a   => address,
      address_b   => addressWave,
      clock       => clk,
      data_a      => i_write_data,
      data_b      => x"00000000",
      wren_a      => wren,
      wren_b      => '0',
      q_a         => o_read_data,
      q_b         => o_wave_data
    );

end peripheral_on_external_bus_arch;
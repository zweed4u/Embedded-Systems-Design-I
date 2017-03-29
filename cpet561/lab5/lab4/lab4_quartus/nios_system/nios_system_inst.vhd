	component nios_system is
		port (
			bus_bridge_acknowledge : in    std_logic                     := 'X';             -- acknowledge
			bus_bridge_irq         : in    std_logic                     := 'X';             -- irq
			bus_bridge_address     : out   std_logic_vector(10 downto 0);                    -- address
			bus_bridge_bus_enable  : out   std_logic;                                        -- bus_enable
			bus_bridge_byte_enable : out   std_logic_vector(3 downto 0);                     -- byte_enable
			bus_bridge_rw          : out   std_logic;                                        -- rw
			bus_bridge_write_data  : out   std_logic_vector(31 downto 0);                    -- write_data
			bus_bridge_read_data   : in    std_logic_vector(31 downto 0) := (others => 'X'); -- read_data
			clk_clk                : in    std_logic                     := 'X';             -- clk
			iicclockbit_export     : out   std_logic;                                        -- export
			iicdatabit_export      : inout std_logic                     := 'X';             -- export
			reset_reset_n          : in    std_logic                     := 'X'              -- reset_n
		);
	end component nios_system;

	u0 : component nios_system
		port map (
			bus_bridge_acknowledge => CONNECTED_TO_bus_bridge_acknowledge, --  bus_bridge.acknowledge
			bus_bridge_irq         => CONNECTED_TO_bus_bridge_irq,         --            .irq
			bus_bridge_address     => CONNECTED_TO_bus_bridge_address,     --            .address
			bus_bridge_bus_enable  => CONNECTED_TO_bus_bridge_bus_enable,  --            .bus_enable
			bus_bridge_byte_enable => CONNECTED_TO_bus_bridge_byte_enable, --            .byte_enable
			bus_bridge_rw          => CONNECTED_TO_bus_bridge_rw,          --            .rw
			bus_bridge_write_data  => CONNECTED_TO_bus_bridge_write_data,  --            .write_data
			bus_bridge_read_data   => CONNECTED_TO_bus_bridge_read_data,   --            .read_data
			clk_clk                => CONNECTED_TO_clk_clk,                --         clk.clk
			iicclockbit_export     => CONNECTED_TO_iicclockbit_export,     -- iicclockbit.export
			iicdatabit_export      => CONNECTED_TO_iicdatabit_export,      --  iicdatabit.export
			reset_reset_n          => CONNECTED_TO_reset_reset_n           --       reset.reset_n
		);


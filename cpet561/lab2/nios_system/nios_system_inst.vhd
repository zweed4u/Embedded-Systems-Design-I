	component nios_system is
		port (
			clk_clk              : in  std_logic                     := 'X';             -- clk
			i_switch_export      : in  std_logic_vector(7 downto 0)  := (others => 'X'); -- export
			i_trigger_export     : in  std_logic                     := 'X';             -- export
			o_accumulator_export : out std_logic_vector(15 downto 0);                    -- export
			reset_reset_n        : in  std_logic                     := 'X'              -- reset_n
		);
	end component nios_system;

	u0 : component nios_system
		port map (
			clk_clk              => CONNECTED_TO_clk_clk,              --           clk.clk
			i_switch_export      => CONNECTED_TO_i_switch_export,      --      i_switch.export
			i_trigger_export     => CONNECTED_TO_i_trigger_export,     --     i_trigger.export
			o_accumulator_export => CONNECTED_TO_o_accumulator_export, -- o_accumulator.export
			reset_reset_n        => CONNECTED_TO_reset_reset_n         --         reset.reset_n
		);


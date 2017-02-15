	component nios_system is
		port (
			clk_clk       : in  std_logic                    := 'X'; -- clk
			reset_reset_n : in  std_logic                    := 'X'; -- reset_n
			leds_export   : out std_logic_vector(7 downto 0);        -- export
			key1_export   : in  std_logic                    := 'X'  -- export
		);
	end component nios_system;

	u0 : component nios_system
		port map (
			clk_clk       => CONNECTED_TO_clk_clk,       --   clk.clk
			reset_reset_n => CONNECTED_TO_reset_reset_n, -- reset.reset_n
			leds_export   => CONNECTED_TO_leds_export,   --  leds.export
			key1_export   => CONNECTED_TO_key1_export    --  key1.export
		);


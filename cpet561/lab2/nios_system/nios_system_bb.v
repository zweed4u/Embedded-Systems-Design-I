
module nios_system (
	clk_clk,
	reset_reset_n,
	i_switch_export,
	i_trigger_export,
	o_accumulator_export);	

	input		clk_clk;
	input		reset_reset_n;
	input	[7:0]	i_switch_export;
	input		i_trigger_export;
	output	[15:0]	o_accumulator_export;
endmodule

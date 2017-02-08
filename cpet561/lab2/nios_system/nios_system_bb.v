
module nios_system (
	clk_clk,
	i_switch_export,
	i_trigger_export,
	o_accumulator_export,
	reset_reset_n);	

	input		clk_clk;
	input	[7:0]	i_switch_export;
	input		i_trigger_export;
	output	[15:0]	o_accumulator_export;
	input		reset_reset_n;
endmodule

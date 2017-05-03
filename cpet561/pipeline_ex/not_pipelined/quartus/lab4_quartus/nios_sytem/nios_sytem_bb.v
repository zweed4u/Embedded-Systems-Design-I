
module nios_sytem (
	bus_bridge_acknowledge,
	bus_bridge_irq,
	bus_bridge_address,
	bus_bridge_bus_enable,
	bus_bridge_byte_enable,
	bus_bridge_rw,
	bus_bridge_write_data,
	bus_bridge_read_data,
	clk_clk,
	eight_bit_input_export,
	reset_reset_n,
	sixteen_bit_output_export,
	iicdatabit_export,
	iicclockbit_export);	

	input		bus_bridge_acknowledge;
	input		bus_bridge_irq;
	output	[10:0]	bus_bridge_address;
	output		bus_bridge_bus_enable;
	output	[3:0]	bus_bridge_byte_enable;
	output		bus_bridge_rw;
	output	[31:0]	bus_bridge_write_data;
	input	[31:0]	bus_bridge_read_data;
	input		clk_clk;
	input	[7:0]	eight_bit_input_export;
	input		reset_reset_n;
	output	[15:0]	sixteen_bit_output_export;
	inout		iicdatabit_export;
	output		iicclockbit_export;
endmodule

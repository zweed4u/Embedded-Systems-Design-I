
module nios_system (
	clk_clk,
	reset_reset_n,
	bus_bridge_acknowledge,
	bus_bridge_irq,
	bus_bridge_address,
	bus_bridge_bus_enable,
	bus_bridge_byte_enable,
	bus_bridge_rw,
	bus_bridge_write_data,
	bus_bridge_read_data,
	iicdatabit_export,
	iicclockbit_export);	

	input		clk_clk;
	input		reset_reset_n;
	input		bus_bridge_acknowledge;
	input		bus_bridge_irq;
	output	[10:0]	bus_bridge_address;
	output		bus_bridge_bus_enable;
	output	[3:0]	bus_bridge_byte_enable;
	output		bus_bridge_rw;
	output	[31:0]	bus_bridge_write_data;
	input	[31:0]	bus_bridge_read_data;
	inout		iicdatabit_export;
	output		iicclockbit_export;
endmodule

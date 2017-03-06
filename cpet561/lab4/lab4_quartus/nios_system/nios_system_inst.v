	nios_system u0 (
		.clk_clk                (<connected-to-clk_clk>),                //         clk.clk
		.reset_reset_n          (<connected-to-reset_reset_n>),          //       reset.reset_n
		.bus_bridge_acknowledge (<connected-to-bus_bridge_acknowledge>), //  bus_bridge.acknowledge
		.bus_bridge_irq         (<connected-to-bus_bridge_irq>),         //            .irq
		.bus_bridge_address     (<connected-to-bus_bridge_address>),     //            .address
		.bus_bridge_bus_enable  (<connected-to-bus_bridge_bus_enable>),  //            .bus_enable
		.bus_bridge_byte_enable (<connected-to-bus_bridge_byte_enable>), //            .byte_enable
		.bus_bridge_rw          (<connected-to-bus_bridge_rw>),          //            .rw
		.bus_bridge_write_data  (<connected-to-bus_bridge_write_data>),  //            .write_data
		.bus_bridge_read_data   (<connected-to-bus_bridge_read_data>),   //            .read_data
		.iicdatabit_export      (<connected-to-iicdatabit_export>),      //  iicdatabit.export
		.iicclockbit_export     (<connected-to-iicclockbit_export>)      // iicclockbit.export
	);


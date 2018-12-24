/****************************************************************************
 * fwuart_tx_tb_hdl.sv
 ****************************************************************************/

/**
 * Module: fwuart_tx_tb_hdl
 * 
 * TODO: Add module documentation
 */
module fwuart_tx_tb_hdl(input clock);
	
	reg			reset = 1;
	reg[3:0]	reset_cnt = 0;
	always @(posedge clock) begin
		if (reset_cnt == 10) begin
			reset <= 0;
		end else begin
			reset_cnt <= reset_cnt + 1;
		end
	end
	
	wire[7:0]				data;
	wire					data_ready;
	wire					data_valid;
	wire					clock_x16;
	wire					tx;
	
	fwuart_tx u_tx (
		.clock       (clock      ), 
		.reset       (reset      ), 
		.data        (data       ), 
		.data_ready  (data_ready ), 
		.data_valid  (data_valid ), 
		.clock_x16   (clock_x16  ), 
		.tx          (tx         ));

	fwuart_clkgen #(
		.CLOCKRATE  (50000000 ), 
		.BAUDRATE   (115200  )
		) u_clkgen (
		.clock      (clock     ), 
		.clock_x16  (clock_x16 ));
	
endmodule



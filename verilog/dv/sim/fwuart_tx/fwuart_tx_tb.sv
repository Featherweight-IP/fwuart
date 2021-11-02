/****************************************************************************
 * fwuart_tx_tb.sv
 ****************************************************************************/
`ifdef NEED_TIMESCALE
	`timescale 1ns/1ns
`endif

`include "rv_macros.svh"
  
/**
 * Module: fwuart_tx_tb
 * 
 * TODO: Add module documentation
 */
module fwuart_tx_tb(input clock);
	
`ifdef HAVE_HDL_CLOCKGEN
	reg clock_r = 0;
	initial begin
		forever begin
`ifdef NEED_TIMESCALE
			#10;
`else
			#10ns;
`endif
			clock_r <= ~clock_r;
		end
	end
	assign clock = clock_r;
`endif
	
`ifdef IVERILOG
	`include "iverilog_control.svh"
`endif
	
	reg reset = 0;
	reg[4:0] reset_cnt = 0;
	
	always @(posedge clock) begin
		if (reset_cnt == 20) begin
			reset <= 1'b0;
		end else begin
			if (reset_cnt == 1) begin
				reset <= 1'b1;
			end
			reset_cnt <= reset_cnt + 1;
		end
	end

	`RV_WIRES(bfm2dut_, 8);
	
	rv_data_out_bfm #(
		.DATA_WIDTH  (8 )
		) u_rv_bfm (
		.clock       (clock      ), 
		.reset       (reset      ), 
		`RV_CONNECT( , bfm2dut_)
		);
	
	wire clock_x16;
	
	fwuart_clkgen #(
		.CLOCKRATE  (50000000  ), 
		.BAUDRATE   (460800    )
		) u_clkgen (
		.clock      (clock     ), 
		.reset		(reset     ),
		.clock_x16  (clock_x16 ));

	wire tx;
	
	fwuart_tx u_dut (
		.clock       (clock      ), 
		.reset       (reset      ), 
		`RV_CONNECT(t_, bfm2dut_),
		.clock_x16   (clock_x16  ), 
		.tx          (tx         ));

	wire rx = 1;
	uart_bfm u_uart_bfm (
		.clock  (clock ), 
		.reset  (reset ), 
		.rx     (tx    ), 
		.tx     (rx    ));

endmodule



/****************************************************************************
 * fwuart_tx_tb.sv
 ****************************************************************************/
`ifdef NEED_TIMESCALE
	`timescale 1ns/1ns
`endif

`include "rv_macros.svh"
  
/**
 * Module: fwuart_back2back_rv
 * 
 * Connects rx and tx back-to-back via their ready/valid interfaces
 */
module fwuart_back2back_rv(input clock);
	
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

	wire clock_x16;
	
	fwuart_clkgen #(
		.CLOCKRATE  (50000000  ), 
		.BAUDRATE   (460800    )
		) u_clkgen (
		.clock      (clock     ), 
		.reset		(reset     ),
		.clock_x16  (clock_x16 ));

	wire rx;
	
	`RV_WIRES(txbfm2dut_, 8);
	`RV_WIRES(dut2rxbfm_, 8);
	
	rv_data_out_bfm #(
		.DATA_WIDTH  (8 )
		) u_tx_bfm (
		.clock       (clock      ), 
		.reset       (reset      ), 
		`RV_CONNECT( , txbfm2dut_)
		);

	wire s_dat;
	fwuart_tx u_tx (
		.clock      (clock     ), 
		.reset      (reset     ), 
		`RV_CONNECT(t_, txbfm2dut_),
		.clock_x16  (clock_x16 ), 
		.tx         (s_dat     ));

	fwuart_rx u_rx (
		.clock       (clock      ), 
		.reset       (reset      ), 
		`RV_CONNECT(i_, dut2rxbfm_),
		.clock_x16   (clock_x16  ), 
		.rx          (s_dat      ));
	
	rv_data_in_bfm #(
		.DATA_WIDTH  (8 )
		) u_rx_bfm (
		.clock       (clock      ), 
		.reset       (reset      ), 
		`RV_CONNECT( , dut2rxbfm_));

endmodule



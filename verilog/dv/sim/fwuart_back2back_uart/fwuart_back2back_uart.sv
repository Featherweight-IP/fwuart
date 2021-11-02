/****************************************************************************
 * fwuart_tx_tb.sv
 ****************************************************************************/
`ifdef NEED_TIMESCALE
	`timescale 1ns/1ns
`endif

`include "rv_macros.svh"
  
/**
 * Module: fwuart_back2back_uart
 * 
 * TODO: Add module documentation
 */
module fwuart_back2back_uart(input clock);
	
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

	`RV_WIRES(tx2rx_, 8);
	
	wire clock_x16;
	
	fwuart_clkgen #(
		.CLOCKRATE  (50000000  ), 
		.BAUDRATE   (460800    )
		) u_clkgen (
		.clock      (clock     ), 
		.reset		(reset     ),
		.clock_x16  (clock_x16 ));

	wire rx, tx;
	fwuart_tx u_tx (
		.clock      (clock     ), 
		.reset      (reset     ), 
		`RV_CONNECT(t_, tx2rx_ ),
		.clock_x16  (clock_x16 ), 
		.tx         (tx        ));
	
	fwuart_rx u_rx (
		.clock       (clock      ), 
		.reset       (reset      ), 
		`RV_CONNECT(i_, tx2rx_   ),
		.clock_x16   (clock_x16  ), 
		.rx          (rx         ));
	
	uart_bfm u_uart_bfm (
		.clock  (clock ), 
		.reset  (reset ), 
		.rx     (tx    ), 
		.tx     (rx    ));
	
endmodule



/****************************************************************************
 * fwuart_fpga_back2back.v
 ****************************************************************************/
`include "rv_macros.svh"
  
/**
 * Module: fwuart_fpga_back2back
 * 
 * TODO: Add module documentation
 */
module fwuart_fpga_back2back(
		input			clock,
		input			rx,
		output			tx,
		output			led[7:0]);
	
	assign led[3] = 1'b1;
	assign led[2] = 1'b0;
	assign led[1] = 1'b1;
	assign led[0] = 1'b0;
	
	reg[31:0]       key = 32'h0;
	reg             reset = 0;
	reg[5:0]        reset_cnt = 0;
	
	always @(posedge clock) begin
		if (key != 32'h1234567) begin
			reset <= 0;
			reset_cnt <= 0;
			key <= 32'h1234567;
		end
		
		if (reset_cnt == 60) begin
			reset <= 0;
		end else begin
			if (reset_cnt == 4) begin
				reset <= 1;
			end
			reset_cnt <= reset_cnt + 1;
		end
	end

	wire clock_x16;
	fwuart_clkgen #(
		.CLOCKRATE  (50000000 ), 
		.BAUDRATE   (115200   )
		) u_clkgen (
		.clock      (clock     ), 
		.reset      (reset     ), 
		.clock_x16  (clock_x16 ));
	
	`RV_WIRES(rx2tx_, 8);
	
	assign led[4] = rx;
	assign led[5] = tx;
	assign led[6] = rx2tx_ready;
	assign led[7] = rx2tx_valid;

	fwuart_rx u_rx (
		.clock      (clock     ), 
		.reset      (reset     ), 
		`RV_CONNECT(i_, rx2tx_),
		.clock_x16  (clock_x16 ), 
		.rx         (rx        ));
	
	fwuart_tx u_tx (
		.clock      (clock     ), 
		.reset      (reset     ), 
		`RV_CONNECT(t_, rx2tx_),
		.clock_x16  (clock_x16 ), 
		.tx         (tx        ));


endmodule



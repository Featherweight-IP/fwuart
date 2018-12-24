/****************************************************************************
 * fwuart_clkgen.sv
 ****************************************************************************/

/**
 * Module: fwuart_clkgen
 * 
 * Baud-rate clock generator for the 
 */
module fwuart_clkgen #(parameter int CLOCKRATE, parameter int BAUDRATE)(
		input			clock,
		output			clock_x16);
	localparam DIVIDER_16x = (CLOCKRATE / (BAUDRATE * 16));
	reg[$clog2(DIVIDER_16x)-1:0] counter;
	
	assign clock_x16 = (counter == DIVIDER_16x);

	always @(posedge clock) begin
		if (clock_x16) begin
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end

endmodule



/****************************************************************************
 * fwuart_clkgen.sv
 ****************************************************************************/

/**
 * Module: fwuart_clkgen
 * 
 * Baud-rate clock generator for the 
 */
module fwuart_clkgen #(
			parameter CLOCKRATE=50, 
			parameter BAUDRATE=115200
		)(
			input			clock,
			input			reset,
			output			clock_x16);
	localparam DIVIDER_16x = (CLOCKRATE / (BAUDRATE * 16));
	reg[$clog2(DIVIDER_16x)-1:0] counter;
	
	initial begin
		$display("CLOCKRATE=%0d BAUDRATE=%0d", CLOCKRATE, BAUDRATE);
		$display("DIVIDER_16x=%0d", DIVIDER_16x);
	end
	
	assign clock_x16 = (counter == DIVIDER_16x);

	always @(posedge clock or posedge reset) begin
		if (reset) begin
			counter <= {$clog2(DIVIDER_16x){1'b0}};
		end else begin
			if (clock_x16) begin
				counter <= 0;
			end else begin
				counter <= counter + 1;
			end
		end
	end

endmodule



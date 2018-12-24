/****************************************************************************
 * fwuart_tx.sv
 ****************************************************************************/

/**
 * Module: fwuart_tx
 * 
 * TODO: Add module documentation
 */
module fwuart_tx (
		input			clock, // data-interface clock
		input			reset,
		input [7:0]		data,
		output			data_ready,
		input			data_valid,
		input			clock_x16,
		output reg		tx
		);
	reg[7:0]			data_r;
	reg[1:0]			state;
	reg[3:0]			tx_clk_count;
	wire				tx_clk_count16 = &tx_clk_count;
	reg[2:0]			bit_count;
	
	assign data_ready = (state == 0);

	always @(posedge clock) begin
		if (reset) begin
			state <= 0;
			tx_clk_count <= 0;
			tx <= 1;
		end else begin
			if (state == 0) begin
				tx_clk_count <= 0;
			end else begin
				tx_clk_count <= tx_clk_count + 1;
			end
			case (state) 
				0: begin
					if (data_valid) begin
						data_r <= data;
						state <= 1;
						tx_clk_count <= 0;
						tx <= 0;
					end
				end
			
				// End of start bit
				1: begin // Align with the baud clock
					if (tx_clk_count16) begin
						state <= 2;
						bit_count <= 0;
					end
				end
			
				// Wait for an acknowledgement from the other domain
				2: begin
					tx <= data_r[0];
					if (tx_clk_count16) begin
						data_r <= {1'b0, data_r[7:1]};
						bit_count <= bit_count + 1;
					
						// bit_count will be 7 at the end of the 8th bit
						if (bit_count == 7) begin
							state <= 3;
							tx <= 1;
						end
					end
				end
			
				// Stop bit
				3: begin
					if (tx_clk_count16) begin
						state <= 0;
					end
				end
			endcase
		end
	end

endmodule



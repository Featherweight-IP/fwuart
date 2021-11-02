/****************************************************************************
 * fwuart_rx.v
 ****************************************************************************/
`include "rv_macros.svh"
  
/**
 * Module: fwuart_rx
 * 
 * TODO: Add module documentation
 */
module fwuart_rx(
		input		clock,
		input		reset,
		`RV_INITIATOR_PORT(i_, 8),
		input		clock_x16,
		input		rx);
	reg[7:0]		data_r;
	reg[2:0]		state;
	reg[3:0]		rx_clk_count;
	wire			rx_clk_count7  = &rx_clk_count[2:0];
	wire			rx_clk_count16 = &rx_clk_count;
	reg[2:0]		bit_count;
	
	assign i_valid = (state == 3'b100);
	assign i_dat = data_r;

	always @(posedge clock or posedge reset) begin
		if (reset) begin
			state <= {3{1'b0}};
			rx_clk_count <= {4{1'b0}};
			bit_count <= {3{1'b0}};
			data_r <= {8{1'b0}};
		end else begin
			if (state == 0) begin
				rx_clk_count <= 0;
			end else if (clock_x16) begin
				rx_clk_count <= rx_clk_count + 1;
			end
			
			case (state)
				3'b000: begin // Await beginning of start bit
					if (!rx) begin
						state <= 1;
						rx_clk_count <= {4{1'b0}};
					end
				end
				
				3'b001: begin // Await end of start bit
					if (clock_x16 && rx_clk_count16) begin
						state <= 2;
						bit_count <= 0;
					end
				end
				
				3'b010: begin // Receive bits
					if (clock_x16 && rx_clk_count16) begin
						bit_count <= bit_count + 1;
						
						if (bit_count == 7) begin
							// Have all required data
							state <= 3'b011;
						end
					end else if (clock_x16 && rx_clk_count7) begin
						// Sample data mid-window
						data_r <= {rx, data_r[7:1]};
					end
				end
				
				3'b011: begin // Wait for end of stop bit
					if (clock_x16 && rx_clk_count16) begin
						state <= 3'b100;
					end
				end
				
				3'b100: begin // Transfer data 
					if (i_ready) begin
						// Back to the beginning
						state <= 3'b000;
					end
				end
			endcase
		end
	end


endmodule



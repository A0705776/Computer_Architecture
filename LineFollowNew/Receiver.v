//daniel lopez 8-bit uart data
module Receiver(serialInput, clk, rst, ackDone, regOutput);

	input serialInput, clk, rst;
	output reg [7:0] regOutput = 0;
	output reg ackDone = 0;
	
	parameter readyBit = 0, sampleHold = 1, sampleBit = 2, stopBit = 3;
	reg[2:0] state = readyBit;
	reg[3:0] sampleCount = 0;
	reg[8:0] baudRate = 0;
	
	always@(posedge clk) begin
		if(rst == 0) begin
			state <= readyBit; regOutput <= 8'b00000000; baudRate <= 9'b000000000;
			sampleCount <= 4'b0000; ackDone <= 1'b0;
		end else begin
			ackDone <= 1'b0;
			case(state)
				readyBit:begin
					if(serialInput == 1'b0) state <= sampleHold;
					else state <= readyBit;
				end
				sampleHold:begin
					if(baudRate >= 450) begin //450
						if(sampleCount >= 4'b1000) begin
							state <= stopBit; sampleCount <= 4'b0000; baudRate <= 9'b000000000; 
						end
						else begin
							baudRate <= 9'b000000000; state <= sampleBit;
						end
					end
					else begin baudRate <= baudRate + 1; state <= sampleHold; end
				end
				sampleBit:begin
					regOutput[0] <= regOutput[1]; 
					regOutput[1] <= regOutput[2];
					regOutput[2] <= regOutput[3]; 
					regOutput[3] <= regOutput[4];
					regOutput[4] <= regOutput[5]; 
					regOutput[5] <= regOutput[6];
					regOutput[6] <= regOutput[7]; 
					regOutput[7] <= serialInput;
					//regOutput <= regOutput << 1;
					//regOutput[0] <= serialInput;
					sampleCount <= sampleCount + 1;
					state <= sampleHold;
				end
				stopBit:begin
					if(serialInput == 1'b1) begin state <= readyBit; ackDone <= 1'b1; end
					else state <= stopBit;
				end
			endcase
		end
	end
endmodule
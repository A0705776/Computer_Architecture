module delay(clk,rst,delayTime,dirL, dirR); 
	input[9:0] delayTime;
	reg[9:0] counter = 0;
	input clk, rst;
	reg[25:0] ticks = 0;
	output reg dirL = 1, dirR = 1;

	always@(negedge clk)begin
		if(rst == 1)begin
			counter = 0;
		end
		else begin
			if(ticks >= 50000000)begin
				ticks = 0;
				if(counter >= delayTime)begin
					counter = 0;
					
					if(dirL) begin dirL = 0; dirR = 0; end
					else begin dirL = 1; dirR = 1; end

				end
				else ;
				counter = counter + 1;
			end
			else ;
			ticks = ticks + 1;
		end
	end
endmodule 

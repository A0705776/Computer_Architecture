module LineFollow(clk,rst,enable,PWM_Out); 
	parameter HIGH = 1'b1,
		  LOW  = 1'b0,
		  ZEROS = 8'b0,
		  FULL = 8'b11111111;

	input enable, clk, rst;
	output reg PWM_Out;

	always@(posedge clk) begin
		
	end
endmodule 

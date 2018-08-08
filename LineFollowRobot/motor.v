module motor(clk,PWM_Out);
	input clk;
	output PWM_Out;
	reg rst = 0, enable = 1;
	reg[7:0] speed = 8'b10000000;
	
	PWM myPWM(clk,rst,speed,enable,PWM_Out);
	
	
	always@(posedge clk)begin
		rst = 0;
		enable = 1;
	end
endmodule 
		
	

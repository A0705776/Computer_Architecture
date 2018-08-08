module Top(clk,PWM_OutR, dirR,PWM_OutL, dirL);
	input  clk;
	output PWM_OutR, dirR, PWM_OutL, dirL;

	motor right(clk,PWM_OutR);
	motor left(clk,PWM_OutL);
	delay myDelay(clk,rst,3,dirL,dirR);
endmodule

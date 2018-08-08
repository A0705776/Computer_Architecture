/*
Computer Archictecture project: Line following 2-wheeled robot
5:05 PM Saturday, April 22, 2017

Alamin Ahmed,
Luis Robles,
Vinh Vu,
Daniel Lopez,
and Steven Ventura

*/

module Top(clk,PWM_OutR, dirR,PWM_OutL, dirL,sensorLeftRaw, sensorMiddleRaw, sensorRightRaw,serialInput,enable,regOutput);
	input clk;//50MHz??
	input sensorLeftRaw, sensorMiddleRaw, sensorRightRaw, serialInput;
	output PWM_OutR, dirR, PWM_OutL, dirL,enable;
	wire sensorLeftFiltered,sensorMiddleFiltered,sensorRightFiltered, ackDone;
	output[7:0] regOutput;
	reg rst = 1'b1;
	//TODO: use a slower clock for filters?
	LightSensorFilter lsf1 (clk, sensorLeftRaw, sensorLeftFiltered);
	LightSensorFilter lsf2 (clk, sensorMiddleRaw, sensorMiddleFiltered);
	LightSensorFilter lsf3 (clk, sensorRightRaw, sensorRightFiltered);
	
	LineFollow lf1 (clk, enable, 
			sensorLeftFiltered,sensorRightFiltered,sensorMiddleFiltered,
			PWM_OutL, PWM_OutR, dirR, dirL
			);
	Receiver myReceiver(serialInput, clk, rst, ackDone, regOutput);
	
	Translator myTranslator(clk, ackDone, regOutput, enable);
endmodule

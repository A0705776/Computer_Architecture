//Steven Ventura 5:41 PM Saturday, April 22, 2017
module LineFollow (clk, enable, 
			sensorLeftFiltered,sensorRightFiltered,sensorMiddleFiltered,
			PWM_OutL, PWM_OutR, dirR, dirL
			);
	input enable;
			
	input sensorLeftFiltered,sensorMiddleFiltered,sensorRightFiltered;
	input clk;
	output PWM_OutL,PWM_OutR;
	output reg dirR=1,dirL=1;

	reg [7:0] leftMotorSpeed, rightMotorSpeed;
	reg[24:0] counter = 25'b0;
	reg[2:0] state = 3'b0;
	reg bool = 0;

	PWM pwmleft (clk, leftMotorSpeed, PWM_OutL);
	PWM pwmright (clk, rightMotorSpeed, PWM_OutR);

	//the filtered sensor data. [2]=left,[1]=middle,[0]=right
	wire [2:0] sensors;

	assign sensors = {sensorLeftFiltered,sensorMiddleFiltered,sensorRightFiltered};

	parameter MAX = 8'b10111111,//75% duty
				HALF= 8'b01011111,//37.5% duty
				OFF = 8'b00000000;//0% duty

	//now do the actual linefollowing
	always @(posedge clk) begin
	//rightMotorSpeed <= OFF;
	//leftMotorSpeed <= OFF;

	if (enable == 1) begin
		
		case(sensors)
		3'b000: begin
			//at a "T" intersection 
			if(!bool)begin
				state <= 3'b000;
				counter <= 25'b0;
				dirL <= 1;
				dirR <= 1;
				rightMotorSpeed <= MAX;
				leftMotorSpeed <= MAX;
			end else begin 
				counter <= counter + 1; 
				if(counter >= 25'b001111111111111111111111) bool <= 0;
			end
		end
		3'b001:begin
			//drifting to the right
			if(!bool)begin
				state <= 3'b001;
				counter <= 25'b0;
				dirL <= 1;
				dirR <= 1;
				rightMotorSpeed <= MAX;
				leftMotorSpeed <= HALF;
			end else begin 
				counter <= counter + 1; 
				if(counter >= 25'b001111111111111111111111) bool <= 0;
			end
		end
		3'b010:begin
			//ERROR (ignore)
			if(!bool)begin
				state <= 3'b010;
				counter <= 25'b0;
				dirL <= 1;
				dirR <= 1;
				rightMotorSpeed <= MAX;
				leftMotorSpeed <= MAX;
			end else begin 
				counter <= counter + 1; 
				if(counter >= 25'b001111111111111111111111) bool <= 0;
			end
		end
		3'b011:begin
			//went too far to the right
			if(!bool)begin
				state <= 3'b011;
				counter <= 25'b0;
				dirL <= 1;
				dirR <= 1;
				rightMotorSpeed <= MAX;
				leftMotorSpeed <= OFF;
			end else begin 
				counter <= counter + 1; 
				if(counter >= 25'b001111111111111111111111) bool <= 0;
			end
		end
		3'b100:begin
			//drifting to the left
			if(!bool)begin
				state <= 3'b100;
				counter <= 25'b0;
				dirL <= 1;
				dirR <= 1;
				rightMotorSpeed <= HALF;
				leftMotorSpeed <= MAX;
			end else begin 
				counter <= counter + 1; 
				if(counter >= 25'b001111111111111111111111) bool <= 0;
			end
		end
		3'b101:begin
			//running in the middle
			if(!bool)begin
				state <= 3'b101;
				counter <= 25'b0;
				dirL <= 1;
				dirR <= 1;
				rightMotorSpeed <= MAX;
				leftMotorSpeed <= MAX;
			end else begin 
				counter <= counter + 1; 
				if(counter >= 25'b001111111111111111111111) bool <= 0;
			end
		end
		3'b110:begin
			//went too far to the left
			if(!bool)begin
				state <= 3'b110;
				counter <= 25'b0;
				dirL <= 1;
				dirR <= 1;
				rightMotorSpeed <= OFF;
				leftMotorSpeed <= MAX;
			end else begin 
				counter <= counter + 1; 
				if(counter >= 25'b001111111111111111111111) bool <= 0;
			end
		end
		3'b111:begin
			//fix it self please
			case(state)
				3'b000: begin
					//at a "T" intersection 
					dirL <= 0;
					dirR <= 0;
					rightMotorSpeed <= OFF;
					leftMotorSpeed <= OFF;
				end
				3'b001:begin
					//drifting to the right
					dirL <= 0;
					dirR <= 1;
					//if(counter <= 25'b011111111111111111111111)begin bool <= 1; counter <= counter + 1; end
					rightMotorSpeed <= MAX;
					leftMotorSpeed <= OFF;
				end
				3'b010:begin
					//ERROR (ignore)
					dirL <= 0;
					dirR <= 0;
					rightMotorSpeed <= MAX;
					leftMotorSpeed <= MAX;
				end
				3'b011:begin
					//went too far to the right
					dirL <= 0;
					dirR <= 1;
					//if(counter <= 25'b001111111111111111111111)begin bool <= 1; counter <= counter + 1; end
					rightMotorSpeed <= MAX;
					leftMotorSpeed <= HALF;
				end
				3'b100:begin
					//drifting to the left
					dirL <= 1;
					dirR <= 0;
					//if(counter <= 25'b011111111111111111111111)begin bool <= 1; counter <= counter + 1; end
					rightMotorSpeed <= OFF;
					leftMotorSpeed <= MAX;
				end
				3'b101:begin
					//running in the middle
					dirL <= 0;
					dirR <= 0;
					rightMotorSpeed <= OFF;
					leftMotorSpeed <= OFF;
				end
				3'b110:begin
					//went too far to the left
					dirL <= 1;
					dirR <= 0;
					//if(counter <= 25'b001111111111111111111111)begin bool <= 1; counter <= counter + 1; end
					rightMotorSpeed <= HALF;
					leftMotorSpeed <= MAX;
				end
			endcase
//			dirL <= 0;
//			dirR <= 0;
//			rightMotorSpeed <= MAX;
//			leftMotorSpeed <= MAX;
//			counter = counter + 1;
//			if(counter >= 8'b00001111)begin
//				counter = counter - 1;
//				rightMotorSpeed <= OFF;
//				leftMotorSpeed <= OFF;
//			end
		end

		endcase
	end//end ifenable
	else begin 
		rightMotorSpeed <= OFF;
		leftMotorSpeed <= OFF; 
	end

	end//end always




endmodule
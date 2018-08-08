`timescale 1 ns/1 ns

module TB_ALU();
	reg[31:0] A,B;
	reg[1:0] control;
	wire[31:0] result;
	ALU My_ALU(result,control,A,B);
		initial begin 
			A = 32'b01110001; B = 32'b01101001; control = 2'b01;
			#10 A = 32'b01110001; B = 32'b01101001; control = 2'b11;

			#10 A = 32'b01110101; B = 32'b01101011; control = 2'b00;
			#10 A = 32'b01110101; B = 32'b01101011; control = 2'b10;

			#10 A = 32'b01110101; B = 32'b01101011; control = 2'b10;
		end
endmodule 

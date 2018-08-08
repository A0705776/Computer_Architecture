module ALU(result,control,A,B);
	input[31:0] A, B;
	input[1:0] control;
	output[31:0] result;
	reg[31:0] result;
	always@(control) begin
		case(control)
			2'b00: begin  result = A & B; end
			2'b01: begin  result = A | B; end
			2'b10: begin  result = A + B; end
			2'b11: begin  result = A - B; end
			default: ;
		endcase
	end
endmodule

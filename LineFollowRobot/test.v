module test(inA,inB,out);
	input inA,inB;
	output reg out;

	always@(inA,inB) begin
		out = inA^inB;

	end
endmodule

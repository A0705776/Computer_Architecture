module Translator (clk, ackDone, receiverData, enable);
output reg enable=0;
input clk,ackDone;
input [7:0] receiverData;
reg[7:0] DataReg = 8'b0;
parameter s = 8'd115,
		  e = 8'd101;
		  
always @(posedge clk) begin
if(ackDone == 1)begin
	DataReg = receiverData;
	if(DataReg == e)begin enable <= 0; end
	else if(DataReg == s) begin enable <= 1; end
end

//enable <= 1;

end //always

endmodule
`timescale 1ns / 1ps
module RegisterFile(ReadReg1, ReadReg2, WriteReg, RegWrite, WriteData, clk, ReadData1, ReadData2);
	input [4:0]ReadReg1, ReadReg2, WriteReg;
	input clk, RegWrite;
	input [31:0]WriteData;
	output [31:0]ReadData1, ReadData2;
	
	reg [31:0]regfile[31:0];
	assign ReadData1 = (ReadReg1 != 32'h0000)? regfile[ReadReg1]: 32'h0000;
	assign ReadData2 = (ReadReg2 != 32'h0000)? regfile[ReadReg2]: 32'h0000;
	
	always @(posedge clk)
		if(RegWrite) begin
			regfile[WriteReg] <= WriteData;
		end
endmodule

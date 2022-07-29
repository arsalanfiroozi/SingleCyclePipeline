`timescale 1ns / 1ps
module DataMemory(clk, MemWrite, Address, WriteData, ReadData, MemReady);
	parameter Mem_Delay = 0;
	
	input clk, MemWrite;
	input [31:0]WriteData, Address;
	output wire [31:0]ReadData;
	output reg MemReady;
	
	reg [31:0]RAM[1023:0];
	
	assign #Mem_Delay ReadData = RAM[Address[31:2]];
	
	always @(Address) begin
		MemReady = 1'b0;
		#Mem_Delay;
		MemReady = 1'b1;
	end
	
	integer i;
	initial begin
		for (i=0; i<=1023; i=i+1)
				RAM[i] <= 32'd00;
	end
	
	always @(posedge clk) begin
		if(MemWrite) 
			RAM[Address[31:2]] <= WriteData;
	end
	
endmodule

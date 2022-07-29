`timescale 1ns / 1ps
module DataMemory(clk, MemWrite, Address, WriteData, ReadData, MemReady);
	parameter Mem_Delay = 100;
	
	input clk, MemWrite;
	input [31:0]WriteData, Address;
	output wire [31:0]ReadData;
	output reg MemReady;
	
	reg [31:0]RAM[1023:0];
	
	assign #Mem_Delay ReadData = RAM[Address];
	
	always @(Address) begin
		MemReady = 1'b0;
		#Mem_Delay;
		MemReady = 1'b1;
	end
	
	always @(posedge clk) begin
		if(MemWrite) begin
			RAM[Address] <= WriteData;
		end
	end
	
endmodule

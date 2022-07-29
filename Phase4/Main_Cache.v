`timescale 1ns / 1ps
module Main_Cache(clk, reset, hit, readdata, Address);
	input wire clk, reset;
	output [7:0] readdata;
	output hit;
	
	wire RWB;
	wire [7:0] Data;
	output wire [5:0] Address;
	
	Processor processor(.clk(clk), .start(reset), .RWB(RWB), .Address(Address), .Data(Data));
	
	Memorysystem memorysystem(.clk(clk), .reset(reset), .writedata(Data), .writeen(RWB), .address(Address), .readdata(readdata), .hit(hit)); 	

endmodule

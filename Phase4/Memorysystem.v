`timescale 1ns / 1ps
module Memorysystem(clk, reset, hit, address, readdata, writedata, writeen);
	input clk, reset, writeen;
	output wire hit;
	input [5:0]address;
	input [7:0]writedata;
	output [7:0]readdata;
	
	wire [7:0]readdata1, memdata;
	assign readdata = (!writeen)?((hit)?readdata1:memdata):8'h00;
	
	wire [5:0]memreadaddress, memwriteaddress;
	wire memwriteen, memreaden;
	wire [7:0] memwritedata;

	RAM ram(.ReadData(memdata), .WriteData(memwritedata), .Reset(reset), .readAddress(memreadaddress), .writeAddress(memwriteaddress), .Clk(clk), .writeEn(memwriteen), .readEn(memreaden));

	CACHE cache(.clk(clk), .reset(reset), .hit(hit), .cacheaddress(address), .readdata(readdata1), .writeen(writeen), .writedata(writedata), .memreadaddress(memreadaddress), .memwriteaddress(memwriteaddress), .memwriteen(memwriteen), .memreaden(memreaden), .memdata(memdata), .memwritedata(memwritedata));

endmodule

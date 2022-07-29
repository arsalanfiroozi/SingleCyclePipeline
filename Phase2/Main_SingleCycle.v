`timescale 1ns / 1ps
module Main_SingleCycle(clk, reset, memout, Ready, Pc);
	input wire clk, reset;
	output wire [31:0]memout,Pc;
	output wire Ready;
	
	wire zero;
	wire [31:0]instruction;
	wire Mem2reg, Memwrite, PCSrc, ALUSrc, Regdst, Regwrite, Sgnzero;
	wire [2:0]ALUOP;
	
	// Controller Unit
	Controller control(.op(instruction[31:26]), .func(instruction[5:0]), .zero(zero), .Mem2reg(Mem2reg), .Memwrite(Memwrite), .PCSrc(PCSrc), .ALUOP(ALUOP), .ALUSrc(ALUSrc), .Regdst(Regdst), .Regwrite(Regwrite), .Sgnzero(Sgnzero));
	
	// Datapath_SingleCycle Unit
	Datapath_SignleCycle datapath_SingleCycle(.clk(clk), .reset(reset), .memout(memout), .Mem2reg(Mem2reg), .Memwrite(Memwrite), .PCSrc(PCSrc), .ALUSrc(ALUSrc), .Regdst(Regdst), .Regwrite(Regwrite), .Sgnzero(Sgnzero), .zero(zero), .ALUOP(ALUOP), .instruction(instruction), .Ready(Ready), .Pc(Pc));

endmodule

`timescale 1ns / 1ps
module Datapath_SignleCycle(clk, reset, memout, Ready, Mem2reg, Memwrite, PCSrc, ALUSrc, Regdst, Regwrite, Sgnzero, zero, ALUOP, instruction, Pc);
	input clk,reset;
	wire [31:0]aluout;
	output reg [31:0]Pc;
	input wire Mem2reg, Memwrite, PCSrc, ALUSrc, Regdst, Regwrite, Sgnzero;
	input wire [2:0]ALUOP;
	
	// Instruction Memory Unit
	output wire [31:0]instruction;
	InstructionMemory insmem(.address(Pc), .instruction(instruction));
	
	// Reg File Unit
	wire [31:0]writedata;
	wire [4:0]writereg;
	assign writedata = (Mem2reg)?memout:aluout;
	assign writereg = (Regdst)?instruction[15:11]:instruction[20:16];
	wire [31:0]d1,d2;
	RegisterFile regfile(.clk(clk), .ReadReg1(instruction[25:21]), .ReadReg2(instruction[20:16]), .WriteReg(writereg), .WriteData(writedata), .RegWrite(Regwrite), .ReadData1(d1), .ReadData2(d2));
		
	// Data Memory Unit 
	output wire [31:0]memout;
	output wire Ready;
	DataMemory datamem(.clk(clk), .MemWrite(Memwrite), .Address(aluout), .WriteData(d2), .ReadData(memout), .MemReady(Ready));
	
	// Sign Or Zero Extend Unit
	wire [31:0]extended;
	SignExtend signorzero(.Sgnzero(Sgnzero), .A(instruction[15:0]), .B(extended));
	
	// Alu Unit 
	wire [31:0]aluin;
	assign aluin = (ALUSrc)?extended:d2;
	output wire zero;
	ALU alu(.A(d1), .B(aluin), .ALUControl(ALUOP), .Y(aluout), .Z(zero));
	
	// Shift To Left Unit
	wire [31:0]shifted;
	shifttoleft sl(.A(extended) ,.B(shifted));
	
	// PC+4
	wire [31:0]PCPlus4;
	assign PCPlus4 = Pc + 32'd4;
	
	// PC Unit
	//reg [31:0]Pc;
	wire [31:0]NextPC;
	wire [31:0]PCBranch;
	assign PCBranch = PCPlus4 + shifted;
	assign NextPC = (PCSrc)?PCBranch:PCPlus4;

	
	always @(posedge clk) begin
		if(!reset)
			Pc <= NextPC;
		else
			Pc <= 32'd00;
	end
	
endmodule

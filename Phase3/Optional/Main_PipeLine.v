`timescale 1ns / 1ps
module Main_PipeLine(clk, reset, resultw);
	input clk, reset;
	output [31:0]resultw;
	
	wire memready;
	
	wire regwrited, memtoregd, memwrited, alusrcd, regdstd, pcsrcd, branchd, sgnzero;
	wire [2:0]aluopd;
	wire regwritee, memtorege, memwritee, alusrce, regdste;
	wire [2:0]aluope;
	wire regwritem, memtoregm, memwritem;
	wire regwritew, memtoregw;
	wire [5:0]op,func;
	wire zero;
	
	wire stallf, stalld, stalle, stallm, stallw, forwardad, forwardbd, flushe;
	wire [1:0] forwardae, forwardbe;
	wire [4:0] rsd, rtd, rse, rte, writereg, writeregm, writeregw;
	
	Datapath_PipeLine datapath(reset, clk, pcsrcd, sgnzero, alusrce, regdste, aluope, memwritem, regwritew, memtoregw, stallw, stallf, stalld, stalle, stallm, forwardad, forwardbd, flushe, forwardae, forwardbe, op, func, memready, zero, rsd, rtd, rse, rte, writereg, writeregm, writeregw, resultw);

	
	Control_PipLine controller(clk, reset, op, func, zero, regwrited, memtoregd, memwrited, alusrcd, regdstd, pcsrcd, sgnzero, aluopd, branchd, regwritee, memtorege, memwritee, alusrce, regdste, aluope, regwritem, memtoregm, memwritem, regwritew, memtoregw, flushe, stalle, stallm, stallw);

	
	Hazard_Pipeline hazard(clk, reset, stallf, stalld, stalle, stallm, stallw, forwardad, forwardbd, flushe, forwardae, forwardbe, memtorege, regwritee, regwritem, regwritew, branchd, rsd, rtd, rse, rte, writereg, writeregm, memtoregm, writeregw);

	
endmodule

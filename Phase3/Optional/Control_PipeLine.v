`timescale 1ns / 1ps
module Control_PipLine(clk, reset, op, func, zero, regwrited, memtoregd, memwrited, alusrcd, regdstd, pcsrcd, sgnzero, aluopd, branchd, regwritee, memtorege, memwritee, alusrce, regdste, aluope, regwritem, memtoregm, memwritem, regwritew, memtoregw, flushe, stalle, stallm, stallw);
	output regwrited, memtoregd, memwrited, alusrcd, regdstd, pcsrcd, sgnzero, branchd;
	output [2:0]aluopd;
	output reg regwritee, memtorege, memwritee, alusrce, regdste;
	output reg [2:0]aluope;
	output reg regwritem, memtoregm, memwritem;
	output reg regwritew, memtoregw;
	input [5:0]op,func;
	input clk, reset, zero, flushe, stalle, stallm, stallw;
	
	Controller control(.op(op), .func(func), .zero(zero), .Mem2reg(memtoregd), .Memwrite(memwrited), .PCSrc(pcsrcd), .ALUOP(aluopd), .ALUSrc(alusrcd), .Regdst(regdstd), .Regwrite(regwrited), .Sgnzero(sgnzero) , .Branch(branchd));
	
	always @(posedge clk)
	begin
		if(reset)
		begin
			{regwritee, memtorege, memwritee, alusrce, regdste} <= 5'h00;
			{regwritem, memtoregm, memwritem} <= 3'h0;
			{regwritew, memtoregw} <= 2'h0;
			aluope <= 3'h0;
		end
		else
		begin
			if(stalle)
				{regwritee, memtorege, memwritee, alusrce, regdste} <= {regwritee, memtorege, memwritee, alusrce, regdste};
			else if(flushe)
				{regwritee, memtorege, memwritee, alusrce, regdste} <= 5'h00;
			else
				{regwritee, memtorege, memwritee, alusrce, regdste} <= {regwrited, memtoregd, memwrited, alusrcd, regdstd};
			if(stallm)
				{regwritem, memtoregm, memwritem} <= {regwritem, memtoregm, memwritem};
			else
				{regwritem, memtoregm, memwritem} <= {regwritee, memtorege, memwritee};
			if(stallw)
				{regwritew, memtoregw} <= {regwritew, memtoregw};
			else
				{regwritew, memtoregw} <= {regwritem, memtoregm};
			aluope <= aluopd;
		end
	end
endmodule

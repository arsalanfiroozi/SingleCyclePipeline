`timescale 1ns / 1ps
module Hazard_Pipeline(clk, reset, stallf, stalld, stalle, stallm, stallw, forwardad, forwardbd, flushe, forwardae, forwardbe, memtorege, regwritee, regwritem, regwritew, branchd, rsd, rtd, rse, rte, writereg, writeregm, memtoregm, writeregw);
	parameter Mem_Delay = 3;
	reg [1:0]count;
	always @(posedge clk)
	begin
		if(reset)
			count <= 2'b00;
		else
			count <= (memtoregm)?(( !(|count) )?Mem_Delay:(count-2'b01)):Mem_Delay;
	end

	output stallf, stalld, stalle, stallm, stallw, forwardad, forwardbd, flushe;
	output [1:0] forwardae, forwardbe;
	input clk, reset;
	input memtorege, regwritee, regwritem, regwritew, branchd, memtoregm;
	input [4:0] rsd, rtd, rse, rte, writereg, writeregm, writeregw;
	
	// memtorege
	
	wire [4:0]writerege;
	assign writerege = writereg;
	
	wire branchstall;
	
	assign forwardae = ((rse != 5'd0) && regwritem && (writeregm == rse))?2'b10:(((rse != 5'd0) && regwritew && (writeregw == rse))?2'b01:2'b00);
	assign forwardbe = ((rte != 5'd0) && regwritem && (writeregm == rte))?2'b10:(((rte != 5'd0) && regwritew && (writeregw == rte))?2'b01:2'b00);
	
	assign flushe = ((memtorege && regwritee && ((writerege == rsd) || (writerege == rtd)))?1'b1:1'b0) || (branchstall?1'b1:1'b0) || (memtoregm && regwritem && (|count) );
	assign stalld = ((memtorege && regwritee && ((writerege == rsd) || (writerege == rtd)))?1'b1:1'b0) || (branchstall?1'b1:1'b0) || (memtoregm && regwritem && (|count) );
	assign stallf = ((memtorege && regwritee && ((writerege == rsd) || (writerege == rtd)))?1'b1:1'b0) || (branchstall?1'b1:1'b0) || (memtoregm && regwritem && (|count) );
	assign stalle = (memtoregm && regwritem && (|count) );
	assign stallm = (memtoregm && regwritem && (|count) );
	assign stallw = (memtoregm && regwritem && (|count) );
	
	assign forwardad = ((rsd != 5'd0) && regwritem && (writeregm == rsd))?1'b1:1'b0;
	assign forwardbd = ((rtd != 5'd0) && regwritem && (writeregm == rtd))?1'b1:1'b0;
	assign branchstall = (branchd && regwritee && ((rsd == writerege) || (rtd == writerege))) || (branchd && regwritem && memtoregm && ((rsd == writeregm) || (rtd == writeregm)));
	
endmodule

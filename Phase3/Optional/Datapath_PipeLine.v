`timescale 1ns / 1ps
module Datapath_PipeLine(reset, clk, pcsrcd, sgnzero, alusrce, regdste, aluope, memwritem, regwritew, memtoregw, stallw, stallf, stalld, stalle, stallm, forwardad, forwardbd, flushe, forwardae, forwardbe, op, func, memready, zero, rsd, rtd, rse, rte, writereg, writeregm, writeregw, resultw);
	input clk, reset;
	output wire [31:0]resultw;
	
	reg [4:0]writeregw;
	// Controller
//	input regwrited, memtoregd, memwrited, alusrcd, regdstd, pcsrcd, sgnzero;
//	input [2:0]aluopd;
//	input regwritee, memtorege, memwritee, alusrce, regdste;
//	input [2:0]aluope;
//	input regwritem, memtoregm, memwritem;
//	input regwritew, memtoregw;
//	output [5:0]op,func;
//	output zero;
//	assign op = instructiond[31:26];
//	assign func = instructiond[5:0];
	input pcsrcd, sgnzero;
	input alusrce, regdste;
	input [2:0]aluope;
	input memwritem;
	input regwritew, memtoregw;
	output [5:0]op,func;
	output zero;
	assign op = instructiond[31:26];
	assign func = instructiond[5:0];
	
	// Hazard
	input stallf, stalld, stalle, stallm, stallw, forwardad, forwardbd, flushe;
	input [1:0] forwardae, forwardbe;
	//output pcsrcd, memready, memtorege, regwritee, regwritem, regwritew;
	output memready;
	output [4:0] rsd, rtd, rse, rte, writereg, writeregm, writeregw;
	
	// Fetch
	reg [31:0] PC;
	wire [31:0]instruction;
	
	wire [31:0] PCPlus4;
	assign PCPlus4 = PC + 32'h04;
	
	always @(posedge clk)
	begin
		if(reset)
			PC <= 32'h00000000;
		else
		if(!stallf)
			PC <= (pcsrcd)?PCBranch:PCPlus4;
		else
			PC <= PC;
	end
	
	InstructionMemory insmem(PC, instruction);
	
	reg [31:0]instructiond, PCPlus4d;
	always @(posedge clk)
	begin
		if(reset) begin
			instructiond <= 32'h00000000;
			PCPlus4d <= 32'h00000000;
		end
		else
		if(!stalld && !pcsrcd) begin
			instructiond <= instruction;
			PCPlus4d <= PCPlus4;
		end
		else
			if(stalld)
			begin
				instructiond <= instructiond;
				PCPlus4d <= PCPlus4d;
			end
			else
			if(pcsrcd)
			begin
				instructiond <= 32'h00000000;
				PCPlus4d <= 32'h00000000;
			end
	end
	
	//Decode
	wire [31:0]d1,d2;
	
	RegisterFile_PipeLine regfile(.ReadReg1(instructiond[25:21]), .ReadReg2(instructiond[20:16]), .WriteReg(writeregw), .RegWrite(regwritew), .WriteData(resultw), .clk(clk), .ReadData1(d1), .ReadData2(d2));
	
	wire [31:0]reg1, reg2;
	assign reg1 = (forwardad)?aluoutm:d1;
	assign reg2 = (forwardbd)?aluoutm:d2;
	
	wire zero;
	assign zero = (reg1 == reg2);
	
	wire [31:0]extended;
	SignExtend signorzero(.Sgnzero(sgnzero), .A(instructiond[15:0]), .B(extended));
	
	wire [31:0]shifted;
	shifttoleft sl(.A(extended) ,.B(shifted));
	
	wire [31:0]PCBranch;
	assign PCBranch = shifted + PCPlus4d;
	
	assign rsd = instructiond[25:21];
	assign rtd = instructiond[20:16];
	
	reg [31:0]d1e, d2e, extendede;
	reg [4:0]rse, rte, rde;
	always @(posedge clk)
	begin
		if(flushe) begin
			rse <= 5'h00;
			rte <= 5'h00;
			rde <= 5'h00;
			d1e <= 32'h00000000;
			d2e <= 32'h00000000;
			extendede <= 32'h00000000;
		end
		else begin	
			if(stalle) begin
				rse <= rse;
				rte <= rte;
				rde <= rde;
				d1e <= d1e;
				d2e <= d2e;
				extendede <= extendede;
			end
			else
			begin
				rse <= rsd;
				rte <= rtd;
				rde <= instructiond[15:11];
				d1e <= d1;
				d2e <= d2;
				extendede <= extended;
			end
		end
	end
	//Execute
	
	assign writereg = (regdste)?rde:rte;
	
	wire [31:0]srca, srcb, aluout, writedata;
	assign srca = (forwardae==2'd0)?d1e:((forwardae==2'd1)?resultw:aluoutm);
	assign writedata = (forwardbe==2'd0)?d2e:((forwardbe==2'd1)?resultw:aluoutm);
	assign srcb = (alusrce)?extendede:writedata;
	
	
	ALU alu(.A(srca), .B(srcb), .ALUControl(aluope), .Y(aluout), .Z());
	
	reg [31:0]aluoutm, writedatam; 
	reg [4:0]writeregm;
	always @(posedge clk)
	begin
		if(stallm)
		begin
			aluoutm <= aluoutm;
			writedatam <= writedatam;
			writeregm <= writeregm;
		end
		else
		begin
			aluoutm <= aluout;
			writedatam <= writedata;
			writeregm <= writereg;
		end
	end
	
	//Memory
	wire memready;
	wire [31:0]memout;
	
	DataMemory datamem(.clk(clk), .MemWrite(memwritem), .Address(aluoutm), .WriteData(writedatam), .ReadData(memout), .MemReady(memready));
	
	reg [31:0]memoutw, aluoutw;
	always @(posedge clk)
	begin
		if(stallw)
		begin
			memoutw <= memoutw;
			aluoutw <= aluoutw;
			writeregw <= writeregw;
		end
		else
		begin
			memoutw <= memout;
			aluoutw <= aluoutm;
			writeregw <= writeregm;
		end
	end
	
	//Writeback
	
	assign resultw = (memtoregw)?memoutw:aluoutw;
	
endmodule

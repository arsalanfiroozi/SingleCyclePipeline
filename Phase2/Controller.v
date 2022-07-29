`timescale 1ns / 1ps
module Controller(op, func, zero
						, Mem2reg, Memwrite, PCSrc, ALUOP, ALUSrc, Regdst, Regwrite, Sgnzero);
	input [5:0]op,func;
	input zero;
	output reg Mem2reg, Memwrite, PCSrc, ALUSrc, Regdst, Regwrite, Sgnzero;
	output reg [2:0]ALUOP;
	
	always @(*) begin
		casex({op,zero})
			{6'h00,1'bx}: begin //R-type
				case(func)
					6'd32: // add
						ALUOP = 3'b000;
					6'd33: // addu
						ALUOP = 3'b000;
					6'd34: // sub
						ALUOP = 3'b001;
					6'd35: //subu
						ALUOP = 3'b001;
					6'd36: //and
						ALUOP = 3'b010;
					6'd38: //xor
						ALUOP = 3'b100;
					6'd37: //or
						ALUOP = 3'b011;
					6'd39: //nor 
						ALUOP = 3'b101;
					6'd42: //slt
						ALUOP = 3'b110;
					6'd43: //sltu
						ALUOP = 3'b111;
					default:
						ALUOP = 3'b010;
				endcase
				if(|func) begin
					Sgnzero = 1'bx;
					Regdst = 1'b1;
					Regwrite = 1'b1;
					Mem2reg = 1'b0;
					PCSrc = 1'b0;
					ALUSrc = 1'b0;
					Memwrite = 1'b0;
				end else begin  //nop
					Sgnzero = 1'bx;
					Regdst = 1'bx;
					Regwrite = 1'b0;
					Mem2reg = 1'bx;
					PCSrc = 1'b0;
					ALUSrc = 1'bx;
					Memwrite = 1'b0;
				end
			end
			{6'd4,1'b0}: begin //beq not taken
				Sgnzero = 1'b1;
				Regdst = 1'bx;
				Regwrite = 1'b0;
				Mem2reg = 1'bx;
				PCSrc = 1'b0;
				ALUSrc = 1'b0;
				Memwrite = 1'b0;
				ALUOP = 3'b001;
				end
			{6'd4,1'b1}:  begin //beq taken
				Sgnzero = 1'b1;
				Regdst = 1'bx;
				Regwrite = 1'b0;
				Mem2reg = 1'bx;
				PCSrc = 1'b1;
				ALUSrc = 1'b0;
				Memwrite = 1'b0;
				ALUOP = 3'b001;
				end
			{6'd5,1'b1}: begin //bne not taken
				Sgnzero = 1'b1;
				Regdst = 1'bx;
				Regwrite = 1'b0;
				Mem2reg = 1'bx;
				PCSrc = 1'b0;
				ALUSrc = 1'b0;
				Memwrite = 1'b0;
				ALUOP = 3'b001;
				end
			{6'd5,1'b0}: begin //bne taken
				Sgnzero = 1'b1;
				Regdst = 1'bx;
				Regwrite = 1'b0;
				Mem2reg = 1'bx;
				PCSrc = 1'b1;
				ALUSrc = 1'b0;
				Memwrite = 1'b0;
				ALUOP = 3'b001;
				end
			{6'd8,1'bx}: begin //addi
				Sgnzero = 1'b1;
				Regdst = 1'b0;
				Regwrite = 1'b1;
				Mem2reg = 1'b0;
				PCSrc = 1'b0;
				ALUSrc = 1'b1;
				Memwrite = 1'b0;
				ALUOP = 3'b000;
				end
			{6'd9,1'bx}: begin //addiu
				Sgnzero = 1'b1;
				Regdst = 1'b0;
				Regwrite = 1'b1;
				Mem2reg = 1'b0;
				PCSrc = 1'b0;
				ALUSrc = 1'b1;
				Memwrite = 1'b0;
				ALUOP = 3'b000;
				end
			{6'd12,1'bx}: begin //andi
				Sgnzero = 1'b0;
				Regdst = 1'b0;
				Regwrite = 1'b1;
				Mem2reg = 1'b0;
				PCSrc = 1'b0;
				ALUSrc = 1'b1;
				Memwrite = 1'b0;
				ALUOP = 3'b010;
				end
			{6'd13,1'bx}: begin //ori
				Sgnzero = 1'b0;
				Regdst = 1'b0;
				Regwrite = 1'b1;
				Mem2reg = 1'b0;
				PCSrc = 1'b0;
				ALUSrc = 1'b1;
				Memwrite = 1'b0;
				ALUOP = 3'b011;
				end
			{6'd14,1'bx}: begin //xori
				Sgnzero = 1'b0;
				Regdst = 1'b0;
				Regwrite = 1'b1;
				Mem2reg = 1'b0;
				PCSrc = 1'b0;
				ALUSrc = 1'b1;
				Memwrite = 1'b0;
				ALUOP = 3'b100;
				end
			{6'd10,1'bx}: begin //slti
				Sgnzero = 1'b1;
				Regdst = 1'b0;
				Regwrite = 1'b1;
				Mem2reg = 1'b0;
				PCSrc = 1'b0;
				ALUSrc = 1'b1;
				Memwrite = 1'b0;
				ALUOP = 3'b110;
				end
			{6'd11,1'bx}: begin //sltiu
				Sgnzero = 1'b1;
				Regdst = 1'b0;
				Regwrite = 1'b1;
				Mem2reg = 1'b0;
				PCSrc = 1'b0;
				ALUSrc = 1'b1;
				Memwrite = 1'b0;
				ALUOP = 3'b111;
				end
			{6'd35,1'bx}: begin //lw
				Sgnzero = 1'b1;
				Regdst = 1'b0;
				Regwrite = 1'b1;
				Mem2reg = 1'b1;
				PCSrc = 1'b0;
				ALUSrc = 1'b1;
				Memwrite = 1'b0;
				ALUOP = 3'b000;
				end
			{6'd43,1'bx}: begin //sw
				Sgnzero = 1'b1;
				Regdst = 1'bx;
				Regwrite = 1'b0;
				Mem2reg = 1'bx;
				PCSrc = 1'b0;
				ALUSrc = 1'b1;
				Memwrite = 1'b1;
				ALUOP = 3'b000;
				end
			default: begin
				Sgnzero = 1'bx;
				Regdst = 1'bx;
				Regwrite = 1'b0;
				Mem2reg = 1'bx;
				PCSrc = 1'b0;
				ALUSrc = 1'bx;
				Memwrite = 1'b0;
				ALUOP = 3'bxxx;
				end
			endcase
	end
	
endmodule

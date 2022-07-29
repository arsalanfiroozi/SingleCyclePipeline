`timescale 1ns / 1ps
module SignExtend(Sgnzero, A, B);
	input Sgnzero;
	input [15:0]A;
	output [31:0]B;
	assign B = (Sgnzero)?{{16{A[15]}},A}:{16'h0000,A};

endmodule

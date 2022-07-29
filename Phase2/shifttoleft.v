`timescale 1ns / 1ps
module shifttoleft(A,B);
	input [31:0]A;
	output [31:0]B;
	assign B = {A[29:0], 2'b00};
endmodule

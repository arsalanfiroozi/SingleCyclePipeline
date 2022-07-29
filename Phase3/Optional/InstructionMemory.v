`timescale 1ns / 1ps
module InstructionMemory(
    input [31:0]address,
    output wire [31:0]instruction
    );
	reg [31:0]ROM [1023:0];
	
//	initial 
//		$readmemh("memfile.dat",ROM);
	
	assign instruction = ROM[address[31:2]];
	
endmodule

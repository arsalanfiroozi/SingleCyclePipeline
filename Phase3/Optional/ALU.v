`timescale 1ns / 1ps
module ALU(input [31:0]A, B,
			input [2:0]ALUControl,
			output reg [31:0]Y,
			output wire Z);
	
		assign Z = Y == 32'h00000000;
	
	always @(*) begin
		
		case(ALUControl)
			3'b000:
				Y = A + B;
			3'b001:
				Y = A - B;
			3'b010:
				Y = A & B;
			3'b011:
				Y = A | B;
			3'b100:
				Y = A ^ B;
			3'b101:
				Y = ~(A | B);
			3'b110:
				Y = $signed(A) < $signed(B);
			3'b111:
				Y = A < B;
		endcase
		
	end

endmodule

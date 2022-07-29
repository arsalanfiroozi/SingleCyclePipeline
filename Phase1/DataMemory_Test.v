`timescale 10ns/1ns

module DataMemory_Test();
  
  parameter ND = 3;   // choose this same as your module's delay parameter
	//registers
	reg clk;
	reg WriteEnable;
	reg [31:0]WriteData;
	reg [31:0]Address;
	wire Ready;
	//wires
	wire [31:0]ReadData;
	
	initial
		begin
			clk = 0;
		end
  
	always
		begin
			#10 clk <= ~clk; 
		end
    
	initial 
		begin
			WriteEnable <= 1;
			Address <= 32'd64;
			WriteData <= 32'd45;
			@(posedge clk);
			Address <= 32'd128;
			WriteData <= 32'd100;
			@(posedge clk);
			WriteEnable <= 0;
			Address <= 32'd64;
			repeat (ND+1) @(posedge clk);
			#32;
			Address <= 32'd128;
			repeat (ND+2) @(posedge clk);
			
			#38;
		$stop();
		end
  
	DataMemory dmem(.clk(clk), .MemWrite(WriteEnable), .Address(Address), .WriteData(WriteData), .ReadData(ReadData), .MemReady(Ready));          
endmodule



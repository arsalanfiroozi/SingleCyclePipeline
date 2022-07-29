`timescale 1ns / 1ps

module Datapath_SingleCycle_Test2;
	wire [31:0]pc;
	wire [31:0]NextPC;
	assign NextPC = SingleCycle.datapath_SingleCycle.NextPC;
	wire PCSrc;
	assign PCSrc = SingleCycle.control.PCSrc;
	wire [31:0]instruction;
	assign instruction = SingleCycle.datapath_SingleCycle.insmem.instruction;
	wire [31:0]regi;
	assign regi = SingleCycle.datapath_SingleCycle.regfile.regfile[2];
	wire [31:0]regi1;
	assign regi1 = SingleCycle.datapath_SingleCycle.regfile.regfile[3];
	wire Ready;
	
	wire [31:0]memout;
   reg clk = 1;
   always @(clk)
      clk <= #5 ~clk;

   reg reset;
   initial begin
      reset = 1;
      @(posedge clk);
      @(posedge clk);
      @(posedge clk);
      #1;
      reset = 0;
   end

   initial
      $readmemh("fibtest.hex", SingleCycle.datapath_SingleCycle.insmem.ROM);

   parameter end_pc = 32'd48;
 
   integer j;
   always @(SingleCycle.Pc)
      if(SingleCycle.Pc >= end_pc) begin
         for(j=0; j<15; j=j+1) begin
            $write("%d ",SingleCycle.datapath_SingleCycle.datamem.RAM[16 + j]); // 32+ for iosort32
         end
			if( j % 16 == 1'b0)
				$write("\n");
         $stop;
      end
      
   Main_SingleCycle SingleCycle(
      .clk(clk), 
		.memout(memout), 
		.Pc(pc), 
		.Ready(Ready), 
		.reset(reset)
   );
endmodule


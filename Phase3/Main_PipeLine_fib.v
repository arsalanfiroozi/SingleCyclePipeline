`timescale 1ns / 1ps
module Main_PipeLine_fib;
	wire [31:0]pc,pcplus4;
	assign pc = PipeLine.datapath.PC;
	assign pcplus4 = PipeLine.datapath.PCPlus4;
	
	
	wire [31:0]instruction, instructiond;
	assign instruction = PipeLine.datapath.instruction;
	assign instructiond = PipeLine.datapath.instructiond;
	
	wire [1:0]forwardae, forwardbe;
	assign forwardae = PipeLine.datapath.forwardae;
	assign forwardbe = PipeLine.datapath.forwardbe;
	
	wire forwardad, forwardbd;
	assign forwardad = PipeLine.datapath.forwardad;
	assign forwardbd = PipeLine.datapath.forwardad;
	
	wire [31:0]srca, srcb;
	assign srca =  PipeLine.datapath.srca;
	assign srcb =  PipeLine.datapath.srcb;
	
	wire alusrce;
	assign alusrce =  PipeLine.datapath.alusrce;
	
	wire memwritem;
	assign memwritem = PipeLine.controller.memwritem;
	wire memwritee;
	assign memwritee = PipeLine.controller.memwritee;
	wire memwrited;
	assign memwrited = PipeLine.controller.memwrited;
	
	wire flushe;
	assign flushe = PipeLine.hazard.flushe;
	wire stalld, stallf;
	assign stalld = PipeLine.datapath.stalld;
	assign stallf = PipeLine.datapath.stallf;
	
	wire branchstall;
	assign branchstall = PipeLine.hazard.branchstall;
	
	wire branchd;
	assign branchd  = PipeLine.controller.branchd;
	wire pcsrcd;
	assign pcsrcd  = PipeLine.controller.pcsrcd;
	
	wire zero;
	assign zero = PipeLine.datapath.zero;
	
	wire [31:0]reg1, reg2;
	assign reg1 = PipeLine.datapath.reg1;
	assign reg2 = PipeLine.datapath.reg2;
	
	wire [31:0]d1,d2;
	assign d1 = PipeLine.datapath.d1;
	assign d2 = PipeLine.datapath.d2;
	
	wire [4:0]rsd, rtd, writerege;
	assign rsd = PipeLine.datapath.rsd;
	assign rtd = PipeLine.datapath.rtd;
	assign writerege = PipeLine.datapath.writereg;
	wire regwritee;
	assign regwritee = PipeLine.hazard.regwritee;
	
	wire [31:0]regt2, regt0, regt1, regt5;
	assign regt2 = PipeLine.datapath.regfile.regfile[10];
	assign regt0 = PipeLine.datapath.regfile.regfile[8];
	assign regt1 = PipeLine.datapath.regfile.regfile[9];
	assign regt5 = PipeLine.datapath.regfile.regfile[13];
	
	// Outputs
	wire [31:0] resultw;
	
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
      $readmemh("fibtest.hex", PipeLine.datapath.insmem.ROM);

   parameter end_pc = 32'd52;
 
   integer j;
   always @(PipeLine.datapath.PC)
      if(PipeLine.datapath.PC >= end_pc) begin
         for(j=0; j<15; j=j+1) begin
            $write("%d: %d ", j, PipeLine.datapath.datamem.RAM[16 + j]); // 32+ for iosort32
         end
			if( j % 16 == 1'b0)
				$write("\n");
         $stop;
      end
		
	Main_PipeLine PipeLine (
		.clk(clk), 
		.reset(reset), 
		.resultw(resultw)
	);
      
endmodule


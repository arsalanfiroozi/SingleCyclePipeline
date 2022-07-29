
`timescale 1ns/1ns

module fib_tb;
   integer file;
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
      $readmemh("fibtest.hex", SingleCycle.InstructionMemory.imem);

   parameter end_pc = 32'h54;
 
   integer i;
   always @(SingleCycle.pc)
      if(SingleCycle.pc == end_pc) begin
         for(i=0; i<15; i=i+1) begin
            $write("%x ", SingleCycle.DataMemory.dmem[16+i]);
            if(((i+1) % 16) == 0)
               $write("\n");
         end
         $stop;
      end
      
   MIPS SingleCycle(
      .clk(clk),
      .reset(reset)
   );


endmodule


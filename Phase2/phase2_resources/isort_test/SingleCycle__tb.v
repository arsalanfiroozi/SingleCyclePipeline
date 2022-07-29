
`timescale 1ns/1ns

module SingleCycle__tb;
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
      $readmemh("isort32.hex", SingleCycle.InstructionMemory.imem);

   parameter end_pc = 32'h78;
 
   integer i;
   always @(SingleCycle.PCF)
      if(SingleCycle.PCF == end_pc) begin
         for(i=0; i<96; i=i+1) begin
            $write("%x ", SingleCycle.DataMemory.dmem[32+i]); // 32+ for iosort32
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


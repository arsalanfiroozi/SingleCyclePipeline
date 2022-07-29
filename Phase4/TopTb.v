
`timescale 1 ns/ 1 ps
module TopTb();

integer i,HitNum = 0;

/*-----------------------------------------------------------------------------------------------
    				  Wires and registers
-------------------------------------------------------------------------------------------------*/
reg  clock, reset;								// clock , reset register
wire Hit;
wire [7:0]MemSysOut, pdata;
wire [5:0]address;
wire write, memwriteen;
wire [13:0]way1;
wire [13:0]way2;


assign way1 = t1.memorysystem.cache.way1[5];
assign way2 = t1.memorysystem.cache.way2[5];

assign pdata = t1.Data;
assign write = t1.RWB;
assign memwriteen = t1.memorysystem.memwriteen;
wire [7:0]cacheout, ramout;
assign cacheout = t1.memorysystem.readdata1;
assign ramout = t1.memorysystem.memdata;

/*-----------------------------------------------------------------------------------------------
    				  Generating Reset and Clock
-------------------------------------------------------------------------------------------------*/
initial  				// meghdar dahi avalie reset va clock 
     begin
	clock = 1'b0 ;
     end

always 					// sakhtan clock be dore 20ns 
     begin
	#5 clock = 1 ;
	#5 clock = 0 ;
     end

	 


initial                                                
begin                                                  
    reset=1;
	@(posedge clock);
	reset=0;
	for(i=0;i<100;i=i+1)begin
		@(posedge clock);
		#1;
		HitNum=HitNum+Hit;
		$display("%d\n", MemSysOut);
	end
	$display("The Number of Hits is: %d", HitNum);
	$stop;
	
end   
                                          
                       
Main_Cache t1(.clk(clock),.reset(reset),.hit(Hit),.readdata(MemSysOut), .Address(address));
                                                
endmodule


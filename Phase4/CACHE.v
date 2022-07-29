`timescale 1ns / 1ps
module CACHE(clk, reset, hit, cacheaddress, readdata, writeen, writedata, memreadaddress, memwriteaddress, memwriteen, memreaden, memdata, memwritedata);
	input wire clk, reset, writeen;
	output wire hit;
	input wire [5:0]cacheaddress;
	input wire [7:0]writedata, memdata;
	output wire [7:0]readdata;

	output reg [5:0]memwriteaddress;
	output wire [5:0]memreadaddress;
	output reg [7:0]memwritedata;
	output wire memreaden;
	output reg memwriteen;

	wire hit_w1, hit_w2;
	reg [13:0]way1 [7:0];
	reg [13:0]way2 [7:0];
	
	assign hit_w1 = way1[cacheaddress[2:0]][13] && (way1[cacheaddress[2:0]][10:8] == cacheaddress[5:3]);
	assign hit_w2 = way2[cacheaddress[2:0]][13] && (way2[cacheaddress[2:0]][10:8] == cacheaddress[5:3]);
	assign hit = hit_w1 || hit_w2;

	assign readdata = (hit_w1)?way1[cacheaddress[2:0]][7:0]:((hit_w2)?way2[cacheaddress[2:0]][7:0]:8'hzz);
	
	assign memreaden = (!hit) && (!writeen);
	
	assign memreadaddress = cacheaddress;
	
	always @(*)
	begin
		
			if(!hit)  // write & not in the cache
			begin
				if(way1[cacheaddress[2:0]][11])
				begin
					if(way2[cacheaddress[2:0]][12])
					begin
						memwriteen = 1'b1;
						memwriteaddress = {way2[cacheaddress[2:0]][10:8], cacheaddress[2:0]};
						memwritedata = way2[cacheaddress[2:0]][7:0];
					end 
					else
					begin
						memwriteen = 1'b0;
						memwriteaddress = 6'hxx;
						memwritedata = 8'h00;
					end
				end
				else
				begin
					if(way1[cacheaddress[2:0]][12])
					begin
						memwriteen = 1'b1;
						memwriteaddress = {way1[cacheaddress[2:0]][10:8], cacheaddress[2:0]};
						memwritedata = way1[cacheaddress[2:0]][7:0];
					end
					else
					begin
						memwriteen = 1'b0;
						memwriteaddress = 6'hxx;
						memwritedata = 8'h00;
					end
				end
			end
			else
			begin
				memwriteen = 1'b0;
				memwriteaddress = 6'hxx;
				memwritedata = 8'h00;
			end
		
	end
	
	integer i;
	always @(posedge clk)
	begin
		if(reset)
			for(i=0; i<=7; i=i+1)
			begin
				way1[i][13:0] <= 14'h0000;
				way2[i][13:0] <= 14'h0000;
			end
		else
		if(writeen)
		begin
			if(hit)
			begin
				if(hit_w1)
				begin
					way1[cacheaddress[2:0]][7:0] <= writedata;
					way1[cacheaddress[2:0]][10:8] <= cacheaddress[5:3];
					way1[cacheaddress[2:0]][13] <= 1'b1; // valid bit
					way1[cacheaddress[2:0]][12] <= 1'b1; // dirty bit
					way1[cacheaddress[2:0]][11] <= 1'b1; // Used bit
					way2[cacheaddress[2:0]][11] <= 1'b0;
				end
				else
				begin
					way2[cacheaddress[2:0]][7:0] <= writedata;
					way2[cacheaddress[2:0]][10:8] <= cacheaddress[5:3];
					way2[cacheaddress[2:0]][13] <= 1'b1;
					way2[cacheaddress[2:0]][12] <= 1'b1;
					way2[cacheaddress[2:0]][11] <= 1'b1;
					way1[cacheaddress[2:0]][11] <= 1'b0;
				end
			end
			else
			begin
				if(way1[cacheaddress[2:0]][11])
				begin
					way2[cacheaddress[2:0]][7:0] <= writedata;
					way2[cacheaddress[2:0]][10:8] <= cacheaddress[5:3];
					way2[cacheaddress[2:0]][13] <= 1'b1;
					way2[cacheaddress[2:0]][12] <= 1'b1;
					way2[cacheaddress[2:0]][11] <= 1'b1;
					way1[cacheaddress[2:0]][11] <= 1'b0;
				end
				else
				begin
					way1[cacheaddress[2:0]][7:0] <= writedata;
					way1[cacheaddress[2:0]][10:8] <= cacheaddress[5:3];
					way1[cacheaddress[2:0]][13] <= 1'b1;
					way1[cacheaddress[2:0]][12] <= 1'b1;
					way1[cacheaddress[2:0]][11] <= 1'b1;
					way2[cacheaddress[2:0]][11] <= 1'b0;
				end
			end
		end
		else // Simple Read
		begin
			if(hit_w1)
			begin
				way1[cacheaddress[2:0]][13] <= 1'b1; // valid bit
				way1[cacheaddress[2:0]][11] <= 1'b1;
				way2[cacheaddress[2:0]][11] <= 1'b0;
			end
			else if(hit_w2)
			begin
				way2[cacheaddress[2:0]][13] <= 1'b1; //valid bit
				way1[cacheaddress[2:0]][11] <= 1'b0;
				way2[cacheaddress[2:0]][11] <= 1'b1;
			end
			else
			begin
				if(way1[cacheaddress[2:0]][11])
				begin
					way2[cacheaddress[2:0]][7:0] <= memdata;
					way2[cacheaddress[2:0]][10:8] <= cacheaddress[5:3];
					way2[cacheaddress[2:0]][13] <= 1'b1;
					way2[cacheaddress[2:0]][12] <= 1'b1;
					way2[cacheaddress[2:0]][11] <= 1'b1;
					way1[cacheaddress[2:0]][11] <= 1'b0;
				end
				else
				begin
					way1[cacheaddress[2:0]][7:0] <= memdata;
					way1[cacheaddress[2:0]][10:8] <= cacheaddress[5:3];
					way1[cacheaddress[2:0]][13] <= 1'b1;
					way1[cacheaddress[2:0]][12] <= 1'b1;
					way1[cacheaddress[2:0]][11] <= 1'b1;
					way2[cacheaddress[2:0]][11] <= 1'b0;
				end
			end
		end
	end
	
endmodule

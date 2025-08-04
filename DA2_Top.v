
module DA2_Top (input clk, rst, update, 
                input [11:0] value0,valuel,
                output [1:0] SDATA,
                output SYNC, SCLK);
                
wire SCLK_en;

da2_dual uut1(clk,rst,SCLK,SDATA,SYNC,SCLK_en,2'b00,2'b00,value0,valuel,update);

clkDiv25en uut2(clk,rst,SCLK_en,SCLK);

endmodule
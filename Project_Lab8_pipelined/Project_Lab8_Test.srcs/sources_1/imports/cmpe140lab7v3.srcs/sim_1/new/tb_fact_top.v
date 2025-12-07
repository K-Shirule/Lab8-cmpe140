`timescale 1ns / 1ps

module tb_fact_top;
    reg     [1:0]   A_tb;
    reg             WE_tb;
    reg     [3:0]   WD_tb;
    reg             Rst_tb;
    reg             Clk_tb;
    wire    [31:0]  RD_tb;
    integer i;

    always begin
       Clk_tb = 0; #1;
       Clk_tb = 1; #1;
    end   

    
    fact_top DUT1 (
        .A(A_tb),
        .WE(WE_tb),
        .WD(WD_tb),
        .Rst(Rst_tb),
        .Clk(Clk_tb),
        .RD(RD_tb)
    );

    initial begin
       Rst_tb = 1;
       #2;
       Rst_tb = 0;
       
       A_tb = 2'b00;
       WE_tb = 1'b1;
       WD_tb = 4'b0100;
       #2
       
       A_tb = 2'b01;
       WD_tb = 4'b1;
       #2;
              
       WE_tb = 1'b0;
       #10
       A_tb = 2'b10;
       #4;
       A_tb = 2'b11;
       #2;
        #10;      
       
       
      $finish();
    end
endmodule
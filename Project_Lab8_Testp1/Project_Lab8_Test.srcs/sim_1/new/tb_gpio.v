`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2025 12:20:00 AM
// Design Name: 
// Module Name: tb_gpio
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_gpio;
    
    reg     [1:0]   A_tb;
    reg             WE_tb;
    reg     [31:0]  gpI1_tb;
    reg     [31:0]  gpI2_tb;
    reg     [31:0]  WD_tb;
    reg             rst_tb;  
    reg             clk_tb;

    //outputs
    wire [31:0] RD_tb;
    wire [31:0] gpO1_tb;
    wire [31:0] gpO2_tb;
   
    gpio_top DUT1(
        .A(A_tb),
        .WE(WE_tb),
        .gpI1(gpI1_tb),
        .gpI2(gpI2_tb),
        .WD(WD_tb),
        .Rst(rst_tb),
        .Clk(clk_tb),
        .gpO1(gpO1_tb),
        .gpO2(gpO2_tb),
        .RD(RD_tb)
    );   
       
    always
        begin 
           clk_tb = 0; #1; // Set bit 1 --> 0 after 5 time units
           clk_tb = 1; #1;
        end

    initial begin
        begin
            rst_tb = 1;
            #2;
            rst_tb = 0;
        
            WE_tb = 1'b1;
            
            WD_tb = 1;
            gpI1_tb = 4;
            gpI2_tb = 2;
            
            A_tb = 2'b00;
            #2;
            
            A_tb = 2'b01;
            #2;
            
            A_tb = 2'b10;
            #2;
            
            A_tb = 2'b11;
            #2;
            $finish();
        end
    end
endmodule
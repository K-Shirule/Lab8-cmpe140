`timescale 1ns / 1ps

module fact(input clk, input GO, input reset, input[3:0] N,
output [1:0] current, output ERROR, DONE, output [31:0] factorial);

    wire [4:0] CU_signals;
    wire [1:0] DP_signals;
    CU control1(.CMP1(DP_signals[1]), .CMP12(DP_signals[0]), .GO(GO), .clk(clk), .reset(reset), .DONE(DONE), .ERROR(ERROR), .CU_signals(CU_signals), .current(current));
    DP datapath1(.N(N), .CU_signals(CU_signals), .clk(clk), .factorial(factorial), .CMP12(DP_signals[0]), .CMP1(DP_signals[1]));  
   
endmodule


`timescale 1ns / 1ps

module regdff(output reg [31:0] Q, input [31:0] D, input load_reg, input clk);
    always @(posedge clk)
    if (load_reg) Q <= D;    
endmodule

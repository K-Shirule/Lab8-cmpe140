`timescale 1ns / 1ps

module fact_mux(output [31:0] out, input [31:0] A, input [31:0] B, input sel); 
//1 selects A, 0 selects B
    assign out = sel ? A : B;
endmodule


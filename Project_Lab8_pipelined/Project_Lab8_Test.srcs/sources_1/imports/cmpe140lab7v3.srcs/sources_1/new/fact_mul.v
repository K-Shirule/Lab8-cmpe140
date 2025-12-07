`timescale 1ns / 1ps

module fact_mul(output [31:0] Z, input [3:0] X, input [31:0] Y);
    assign Z = X * Y;
endmodule


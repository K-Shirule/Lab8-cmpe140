`timescale 1ns / 1ps

module cmp(output reg GT, input [3:0] A, B);
always @(*) begin
    if (A > B)
        GT = 1'b1;
    else
        GT = 1'b0;
end
endmodule


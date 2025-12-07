`timescale 1ns / 1ps

module gpio_reg #(parameter w = 32) (
        input wire [w-1:0] D,
        input wire Clk, Rst,
        input wire Load_Reg,
        output reg [w-1:0] Q
    );
    
    always @ (posedge Clk, posedge Rst) begin
        if (Rst)
            Q <= 0;
        else if (Load_Reg)
            Q <= D;
        else 
            Q <= Q;
    end
endmodule

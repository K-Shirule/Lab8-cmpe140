`timescale 1ns / 1ps

module cnt(output reg [3:0] Q, input[3:0] D, input Load_cnt, input en, input clk);
always@(posedge clk) begin
    if(Load_cnt)begin
        Q <= D;
    end
    else begin
        if(en)
            Q <= Q-1;
        else
            Q <= Q;
    end 
end
endmodule


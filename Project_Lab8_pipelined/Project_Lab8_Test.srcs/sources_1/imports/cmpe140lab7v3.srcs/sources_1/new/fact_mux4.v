`timescale 1ns / 1ps

module fact_mux4(
        input wire [1:0] RdSel,
        input wire [3:0] n,
        input wire Go,
        input wire ResDone, ResErr,
        input wire [31:0] Result,
        output reg [31:0] RD
    );
    
    always @ (*) begin
        case (RdSel)
            2'b00: RD = {{(32-4){1'b0}}, n}; //31:4
            2'b01: RD = {{31{1'b0}}, Go};  //31:1
            2'b10: RD = {{30{1'b0}}, ResErr, ResDone}; //31:2
            2'b11: RD = Result; //31:0
            default: RD = {31{1'bx}};
        endcase
    end
endmodule

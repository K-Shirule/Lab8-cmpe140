`timescale 1ns / 1ps

module SoC_mux4(
        input wire [31:0] DMemData, FactData, GPIOData,
        input wire [1:0] RdSel,
        output reg [31:0] ReadData     
    );
    
    always @ (*) begin
        case (RdSel)
            2'b00: ReadData = DMemData;
            2'b01: ReadData = DMemData;
            2'b10: ReadData = FactData;
            2'b11: ReadData = GPIOData;
            default: ReadData = {31{1'bx}};
        endcase
    end
endmodule

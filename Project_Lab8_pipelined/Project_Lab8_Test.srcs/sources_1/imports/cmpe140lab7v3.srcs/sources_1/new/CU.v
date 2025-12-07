`timescale 1ns / 1ps

module CU(input CMP1, CMP12, GO, clk, reset,
output reg DONE, reg ERROR, reg [4:0] CU_signals, reg [1:0] current);

    reg [1:0] next;
    
    always@(posedge clk, posedge reset) begin
        if(reset)
            current <= 2'b00;
        else
            current <= next;            
    end
    
    always@(*) begin
        CU_signals = 5'b00000;
        DONE = 0; ERROR = 0;
        case(current)
            2'b00: begin
                if(GO)
                    next = 2'b01;
                else
                    next = 2'b00;
            end
            
            2'b01: begin
                if(CMP12) begin
                    next = 2'b00;
                    ERROR = 1;
                end
                else
                    next = 2'b10;
            end
            
            2'b10: begin
                CU_signals = 5'b01101;
                next = 2'b11;
            end
            
            2'b11: begin
                if(CMP1) begin
                    next = 2'b11;
                    CU_signals = 5'b00110;
                end
                else begin
                    next = 2'b11;
                    CU_signals = 5'b10000;
                    DONE = 1;
                end
            end
        endcase
    end

endmodule

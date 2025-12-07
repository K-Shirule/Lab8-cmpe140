`timescale 1ns / 1ps

module fact_and(
        input wire a, b,
        output c
    );
       
    assign c = a & b;
    
endmodule

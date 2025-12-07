`timescale 1ns / 1ps

module DP(input [3:0] N, input[4:0] CU_signals, input clk,
output [31:0] factorial, output CMP12, CMP1);
    
    wire [3:0] counter_op;
    wire [31:0] product;
    wire [31:0] register_output;
    wire [31:0] register_input;
    
    cmp cmp1(.GT(CMP12), .A(N), .B(4'b1100));
    
    //To check if it is negative we will reuse the greater than 12 logic since both should return an error
    //for this to work we also have to make sure everyhting is dealt as signed inputs
    //by adding the signed keyword where applicable
    //cmp cmp3(.GT(CMP12), .A(0), .B(N));
    
    cnt cnt1(.Q(counter_op), .D(N), .Load_cnt(CU_signals[0]), .en(CU_signals[1]), .clk(clk));
    
    cmp cmp2(.GT(CMP1), .A(counter_op), .B(4'b0001));
    
    fact_mux mux1(.out(register_input), .A(32'b01), .B(product), .sel(CU_signals[3]));
    
    regdff reg1(.Q(register_output), .D(register_input), .load_reg(CU_signals[2]), .clk(clk));
    
    fact_mul mul1(.Z(product), .X(counter_op), .Y(register_output));
       
    fact_mux mux2(.out(factorial), .A(product), .B(32'b0), .sel(CU_signals[4]));
       
endmodule


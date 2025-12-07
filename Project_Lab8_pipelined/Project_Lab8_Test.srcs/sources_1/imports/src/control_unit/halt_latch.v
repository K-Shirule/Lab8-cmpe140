module halt_latch (
    input wire rst,
    input wire halt,
    output reg halted
);

// always 

always @(rst, halt) begin
    if(rst) halted = 0;
    else if(halt == 1'b1) halted = 1'b1;
end

endmodule
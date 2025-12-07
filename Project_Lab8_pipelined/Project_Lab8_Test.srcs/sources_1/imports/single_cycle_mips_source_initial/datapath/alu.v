module alu (
        input  wire [3:0]  op,
        input  wire [31:0] a,
        input  wire [31:0] b,
        input  wire [4:0]  shmt,
        input  wire clk,
        output wire        zero,
        output reg  [31:0] y
    );

    reg [63:0] multiplier_register;

    assign zero = (y == 0);

    always @ (posedge clk) begin
        if(op == 4'b1100) begin
            multiplier_register = a * b;
        end
    end

    always @ (op, a, b) begin
        case (op)
            4'b0000: y = a & b;
            4'b0001: y = a | b;
            4'b0010: y = a + b;
            4'b0110: y = a - b;
            4'b0111: y = (a < b) ? 1 : 0;
            4'b1000: y = a << shmt;
            4'b1001: y = a >> shmt;

            4'b1010: y = multiplier_register[63:32];
            4'b1011: y = multiplier_register[31:0];

            4'b1111: y = a; // Pass through

            default: y = 32'hXXXX_XXXX;
        endcase
    end

endmodule
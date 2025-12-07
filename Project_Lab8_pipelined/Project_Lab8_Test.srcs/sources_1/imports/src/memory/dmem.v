 module dmem (
        input  wire        clk,
        input  wire        we,
        input  wire [31:0]  a,
        input  wire [31:0] d,
        output wire [31:0] q
    );

    wire [5:0] shifted_address;
    assign shifted_address = a[7:2];

    reg [31:0] ram [0:63];

    integer n;

    initial begin
        for (n = 0; n < 64; n = n + 1) ram[n] = 32'hFFFFFFFF;
    end
    
    always @ (posedge clk) begin
        if (we) ram[shifted_address] <= d;
    end

    assign q = ram[shifted_address];
    
endmodule
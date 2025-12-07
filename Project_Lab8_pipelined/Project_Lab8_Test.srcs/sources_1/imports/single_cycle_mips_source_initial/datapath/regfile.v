module regfile (
        input  wire        clk,
        input  wire        we,
        input  wire [4:0]  ra1,
        input  wire [4:0]  ra2,
        input  wire [4:0]  ra3,
        input  wire [4:0]  wa,
        input  wire [31:0] wd,
        output wire [31:0] rd1,
        output wire [31:0] rd2,
        output wire [31:0] rd3
    );

    reg [31:0] rf [0:31];

    integer n;
    
    initial begin
        for (n = 0; n < 32; n = n + 1) rf[n] = 32'h0;
        rf[29] = 32'h100; // Initialze $sp
    end
    
    always @ (posedge clk) begin
        if (we) rf[wa] <= wd;
    end

    assign rd1 = (ra1 == 0) ? 0 : rf[ra1];
    assign rd2 = (ra2 == 0) ? 0 : rf[ra2];
    assign rd3 = (ra3 == 0) ? 0 : rf[ra3];

    
    wire [31:0] v0, v1, a0, a1, a2, a3, t0, t1, t2, t3, t4, t5, t6, t7, s0, s1, s2, s3, s4, s5, s6, s7, t8, t9, k0, k1, gp, sp, fp, ra;

    assign v0 = rf[2];
    assign v1 = rf[3];
    assign a0 = rf[4];
    assign a1 = rf[5];
    assign a2 = rf[6];
    assign a3 = rf[7];
    assign t0 = rf[8];
    assign t1 = rf[9];
    assign t2 = rf[10];
    assign t3 = rf[11];
    assign t4 = rf[12];
    assign t5 = rf[13];
    assign t6 = rf[14];
    assign t7 = rf[15];
    assign s0 = rf[16];
    assign s1 = rf[17];
    assign s2 = rf[18];
    assign s3 = rf[19];
    assign s4 = rf[20];
    assign s5 = rf[21];
    assign s6 = rf[22];
    assign s7 = rf[23];
    assign t8 = rf[24];
    assign t9 = rf[25];
    assign k0 = rf[26];
    assign k1 = rf[27];
    assign gp = rf[28];
    assign sp = rf[29];
    assign fp = rf[30];
    assign ra = rf[31];
    

    // initial begin
    //     // $dumpfile("mips.vcd");
    //     $dumpvars(0, rf[7]);
    //     $dumpvars(0, rf[8]);
    //     $dumpvars(0, rf[3]);
    //     $dumpvars(0, rf[31]);
    //     $dumpvars(0, rf[16]);
    //     $dumpvars(0, rf[4]);
    //     $dumpvars(0, rf[2]);
    //     $dumpvars(0, rf[29]);
    // end

endmodule
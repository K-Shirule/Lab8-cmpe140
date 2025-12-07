module datapath (
        input  wire        clk,
        input  wire        rst,
        input  wire        branch,
        input  wire        jump,
        input  wire        reg_dst,
        input  wire        we_reg,
        input  wire        alu_src,
        input  wire        dm2reg,
        input  wire        enable_write_return_addr,
        input  wire        enable_register_jump,
        input  wire [3:0]  alu_ctrl,
        input  wire [4:0]  ra3,
        input  wire [31:0] instr,
        input  wire [31:0] rd_dm,
        output wire [31:0] pc_current,
        output wire [31:0] alu_out,
        output wire [31:0] wd_dm,
        output wire [31:0] rd3
    );

    wire [4:0]  rf_wa;
    wire        pc_src;
    wire [31:0] pc_plus4;
    wire [31:0] pc_pre;
    wire [31:0] pc_next;
    wire [31:0] sext_imm;
    wire [31:0] ba;
    wire [31:0] bta;
    wire [31:0] jta;
    wire [31:0] jta_from_instruction;
    wire [31:0] alu_pa;
    wire [31:0] alu_pb;
    wire [31:0] wd_rf;
    wire        zero;

    assign pc_src = branch & zero;
    assign ba = {sext_imm[29:0], 2'b00};
    assign jta_from_instruction = {pc_plus4[31:28], instr[25:0], 2'b00};
    
    // --- PC Logic --- //
    dreg pc_reg (
            .clk            (clk),
            .rst            (rst),
            .d              (pc_next),
            .q              (pc_current)
        );

    adder pc_plus_4 (
            .a              (pc_current),
            .b              (32'd4),
            .y              (pc_plus4)
        );

    adder pc_plus_br (
            .a              (pc_plus4),
            .b              (ba),
            .y              (bta)
        );


    mux2 #(32) pc_branch_result_mux (
            .sel            (pc_src),
            .a              (pc_plus4),
            .b              (bta),
            .y              (pc_pre)
        );
        
    mux4 #(32) pc_src_mux (
        .sel    ({enable_register_jump, jump}),
        .a      (pc_pre),
        .b      (jta_from_instruction),
        .c      (alu_pa),
        .d      (32'hXXXX_XXXX),
        .y      (pc_next)
    );
    
    wire [4:0] rf_wa_intermediate;
    // --- RF Logic --- //
    mux2 #(5) rf_wa_intermediate_mux (
            .sel            (reg_dst),
            .a              (instr[20:16]),
            .b              (instr[15:11]),
            .y              (rf_wa_intermediate)
        );

    wire [4:0] RETURN_ADDRESS_REGISTER;
    assign RETURN_ADDRESS_REGISTER = 5'b11111;

    mux2 #(5) rf_wa_return_address_mux (
        .sel                (enable_write_return_addr),
        .a                  (rf_wa_intermediate),
        .b                  (RETURN_ADDRESS_REGISTER),
        .y                  (rf_wa)
    );


    regfile rf (
            .clk            (clk),
            .we             (we_reg),
            .ra1            (instr[25:21]),
            .ra2            (instr[20:16]),
            .ra3            (ra3),
            .wa             (rf_wa),
            .wd             (wd_rf),
            .rd1            (alu_pa),
            .rd2            (wd_dm),
            .rd3            (rd3)
        );

    signext se (
            .a              (instr[15:0]),
            .y              (sext_imm)
        );

    // --- ALU Logic --- //
    mux2 #(32) alu_pb_mux (
            .sel            (alu_src),
            .a              (wd_dm),
            .b              (sext_imm),
            .y              (alu_pb)
        );

    alu alu (
            .op             (alu_ctrl),
            .a              (alu_pa),
            .b              (alu_pb),
            .shmt           (instr[10:6]),
            .zero           (zero),
            .y              (alu_out),
            .clk            (clk)
        );


    wire [31:0] wd_rf_intermediate;
    // --- MEM Logic --- //
    mux2 #(32) rf_wd_intermediate_mux (
            .sel            (dm2reg),
            .a              (alu_out),
            .b              (rd_dm),
            .y              (wd_rf_intermediate)
        );

    mux2 #(32) rf_wd_pc_return_address_mux (
            .sel            (enable_write_return_addr),
            .a              (wd_rf_intermediate),
            .b              (pc_plus4),
            .y              (wd_rf)
        );

endmodule
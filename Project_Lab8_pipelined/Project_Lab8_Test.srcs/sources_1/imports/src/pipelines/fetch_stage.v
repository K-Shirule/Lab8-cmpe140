module fetch_stage (
    input wire clk,
    input wire rst,
    output wire [63:0] stage_output,

    output wire [31:0] instruction_memory_address,
    input wire [31:0] instruction_memory_read_data,

    input wire [31:0] jump_target,
    input wire should_jump,

    input wire [31:0] branch_target,
    input wire should_branch,
    input wire stall
);

    wire [31:0] instruction;
    wire [31:0] pc_current, pc_next, pc_src;
    
    dreg pc_reg (
            .clk            (clk),
            .rst            (rst),
            .d              (pc_next),
            .q              (pc_current)
        );

    mux2 #(32) pc_stall_mux (
        .sel    (stall),
        .a      (pc_src),
        .b      (pc_current),
        .y      (pc_next)
    );

    assign instruction_memory_address = pc_current;
    assign instruction = instruction_memory_read_data;

    wire [31:0] pc_plus4;

    adder pc_plus_4 (
            .a              (pc_current),
            .b              (32'd4),
            .y              (pc_plus4)
        );

    
    mux4 #(32) pc_src_mux (
        .sel    ({ should_jump, should_branch }),
        .a      (pc_plus4),
        .b      (branch_target),
        .c      (jump_target),
        .d      (32'hXX_XX_XX_XX),
        .y      (pc_src)
    );

    assign stage_output = { instruction, pc_plus4 };
endmodule

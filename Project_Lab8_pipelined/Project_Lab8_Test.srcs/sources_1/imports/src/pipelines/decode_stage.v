module decode_stage (
    input wire [63:0] stage_input,
    output wire [191:0] stage_output,

    output wire [4:0] reg_a1_select,
    output wire [4:0] reg_a2_select,

    input wire [31:0] reg_a1_output,
    input wire [31:0] reg_a2_output,

    output wire [31:0] jump_target,
    output wire should_jump,

    output wire [31:0] branch_target,
    output wire should_branch
);
    wire [31:0] pc_plus4, bta;
    wire [31:0] instruction;
    assign { instruction, pc_plus4 } = stage_input;
    wire [15:0] control_signals;

    wire [15:0] hazard_control_signals;

    controlunit cu (
        .instruction(instruction),
        .control_signals(control_signals[13:0])
    );

    hazard_control_decoder _hazard_control_decoder (
        .instruction    (instruction),
        .hazard_control_signals (hazard_control_signals[14:0])
    );

    wire [3:0] alu_ctrl;
    assign { halt, branch, jump, reg_dst, we_reg, alu_src, we_dm, dm2reg, alu_ctrl, enable_write_return_addr, enable_register_jump } = control_signals[13:0];

    assign should_jump = jump | enable_register_jump;
    wire [31:0] jump_target_from_instruction;
    assign jump_target_from_instruction = {pc_plus4[31:28], instruction[25:0], 2'b00};

    mux2 #(32) jump_target_mux (
        .sel    (enable_register_jump),
        .a      (jump_target_from_instruction),
        .b      (reg_a1_output),
        .y      (jump_target)
    );

    wire [31:0] sign_extended_immediate;
    signext se (
            .a (instruction[15:0]),
            .y (sign_extended_immediate)
        );
    
    adder pc_plus_br (
            .a              (pc_plus4),
            .b              (sign_extended_immediate),
            .y              (bta)
        );

    
    assign reg_a1_select = instruction[25:21];
    assign reg_a2_select = instruction[20:16];


    adder branch_target_adder (
            .a              (pc_plus4),
            .b              ({sign_extended_immediate[29:0], 2'b00}),
            .y              (branch_target)
        );
    assign should_branch = branch & zero;
    assign zero = (reg_a1_output == 0);

    assign stage_output = { 
        pc_plus4,                   // 32
        control_signals,            // 16
        sign_extended_immediate,    // 32
        instruction,                 // 32
        reg_a1_output,                 // 32
        reg_a2_output,                  // 32
        hazard_control_signals         // 16
    }; // 112
endmodule
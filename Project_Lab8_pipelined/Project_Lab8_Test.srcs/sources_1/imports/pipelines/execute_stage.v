module execute_stage (
    input clk,
    input wire [191:0] stage_input,
    output wire [159:0] stage_output
);
    wire [31:0] pc_plus4, sign_extended_immediate, instruction, reg_a1_output, reg_a2_output;
    wire [15:0] control_signals, hazard_control_signals;

    assign { 
        pc_plus4,                   // 32
        control_signals,            // 16
        sign_extended_immediate,    // 32
        instruction,                 // 32
        reg_a1_output,                 // 32
        reg_a2_output,                  // 32
        hazard_control_signals         // 16
    } = stage_input;

    // wire halt, branch, jump, reg_dst, we_reg, alu_src, we_dm, dm2reg, enable_write_return_addr, enable_register_jump;
    wire [3:0] alu_ctrl;
    // assign { halt, branch, jump, reg_dst, we_reg, alu_src, we_dm, dm2reg, alu_ctrl, enable_write_return_addr, enable_register_jump } = control_signals[13:0];

    assign  { halt, branch, jump, reg_dst, we_reg, alu_src, we_dm, dm2reg, alu_ctrl, enable_write_return_addr, enable_register_jump } = control_signals[13:0];

    wire [31:0] alu_b_input;

    wire [31:0] alu_out;

    // --- ALU Logic --- //
    mux2 #(32) alu_b_input_mux (
            .sel            (alu_src),
            .a              (reg_a2_output),
            .b              (sign_extended_immediate),
            .y              (alu_b_input)
        );

    alu alu (
            .op             (alu_ctrl),
            .a              (reg_a1_output),
            .b              (alu_b_input),
            .shmt           (instruction[10:6]),
            .y              (alu_out),
            .clk            (clk)
        );

    assign stage_output = {
        pc_plus4,               // 32
        instruction,            // 32
        alu_out,                // 32
        control_signals,        // 16
        reg_a2_output,           // 32
        hazard_control_signals   // 16
    }; // 144

endmodule
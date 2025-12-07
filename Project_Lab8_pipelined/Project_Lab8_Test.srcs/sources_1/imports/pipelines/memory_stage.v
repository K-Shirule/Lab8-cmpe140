module memory_stage (
    input wire [159:0] stage_input,
    output wire [159:0] stage_output,

    output wire [31:0] data_memory_address_select,
    input wire [31:0] data_memory_read_data,
    output wire [31:0] data_memory_write_data,
    output wire data_memory_write_enable
);
    wire [31:0] pc_plus4, instruction, alu_out, reg_a2_output;
    wire [15:0] control_signals, hazard_control_signals;

    assign {
        pc_plus4,               // 32
        instruction,            // 32
        alu_out,                // 32
        control_signals,        // 16
        reg_a2_output,           // 32
        hazard_control_signals
    } = stage_input; // 128 + 16 = 144

    assign data_memory_write_data = reg_a2_output;
    wire halt, branch, jump, reg_dst, we_reg, alu_src, we_dm, dm2reg, enable_write_return_addr, enable_register_jump;
    wire [3:0] alu_ctrl;
    assign { halt, branch, jump, reg_dst, we_reg, alu_src, we_dm, dm2reg, alu_ctrl, enable_write_return_addr, enable_register_jump } = control_signals[13:0];
    assign data_memory_write_enable = we_dm;

    assign data_memory_address_select = alu_out;

    assign stage_output = {
        pc_plus4,                        // 32
        instruction,                    // 32
        data_memory_read_data,          // 32
        alu_out,                        // 32
        control_signals,                 // 16
        hazard_control_signals
    }; // 144
endmodule
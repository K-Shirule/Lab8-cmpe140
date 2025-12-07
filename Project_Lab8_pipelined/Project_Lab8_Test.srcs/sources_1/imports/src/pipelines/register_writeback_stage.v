module register_writeback_stage (
    input wire [159:0] stage_input,

    output wire [4:0] register_write_select,
    output wire [31:0] register_write_data,
    output wire register_write_enable,

    output wire halt
);

    wire [31:0] pc_plus4, instruction, data_memory_read_data, alu_out;
    wire [15:0] control_signals, hazard_control_signals;

    assign {
        pc_plus4,                        // 32
        instruction,                    // 32
        data_memory_read_data,          // 32
        alu_out,                        // 32
        control_signals,                 // 16
        hazard_control_signals
    } = stage_input; 

    wire branch, jump, reg_dst, alu_src, we_dm, data_memory_to_register, enable_write_return_addr, enable_register_jump;
    wire [3:0] alu_ctrl;
    assign { halt, branch, jump, reg_dst, register_write_enable, alu_src, we_dm, data_memory_to_register, alu_ctrl, enable_write_return_addr, enable_register_jump } = control_signals[13:0];

    wire [4:0] rf_wa_intermediate;
    // --- RF Logic --- //
    mux2 #(5) rf_wa_intermediate_mux (
            .sel            (reg_dst),
            .a              (instruction[20:16]),
            .b              (instruction[15:11]),
            .y              (rf_wa_intermediate)
        );

    wire [4:0] RETURN_ADDRESS_REGISTER;
    assign RETURN_ADDRESS_REGISTER = 5'b11111;

    mux2 #(5) rf_wa_return_address_mux (
        .sel                (enable_write_return_addr),
        .a                  (rf_wa_intermediate),
        .b                  (RETURN_ADDRESS_REGISTER),
        .y                  (register_write_select)
    );

    wire [31:0] register_write_data_intermediate;
    mux2 #(32) rf_wd_intermediate_mux (
            .sel            (data_memory_to_register),
            .a              (alu_out),
            .b              (data_memory_read_data),
            .y              (register_write_data_intermediate)
        );

    mux2 #(32) rf_wd_pc_return_address_mux (
            .sel            (enable_write_return_addr),
            .a              (register_write_data_intermediate),
            .b              (pc_plus4),
            .y              (register_write_data)
        );
endmodule
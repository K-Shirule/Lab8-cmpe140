module hazard_control (
    input [191:0] decode_stage_output,
    input [191:0] execute_stage_input,
    input [159:0] memory_stage_input,
    input [159:0] register_writeback_stage_input,

    input jump,
    input branch,

    output reg stall,
    output reg flush
);
    wire [4:0] decode_stage_register_read_a, decode_stage_register_read_b, decode_stage_register_write;
    wire [4:0] execute_stage_register_read_a, execute_stage_register_read_b, execute_stage_register_write;
    wire [4:0] memory_stage_register_read_a, memory_stage_register_read_b, memory_stage_register_write;
    wire [4:0] register_writeback_stage_register_read_a, register_writeback_stage_register_read_b, register_writeback_stage_register_write;

    decode_stage_hazard_decoder _decode_stage_hazard_decoder (
        .stage_output           (decode_stage_output),
        .hazard_control_signals ({ decode_stage_register_read_a, decode_stage_register_read_b, decode_stage_register_write })
    );

    execute_stage_hazard_decoder _execute_stage_hazard_decoder (
        .stage_input           (execute_stage_input),
        .hazard_control_signals ({ execute_stage_register_read_a, execute_stage_register_read_b, execute_stage_register_write })
    );

    memory_stage_hazard_decoder _memory_stage_hazard_decoder (
        .stage_input           (memory_stage_input),
        .hazard_control_signals ({ memory_stage_register_read_a, memory_stage_register_read_b, memory_stage_register_write })
    );

    register_writeback_stage_hazard_decoder _register_writeback_stage_hazard_decoder (
        .stage_input           (register_writeback_stage_input),
        .hazard_control_signals ({ register_writeback_stage_register_read_a, register_writeback_stage_register_read_b, register_writeback_stage_register_write })
    );

    always @(
        decode_stage_register_read_a,
        decode_stage_register_read_b,
        decode_stage_register_write,
        execute_stage_register_read_a, 
        execute_stage_register_read_b, 
        execute_stage_register_write, 
        memory_stage_register_read_a, 
        memory_stage_register_read_b, 
        memory_stage_register_write, 
        register_writeback_stage_register_read_a, 
        register_writeback_stage_register_read_b, 
        register_writeback_stage_register_write,

        jump,
        branch
    ) begin
        stall = 0;
        flush = 0;
        if(decode_stage_register_read_a != 0) begin
            if(decode_stage_register_read_a == execute_stage_register_write) begin
                stall = 1;
            end else if(decode_stage_register_read_a == memory_stage_register_write) begin
                stall = 1;
            end else if(decode_stage_register_read_a == register_writeback_stage_register_write) begin
                stall = 1;
            end
        end
        if(decode_stage_register_read_b != 0) begin
            if(decode_stage_register_read_b == execute_stage_register_write) begin
                stall = 1;
            end else if(decode_stage_register_read_b == memory_stage_register_write) begin
                stall = 1;
            end else if(decode_stage_register_read_b == register_writeback_stage_register_write) begin
                stall = 1;
            end
        end
        if(jump || branch) begin
            flush = 1;
        end
    end

endmodule

module decode_stage_hazard_decoder (
    input [191:0] stage_output,

    output [14:0] hazard_control_signals
);
    wire [31:0] pc_plus4, sign_extended_immediate, instruction, reg_a1_output, reg_a2_output;
    wire [15:0] control_signals, _hazard_control_signals;

    assign { 
        pc_plus4,                   // 32
        control_signals,            // 16
        sign_extended_immediate,    // 32
        instruction,                 // 32
        reg_a1_output,                 // 32
        reg_a2_output,                  // 32
        _hazard_control_signals         // 16
    } = stage_output;   

    assign hazard_control_signals = _hazard_control_signals[14:0];
endmodule

module execute_stage_hazard_decoder (
    input [191:0] stage_input,

    output [14:0] hazard_control_signals
);
    wire [31:0] pc_plus4, sign_extended_immediate, instruction, reg_a1_output, reg_a2_output;
    wire [15:0] control_signals, _hazard_control_signals;

    assign { 
        pc_plus4,                   // 32
        control_signals,            // 16
        sign_extended_immediate,    // 32
        instruction,                 // 32
        reg_a1_output,                 // 32
        reg_a2_output,                  // 32
        _hazard_control_signals         // 16
    } = stage_input;

    assign hazard_control_signals = _hazard_control_signals[14:0];
endmodule

module memory_stage_hazard_decoder (
    input [159:0] stage_input,

    output [14:0] hazard_control_signals
);
    wire [31:0] pc_plus4, instruction, alu_out, reg_a2_output;
    wire [15:0] control_signals, _hazard_control_signals;

    assign {
        pc_plus4,               // 32
        instruction,            // 32
        alu_out,                // 32
        control_signals,        // 16
        reg_a2_output,           // 32
        _hazard_control_signals
    } = stage_input; // 128 + 16 = 144

    assign hazard_control_signals = _hazard_control_signals[14:0];
endmodule



module register_writeback_stage_hazard_decoder (
    input [159:0] stage_input,

    output [14:0] hazard_control_signals
);
    wire [31:0] pc_plus4, instruction, data_memory_read_data, alu_out;
    wire [15:0] control_signals, _hazard_control_signals;

    assign {
        pc_plus4,                        // 32
        instruction,                    // 32
        data_memory_read_data,          // 32
        alu_out,                        // 32
        control_signals,                 // 16
        hazard_control_signals
    } = stage_input; 

    assign hazard_control_signals = _hazard_control_signals[14:0];
endmodule
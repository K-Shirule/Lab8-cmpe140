
module pipeline_register #(parameter REGISTER_WIDTH=32)
    (
        input wire clk,
        input wire rst,
        input wire [REGISTER_WIDTH-1:0] in, 
        output reg [REGISTER_WIDTH-1:0] out,

        input wire stall,
        input wire flush
    );

    initial begin
        out = 0;
    end

    always @(posedge clk, posedge rst) begin
        if(rst) out = 0;
        else if (flush) out = 0;
        else if(~stall) out = in;
    end
endmodule

module pipeline
    (
        input wire clk,
        input wire rst,

        input wire [4:0] ra3_select,
        output wire [31:0] ra3_data_read,

        output wire [31:0] data_memory_address_select,
        output wire [31:0] data_memory_write_data,
        output wire data_memory_write_enable,
        input wire [31:0] data_memory_read_data,

        output wire [31:0] instruction_memory_address_select,
        input wire [31:0] instruction_memory_read_data,

        output wire halted
    );

    wire [63:0] fetch_stage_output;
    wire [63:0] decode_stage_input;
    wire [191:0] decode_stage_output;
    wire [191:0] execute_stage_input;
    wire [159:0] execute_stage_output;
    wire [159:0] memory_stage_input;
    wire [159:0] memory_stage_output;
    wire [159:0] register_writeback_stage_input;

    wire should_jump;
    wire [31:0] jump_target;

    wire should_branch;
    wire [31:0] branch_target;


    wire [4:0] reg_a1_select;
    wire [4:0] reg_a2_select;

    wire [31:0] reg_a1_output;
    wire [31:0] reg_a2_output;

    wire [4:0] register_write_select;
    wire [31:0] register_write_data;
    wire register_write_enable;


    wire flush, stall;
    // assign {
    //     flush_instruction_stage, stall_instruction_stage,
    //     flush_decode_stage, stall_decode_stage,
    //     flush_execute_stage, stall_execute_stage 
    // } = hazard_control;

    regfile rf (
            .clk            (clk),
            .we             (register_write_enable),
            .ra1            (reg_a1_select),
            .ra2            (reg_a2_select),
            .ra3            (ra3_select),
            .wa             (register_write_select),
            .wd             (register_write_data),
            .rd1            (reg_a1_output),
            .rd2            (reg_a2_output),
            .rd3            (ra3_data_read)
        );

    fetch_stage fetch(
        clk,
        rst,
        fetch_stage_output,

        instruction_memory_address_select,
        instruction_memory_read_data,

        jump_target,
        should_jump,

        branch_target,
        should_branch,
        stall
    );

    pipeline_register #(64) fetch_decode_cache(
        clk,
        rst,
        fetch_stage_output,
        decode_stage_input,

        stall,
        flush
    );

    decode_stage decode(
        decode_stage_input,
        decode_stage_output,

        reg_a1_select,
        reg_a2_select,

        reg_a1_output,
        reg_a2_output,

        jump_target,
        should_jump,

        branch_target,
        should_branch
    );

    pipeline_register #(192) decode_execute_cache(
        clk,
        rst,
        decode_stage_output,
        execute_stage_input,

        1'b0,
        stall
    );

    execute_stage execute (
        clk,
        execute_stage_input,
        execute_stage_output
    );

    pipeline_register #(160) execute_memory_cache(
        clk,
        rst,
        execute_stage_output,
        memory_stage_input,

        1'b0,
        1'b0
    );

    memory_stage memory (
        memory_stage_input,
        memory_stage_output,

        data_memory_address_select,
        data_memory_read_data,
        data_memory_write_data,
        data_memory_write_enable
    );

    pipeline_register #(160) memory_writeback_cache(
        clk,
        rst,
        memory_stage_output,
        register_writeback_stage_input,

        1'b0,
        1'b0
    );

    wire halt;

    register_writeback_stage register_writeback(
        register_writeback_stage_input,

        register_write_select,
        register_write_data,
        register_write_enable,

        halt
    );



    halt_latch _halt_latch(
        rst,
        halt, 
        halted
    );


    hazard_control _hazard_control(
        decode_stage_output,
        execute_stage_input,
        memory_stage_input,
        register_writeback_stage_input,
        should_jump,
        should_branch,
        stall,
        flush
    );



endmodule





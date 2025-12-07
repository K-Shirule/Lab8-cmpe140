module mips (
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
    
    wire       branch;
    wire       jump;
    wire       reg_dst;
    wire       we_reg;
    wire       alu_src;
    wire       dm2reg;
    wire [3:0] alu_ctrl;

    wire        we_dm;
    wire [31:0] pc_current;
    wire [31:0] alu_out;
    wire [31:0] wd_dm;

    wire enable_write_return_addr;
    wire enable_register_jump;

    datapath dp (
            .clk            (clk),
            .rst            (rst),
            .branch         (branch),
            .jump           (jump),
            .reg_dst        (reg_dst),
            .we_reg         (we_reg),
            .alu_src        (alu_src),
            .dm2reg         (dm2reg),
            .alu_ctrl       (alu_ctrl),
            .ra3            (ra3_select),
            .instr          (instruction_memory_read_data),
            .rd_dm          (data_memory_read_data),
            .pc_current     (instruction_memory_address_select),
            .alu_out        (data_memory_address_select),
            .wd_dm          (data_memory_write_data),
            .rd3            (ra3_data_read),

            .enable_write_return_addr (enable_write_return_addr),
            .enable_register_jump (enable_register_jump)
        );


    wire [13:0] control_signals;
    assign { halt, branch, jump, reg_dst, we_reg, alu_src, we_dm, dm2reg, alu_ctrl, enable_write_return_addr, enable_register_jump } = control_signals;

    assign data_memory_write_enable = we_dm;

    halt_latch _halt_latch(
        rst,
        halt, 
        halted
    );

    controlunit cu (
            .instruction (instruction_memory_read_data),
            .control_signals (control_signals)
        );

endmodule
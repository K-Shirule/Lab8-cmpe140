module mips_top (
        input  wire        clk,
        input  wire        rst,
        input  wire [4:0]  ra3,
        output wire [31:0] rd3,

        output wire halted
    );


    wire [31:0] instruction_memory_address_select;
    wire [31:0] instruction_memory_read_data;

    wire [31:0] data_memory_address_select,
                data_memory_write_data,
                data_memory_read_data;
    wire data_memory_write_enable;

    pipeline mips (
            .clk            (clk),
            .rst            (rst),
            
            .ra3_select            (ra3),
            .ra3_data_read            (rd3),

            .data_memory_address_select(data_memory_address_select),
            .data_memory_write_data(data_memory_write_data),
            .data_memory_write_enable(data_memory_write_enable),
            .data_memory_read_data(data_memory_read_data),

            .instruction_memory_address_select(instruction_memory_address_select),
            .instruction_memory_read_data(instruction_memory_read_data),
            
            .halted(halted)
        );

    // mips mips (
    //         .clk            (clk),
    //         .rst            (rst),
            
    //         .ra3_select            (ra3),
    //         .ra3_data_read            (rd3),

    //         .data_memory_address_select(data_memory_address_select),
    //         .data_memory_write_data(data_memory_write_data),
    //         .data_memory_write_enable(data_memory_write_enable),
    //         .data_memory_read_data(data_memory_read_data),

    //         .instruction_memory_address_select(instruction_memory_address_select),
    //         .instruction_memory_read_data(instruction_memory_read_data),
            
    //         .halted(halted)
    //     );


    imem imem (
            .a              (instruction_memory_address_select),
            .y              (instruction_memory_read_data)
        );

    dmem dmem (
            .clk            (clk),
            .we             (data_memory_write_enable),
            .a              (data_memory_address_select),
            .d              (data_memory_write_data),
            .q              (data_memory_read_data)
        );

endmodule
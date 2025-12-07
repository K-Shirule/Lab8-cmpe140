`timescale 1ns / 1ps

module Single_Cyc_SoC (
        input wire clk,
        input wire rst,
        input wire [4:0] ra3,
        input wire [31:0] gpI1, gpI2,
        output wire we_dm,
        output wire [31:0] pc_current,
        output wire [31:0] instr,
        output wire [31:0] alu_out,
        output wire [31:0] wd_dm,
        output wire [31:0] rd_dm,
        output wire [31:0] rd3,
        output wire [31:0] gpO1, gpO2
    );

    wire WE1, WE2, WEM;
    wire [1:0] RdSel;
    wire [31:0] DMemData, FactData, GPIOData;

    pipeline mips (
            .clk(clk),
            .rst(rst),
            .ra3_select(ra3),
            .instruction_memory_read_data(instr),
            .data_memory_read_data(rd_dm),
            .data_memory_write_enable(we_dm),
            .instruction_memory_address_select(pc_current),
            .data_memory_address_select(alu_out),
            .data_memory_write_data(wd_dm),
            .ra3_data_read(rd3)
        );

    imem imem (
            .a(pc_current),
            .y(instr)
        );

    dmem dmem (
            .clk(clk),
            .we(WEM),
            .a(alu_out),
            .d(wd_dm),
            .q(DMemData)
        );
        
    SoC_ad SoC_ad (
            .WE(we_dm),
            .A(alu_out),
            .WE1(WE1),
            .WE2(WE2),
            .WEM(WEM),
            .RdSel(RdSel)
        );    
        
    SoC_mux4 SoC_mux4 (
            .DMemData(DMemData),
            .FactData(FactData),
            .GPIOData(GPIOData),
            .RdSel(RdSel),
            .ReadData(rd_dm)
        );
        
    fact_top factorial_accelerator (
            .A(alu_out[3:2]),
            .WE(WE1),
            .WD(wd_dm[3:0]),
            .Rst(rst),
            .Clk(clk),
            .RD(FactData)
        );    
       
    gpio_top gpio_module (
            .A(alu_out[3:2]),
            .WE(WE2),
            .gpI1(gpI1),
            .gpI2(gpI2),
            .WD(wd_dm),
            .Rst(rst),
            .Clk(clk),
            .gpO1(gpO1),
            .gpO2(gpO2),
            .RD(GPIOData)
        );    
endmodule
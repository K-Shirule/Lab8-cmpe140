module controlunit (
        input wire [31:0] instruction,
        output wire [13:0] control_signals,
        output wire [14:0] hazard_control_signals
    );
    
    wire [5:0] opcode;
    wire [5:0] funct;

    assign opcode = instruction[31:26];
    assign funct = instruction[5:0];

    wire [1:0] alu_op;
    wire [8:0] main_decoder_signals;
    wire [4:0] auxdec_control_signals;

    wire halt, branch, jump, reg_dst, we_reg, alu_src, we_dm, dm2reg, enable_write_return_addr;
    assign { halt, enable_write_return_addr, branch, jump, reg_dst, we_reg, alu_src, we_dm, dm2reg } = main_decoder_signals; 
    
    wire [3:0] alu_ctrl;
    wire enable_register_jump;
    assign {enable_register_jump, alu_ctrl} = auxdec_control_signals;

    maindec md (
        .opcode         (opcode),
        .main_decoder_signals(main_decoder_signals),
        .alu_op(alu_op)
    );

    auxdec ad (
        .alu_op         (alu_op),
        .funct          (funct),
        .auxdec_control_signals (auxdec_control_signals)
    ); 

    hazard_control_decoder _hazard_control_decoder (
        .instruction    (instruction),
        .hazard_control_signals (hazard_control_signals)
    );

    assign control_signals = { halt, branch, jump, reg_dst, we_reg, alu_src, we_dm, dm2reg, alu_ctrl, enable_write_return_addr, enable_register_jump };
endmodule
module maindec (
        input  wire [5:0] opcode,

        output wire [8:0] main_decoder_signals,
        output wire [1:0] alu_op
    );

    reg [10:0] ctrl;
    wire halt, branch, jump, reg_dst, we_reg, alu_src, we_dm, dm2reg, enable_write_return_addr;

    assign { halt, enable_write_return_addr, branch, jump, reg_dst, we_reg, alu_src, we_dm, dm2reg } = main_decoder_signals; 
    assign { main_decoder_signals, alu_op } = ctrl;

    always @ (opcode) begin
        case (opcode)
            6'b00_0000: ctrl = 11'b0_0_0_0_1_1_0_0_0_10; // R-type
            6'b00_1000: ctrl = 11'b0_0_0_0_0_1_1_0_0_00; // ADDI
            6'b00_0100: ctrl = 11'b0_0_1_0_0_0_0_0_0_01; // BEQ
            6'b00_0010: ctrl = 11'b0_0_0_1_0_0_0_0_0_00; // J
            6'b10_1011: ctrl = 11'b0_0_0_0_0_0_1_1_0_00; // SW
            6'b10_0011: ctrl = 11'b0_0_0_0_0_1_1_0_1_00; // LW
            6'b00_0011: ctrl = 11'b0_1_0_1_0_1_0_0_0_00; // JAL

            6'b11_1111: ctrl = 11'b1_x_x_x_x_x_x_x_x_xx;
            default:    ctrl = 11'b1_x_x_x_x_x_x_x_x_xx;
        endcase
    end

endmodule
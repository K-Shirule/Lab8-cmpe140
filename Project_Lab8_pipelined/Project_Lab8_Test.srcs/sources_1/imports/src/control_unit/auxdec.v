module auxdec (
        input  wire [1:0] alu_op,
        input  wire [5:0] funct,
        output reg [4:0] auxdec_control_signals
    );

    wire [3:0] alu_auxdec_control_signals;
    wire enable_register_jump;

    assign {enable_register_jump, alu_auxdec_control_signals} = auxdec_control_signals;

    always @ (alu_op, funct) begin
        case (alu_op)
            2'b00: auxdec_control_signals = 5'b00010;          // ADD
            2'b01: auxdec_control_signals = 5'b00110;          // SUB
            default: case (funct)
                6'b10_0100: auxdec_control_signals = 5'b00000; // AND
                6'b10_0101: auxdec_control_signals = 5'b00001; // OR
                6'b10_0000: auxdec_control_signals = 5'b00010; // ADD
                6'b10_0010: auxdec_control_signals = 5'b00110; // SUB
                6'b10_1010: auxdec_control_signals = 5'b00111; // SLT

                6'b00_0000: auxdec_control_signals = 5'b01000; // SLL
                6'b00_0010: auxdec_control_signals = 5'b01001; // SlR
                6'b01_1001: auxdec_control_signals = 5'b01100; // MULTU
                6'b01_0000: auxdec_control_signals = 5'b01010; // MFHI
                6'b01_0010: auxdec_control_signals = 5'b01011; // MFLO

                6'b00_1000: auxdec_control_signals = 5'b11111;

                default:    auxdec_control_signals = 5'bXXXXX;
            endcase
        endcase
    end

endmodule
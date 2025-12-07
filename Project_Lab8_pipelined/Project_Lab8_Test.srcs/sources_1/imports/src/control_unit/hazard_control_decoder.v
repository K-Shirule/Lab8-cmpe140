
module hazard_control_decoder (
    input wire [31:0] instruction,
    output wire [14:0] hazard_control_signals
);
    wire [5:0] opcode;
    wire [5:0] funct;

    assign opcode = instruction[31:26];
    assign funct = instruction[5:0];

    reg [4:0] reg_a_read, reg_b_read, reg_write;

    assign hazard_control_signals = { reg_a_read, reg_b_read, reg_write };

    always @(instruction) begin
        reg_a_read = 0;
        reg_b_read = 0;
        reg_write = 0;

        case (opcode)
            6'b00_0000: begin // R-type
                reg_a_read = instruction[25:21];
                reg_b_read = instruction[20:16];

                case (funct)
                    6'h10, 6'h11: begin
                        reg_a_read = 5'd0; // MFHI and MFLO do not read rs
                        reg_b_read = 5'd0; // MFHI and MFLO do not read rt
                        reg_write = instruction[20:16]; // rd
                    end
                    6'h08, 6'h09: begin
                        reg_b_read = 5'd0; // JR and JALR do not read rt
                        reg_write = 5'd0; // JR does not write
                    end

                    default:    reg_write = instruction[15:11]; // rd
                endcase
            end
            6'b00_0011: begin // JAL
                reg_write = 5'd31; // $ra
            end
            6'b00_0100: begin // BEQ
                reg_a_read = instruction[25:21];
                reg_b_read = instruction[20:16];
            end
            6'b10_0011, 6'b00_1000: begin // LW
                reg_a_read = instruction[25:21];
                reg_write = instruction[20:16]; // rt
            end
            6'b10_1011: begin // SW
                reg_a_read = instruction[25:21];
                reg_b_read = instruction[20:16];
            end
            default: begin
                reg_write = instruction[20:16]; // rt
            end
        endcase
    end

endmodule
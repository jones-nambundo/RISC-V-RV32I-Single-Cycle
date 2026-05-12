`timescale 1ns/1ps

module immediate_generator (
    input  wire [31:0] instruction,
    output reg  [31:0] immediate
);
    wire [6:0] opcode = instruction[6:0];

    always @(*) begin
        case (opcode)
            7'b0010011, // I-type ALU
            7'b0000011, // lw
            7'b1100111: // jalr
                immediate = {{20{instruction[31]}}, instruction[31:20]};

            7'b0100011: // S-type sw
                immediate = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};

            7'b1100011: // B-type beq/bne
                immediate = {{19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0};

            7'b0110111, // U-type lui
            7'b0010111: // auipc, optional
                immediate = {instruction[31:12], 12'b0};

            7'b1101111: // J-type jal
                immediate = {{11{instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0};

            default:
                immediate = 32'b0;
        endcase
    end
endmodule

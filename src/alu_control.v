`timescale 1ns/1ps

module alu_control (
    input  wire [1:0] alu_op,
    input  wire [2:0] funct3,
    input  wire       funct7b5,
    output reg  [3:0] alu_ctrl
);
    localparam ALU_ADD = 4'b0000;
    localparam ALU_SUB = 4'b0001;
    localparam ALU_AND = 4'b0010;
    localparam ALU_OR  = 4'b0011;
    localparam ALU_XOR = 4'b0100;
    localparam ALU_SLT = 4'b0101;

    always @(*) begin
        case (alu_op)
            2'b00: alu_ctrl = ALU_ADD; // lw/sw/jalr address calculation
            2'b01: alu_ctrl = ALU_SUB; // branch comparison

            2'b10: begin // R-type
                case (funct3)
                    3'b000: alu_ctrl = funct7b5 ? ALU_SUB : ALU_ADD;
                    3'b111: alu_ctrl = ALU_AND;
                    3'b110: alu_ctrl = ALU_OR;
                    3'b100: alu_ctrl = ALU_XOR;
                    3'b010: alu_ctrl = ALU_SLT;
                    default: alu_ctrl = ALU_ADD;
                endcase
            end

            2'b11: begin // I-type ALU
                case (funct3)
                    3'b000: alu_ctrl = ALU_ADD; // addi
                    3'b111: alu_ctrl = ALU_AND; // andi
                    3'b110: alu_ctrl = ALU_OR;  // ori
                    3'b100: alu_ctrl = ALU_XOR; // xori
                    3'b010: alu_ctrl = ALU_SLT; // slti
                    default: alu_ctrl = ALU_ADD;
                endcase
            end

            default: alu_ctrl = ALU_ADD;
        endcase
    end
endmodule

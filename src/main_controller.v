`timescale 1ns/1ps

module main_controller (
    input  wire [6:0] opcode,
    output reg        reg_write,
    output reg        alu_src,
    output reg        mem_read,
    output reg        mem_write,
    output reg        branch,
    output reg        jump,
    output reg        jalr,
    output reg [1:0]  result_src,
    output reg [1:0]  alu_op
);
    // result_src: 00 = ALU, 01 = DataMemory, 10 = PC+4, 11 = Immediate/LUI
    // alu_op:     00 = ADD, 01 = BRANCH/SUB, 10 = R-type, 11 = I-type ALU

    always @(*) begin
        reg_write = 1'b0;
        alu_src   = 1'b0;
        mem_read  = 1'b0;
        mem_write = 1'b0;
        branch    = 1'b0;
        jump      = 1'b0;
        jalr      = 1'b0;
        result_src = 2'b00;
        alu_op     = 2'b00;

        case (opcode)
            7'b0110011: begin // R-type
                reg_write = 1'b1;
                alu_src   = 1'b0;
                result_src = 2'b00;
                alu_op     = 2'b10;
            end

            7'b0010011: begin // I-type ALU: addi, andi, ori, xori, slti
                reg_write = 1'b1;
                alu_src   = 1'b1;
                result_src = 2'b00;
                alu_op     = 2'b11;
            end

            7'b0000011: begin // lw
                reg_write = 1'b1;
                alu_src   = 1'b1;
                mem_read  = 1'b1;
                result_src = 2'b01;
                alu_op     = 2'b00;
            end

            7'b0100011: begin // sw
                alu_src   = 1'b1;
                mem_write = 1'b1;
                alu_op    = 2'b00;
            end

            7'b1100011: begin // beq, bne
                branch = 1'b1;
                alu_op = 2'b01;
            end

            7'b1101111: begin // jal
                reg_write = 1'b1;
                jump      = 1'b1;
                result_src = 2'b10;
            end

            7'b1100111: begin // jalr, optional
                reg_write = 1'b1;
                alu_src   = 1'b1;
                jump      = 1'b1;
                jalr      = 1'b1;
                result_src = 2'b10;
                alu_op     = 2'b00;
            end

            7'b0110111: begin // lui
                reg_write = 1'b1;
                result_src = 2'b11;
            end

            default: begin
                reg_write = 1'b0;
            end
        endcase
    end
endmodule

`timescale 1ns/1ps

module branch_unit (
    input  wire        branch,
    input  wire [2:0]  funct3,
    input  wire [31:0] rs1_data,
    input  wire [31:0] rs2_data,
    output reg         branch_taken
);
    always @(*) begin
        branch_taken = 1'b0;
        if (branch) begin
            case (funct3)
                3'b000: branch_taken = (rs1_data == rs2_data); // beq
                3'b001: branch_taken = (rs1_data != rs2_data); // bne
                default: branch_taken = 1'b0;
            endcase
        end
    end
endmodule

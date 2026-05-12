`timescale 1ns/1ps

module rv32i_single_cycle_top #(
    parameter PROGRAM_FILE = "mem/program.mem"
)(
    input  wire clk,
    input  wire reset
);
    wire [31:0] pc_current;
    wire [31:0] pc_plus4;
    wire [31:0] pc_branch;
    wire [31:0] pc_jump_reg;
    wire [31:0] pc_next;

    wire [31:0] instruction;
    wire [6:0]  opcode = instruction[6:0];
    wire [4:0]  rd     = instruction[11:7];
    wire [2:0]  funct3 = instruction[14:12];
    wire [4:0]  rs1    = instruction[19:15];
    wire [4:0]  rs2    = instruction[24:20];
    wire        funct7b5 = instruction[30];

    wire        reg_write;
    wire        alu_src;
    wire        mem_read;
    wire        mem_write;
    wire        branch;
    wire        jump;
    wire        jalr;
    wire [1:0]  result_src;
    wire [1:0]  alu_op;

    wire [31:0] rs1_data;
    wire [31:0] rs2_data;
    wire [31:0] immediate;
    wire [31:0] alu_b;
    wire [3:0]  alu_ctrl;
    wire [31:0] alu_result;
    wire        zero;
    wire [31:0] mem_read_data;
    wire [31:0] write_back_data;
    wire        branch_taken;

    pc pc_inst (
        .clk(clk),
        .reset(reset),
        .next_pc(pc_next),
        .pc_out(pc_current)
    );

    adder pc_adder (
        .a(pc_current),
        .b(32'd4),
        .y(pc_plus4)
    );

    instruction_memory #(
        .PROGRAM_FILE(PROGRAM_FILE)
    ) imem (
        .address(pc_current),
        .instruction(instruction)
    );

    main_controller controller (
        .opcode(opcode),
        .reg_write(reg_write),
        .alu_src(alu_src),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .branch(branch),
        .jump(jump),
        .jalr(jalr),
        .result_src(result_src),
        .alu_op(alu_op)
    );

    register_file regfile (
        .clk(clk),
        .reset(reset),
        .reg_write(reg_write),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .write_data(write_back_data),
        .read_data1(rs1_data),
        .read_data2(rs2_data)
    );

    immediate_generator immgen (
        .instruction(instruction),
        .immediate(immediate)
    );

    alu_control alu_ctrl_unit (
        .alu_op(alu_op),
        .funct3(funct3),
        .funct7b5(funct7b5),
        .alu_ctrl(alu_ctrl)
    );

    mux2 #(32) alu_src_mux (
        .a(rs2_data),
        .b(immediate),
        .sel(alu_src),
        .y(alu_b)
    );

    alu alu_unit (
        .a(rs1_data),
        .b(alu_b),
        .alu_ctrl(alu_ctrl),
        .result(alu_result),
        .zero(zero)
    );

    data_memory dmem (
        .clk(clk),
        .mem_read(mem_read),
        .mem_write(mem_write),
        .address(alu_result),
        .write_data(rs2_data),
        .read_data(mem_read_data)
    );

    mux4 #(32) writeback_mux (
        .d0(alu_result),
        .d1(mem_read_data),
        .d2(pc_plus4),
        .d3(immediate),
        .sel(result_src),
        .y(write_back_data)
    );

    branch_unit branch_unit_inst (
        .branch(branch),
        .funct3(funct3),
        .rs1_data(rs1_data),
        .rs2_data(rs2_data),
        .branch_taken(branch_taken)
    );

    assign pc_branch   = pc_current + immediate;
    assign pc_jump_reg = (rs1_data + immediate) & ~32'd1;
    assign pc_next     = jalr ? pc_jump_reg :
                         jump ? pc_branch :
                         branch_taken ? pc_branch :
                         pc_plus4;
endmodule

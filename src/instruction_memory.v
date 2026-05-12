`timescale 1ns/1ps

module instruction_memory #(
    parameter MEM_SIZE = 256,
    parameter PROGRAM_FILE = "mem/program.mem"
)(
    input  wire [31:0] address,
    output wire [31:0] instruction
);
    reg [31:0] memory [0:MEM_SIZE-1];

    initial begin
        $readmemh(PROGRAM_FILE, memory);
    end

    // RISC-V instructions are word aligned. PC is byte addressed.
    assign instruction = memory[address[31:2]];
endmodule

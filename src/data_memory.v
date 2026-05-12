`timescale 1ns/1ps

module data_memory #(
    parameter MEM_SIZE = 256
)(
    input  wire        clk,
    input  wire        mem_read,
    input  wire        mem_write,
    input  wire [31:0] address,
    input  wire [31:0] write_data,
    output wire [31:0] read_data
);
    reg [31:0] memory [0:MEM_SIZE-1];
    integer i;

    initial begin
        for (i = 0; i < MEM_SIZE; i = i + 1)
            memory[i] = 32'b0;
    end

    assign read_data = mem_read ? memory[address[31:2]] : 32'b0;

    always @(posedge clk) begin
        if (mem_write)
            memory[address[31:2]] <= write_data;
    end
endmodule

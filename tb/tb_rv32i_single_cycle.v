`timescale 1ns/1ps

module tb_rv32i_single_cycle;

    reg clk;
    reg reset;

    rv32i_single_cycle_top #(
        .PROGRAM_FILE("mem/program.mem")
    ) dut (
        .clk(clk),
        .reset(reset)
    );

    // Clock de 10ns
    always #5 clk = ~clk;

    initial begin

        // Geração do arquivo para GTKWave
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_rv32i_single_cycle);

        // Inicialização
        clk   = 1'b0;
        reset = 1'b1;

        // Libera reset
        #15;
        reset = 1'b0;

        // Tempo de execução
        #400;

        $display("\n================ RESULTADOS ================");

        // Registradores principais
        $display("x1  = %0d  (A)", dut.regfile.regs[1]);
        $display("x2  = %0d  (B)", dut.regfile.regs[2]);

        // Operações ALU
        $display("x3  = %0d  (add)", dut.regfile.regs[3]);
        $display("x4  = %0d  (sub)", dut.regfile.regs[4]);
        $display("x5  = %0d  (and)", dut.regfile.regs[5]);
        $display("x6  = %0d  (or)",  dut.regfile.regs[6]);
        $display("x7  = %0d  (xor)", dut.regfile.regs[7]);
        $display("x8  = %0d  (slt)", dut.regfile.regs[8]);

        // Load
        $display("x9  = %0d  (lw)", dut.regfile.regs[9]);

        // Branch
        $display("x10 = %0d  (beq sucesso)", dut.regfile.regs[10]);

        // Jump
        $display("x11 = 0x%08h (jal return PC+4)", dut.regfile.regs[11]);

        // Deve continuar 0 se jal funcionou
        $display("x12 = %0d  (deve ser 0 se jal funcionou)", dut.regfile.regs[12]);

        // Final
        $display("x13 = %0d  (fim)", dut.regfile.regs[13]);

        // Memória
        // endereço 112 bytes = posição 28
        $display("MEM[28] = %0d", dut.dmem.memory[28]);

        $display("============================================\n");

        $finish;
    end

endmodule
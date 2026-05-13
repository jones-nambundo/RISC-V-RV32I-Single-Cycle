# RV32I Single Cycle Processor - Verilog

Projeto ajustado para a atividade: desenvolvimento e simulação de um processador RISC-V RV32I de 32 bits, arquitetura single-cycle.

## Instruções implementadas

- R-type: `add`, `sub`, `and`, `or`, `xor`, `slt`
- I-type: `addi`, `andi`, `ori`, `xori`, `slti`
- Load/Store: `lw`, `sw`
- Branch: `beq`, `bne`
- Jump: `jal` e `jalr` opcional
- U-type: `lui`

## Organização

```text
rv32i_single_cycle_fixed/
  src/
    pc.v
    adder.v
    mux2.v
    mux4.v
    instruction_memory.v
    data_memory.v
    register_file.v
    immediate_generator.v
    main_controller.v
    alu_control.v
    alu.v
    branch_unit.v
    rv32i_single_cycle_top.v
  tb/
    tb_rv32i_single_cycle.v
  mem/
    program.mem
  docs/
    Relátorio_Jones_Nambundo
```

## Como simular com Icarus Verilo

Execute na raiz do projeto:

```bash
iverilog -o sim.out src/*.v tb/tb_rv32i_single_cycle.v
vvp sim.out
gtkwave wave.vcd
```

## Observação

A memória de instruções usa `$readmemh` para carregar o arquivo `mem/program.mem`.
O projeto não possui pipeline, registradores intermediários de pipeline, cache, forwarding, hazard detection, FPU ou multiplicação/divisão.

# Este script automatiza tarefas que devem ser realizadas quando o codigo fonte é alterado

# compila todos os codigos vhdl
vcom *.vhd		

# Inicia a simulação
eval vsim work.main

# Adiciona os objetos
add wave -r /* 			

# Força o clock a 10ns
force -freeze sim:/main/ck 1 0, 0 {5000 ps} -r 10ns
restart -f -nowave
add wave master_load_enable opcode neq eq CLK ARESETN pcSel pcLd instrLd addrMd dmWr dataLd flagLd accSel accLd im2bus dmRd acc2bus ext2bus dispLd aluMd


force CLK 0 0, 1 50ns -repeat 100ns
force ARESETN 10#1
force master_load_enable 10#1
force neq 10#0
force eq 10#1
run 50 ns
force opcode 0
run 300ns
force opcode 1
run 300ns
force opcode 10#2
run 300ns
force opcode 10#3
run 300ns
force opcode 10#4
run 300ns
force opcode 10#5
run 300ns
force opcode 10#6
run 300ns
force opcode 10#7
run 300ns
force opcode 10#8
run 400ns
force opcode 10#9
run 400ns
force opcode 10#10
run 400ns
force opcode 10#11
run 200ns
force opcode 10#12
run 200ns
force opcode 10#13
run 200ns
force opcode 10#14
run 200ns
force opcode 10#15
run 300ns


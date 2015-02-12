restart -f -nowave
add wave externalIn CLK master_load_enable ARESETN pc2seg instr2seg Addr2seg dMemOut2seg aluOut2seg acc2seg flag2seg busOut2seg disp2seg errSig2seg ovf zero
force CLK 0 0, 1 50ns -repeat 100ns
force ARESETN 1
force master_load_enable 1
force externalIn 0
run 10 ms


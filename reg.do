restart -f -nowave
add wave CLK ARESETN loadEnable input res
force CLK 0 0, 1 50ns -repeat 100ns
force ARESETN 0
force loadEnable 1
force input 2#00001111
run 225ns
force ARESETN 1
run 250ns
force ARESETN 0
run 250ns
force ARESETN 1
force loadEnable 0
force input 2#01010101
run 250ns
run 250ns
force loadEnable 1
run 250ns

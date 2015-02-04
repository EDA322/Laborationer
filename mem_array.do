restart -f -nowave
add wave ADDR DATA_IN CLK WE OUTPUT
force CLK 0 0, 1 50ns -repeat 100ns
force WE 0
force ADDR 0
force DATA_IN 2#110011001100
run 250ns
force WE 1
run 250ns

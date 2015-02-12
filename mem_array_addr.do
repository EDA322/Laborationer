restart -f -nowave
add wave ADDR DATA_IN CLK WE OUTPUT
force CLK 0 0, 1 50ns -repeat 100ns
force WE 0
force ADDR 0
force DATA_IN 0
run 100 ns
force ADDR 1
run 100 ns
force ADDR 10#2
run 100 ns
force ADDR 10#3
run 100 ns
force ADDR 10#4
run 100 ns
force ADDR 10#5
run 100 ns
force ADDR 10#6
run 100 ns
force ADDR 10#7
run 100 ns
force ADDR 10#8
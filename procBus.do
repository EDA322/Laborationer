restart -f -nowave
add wave INSTRUCTION DATA ACC EXTDATA OUTPUT ERR instrSEL dataSEL accSEL extdataSEL
force INSTRUCTION 10#1
force DATA 10#2
force ACC 10#3
force EXTDATA 10#4
force instrSEL 0
force dataSEL 0
force accSEL 0
force extdataSEL 0
run 250ns
force instrSEL 1
run 250ns
force instrSEL 0
force dataSEL 1
run 250ns
force dataSEL 0
force accSEL 1
run 250ns
force accSEL 0
force extdataSEL 1
run 250ns
force accSEL 1
run 250ns
force dataSEL 1
run 250ns
force instrSEL 1
run 250ns


#restart -f -nowave

force a 2#00110011
force b 2#00000011
force cin 2#0
run 250ns
force cin 2#1
run 250ns
force a 2#11111111
force b 2#00000000
run 250ns
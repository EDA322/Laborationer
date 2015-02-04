LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY fa_cla IS 
	PORT( a, b, cin : in STD_LOGIC;
	      s, g, p   : out STD_LOGIC);
END fa_cla;

ARCHITECTURE dataflow OF fa_cla IS
SIGNAL aplusb: STD_LOGIC;
BEGIN
	aplusb <= a XOR b;
	s <= aplusb XOR cin;
	g <= a AND b;
	p <= aplusb;
END dataflow;

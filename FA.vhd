library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY FA IS 
	PORT( a, b, cin : in STD_LOGIC;
	      s, cout   : out STD_LOGIC);
END FA;

ARCHITECTURE dataflow OF FA IS
BEGIN
	s <= a XOR b XOR cin;
	cout <= (a AND b) OR (a AND cin) OR (b AND cin);
END dataflow;


	
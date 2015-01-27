library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY fa IS 
	PORT( a, b, cin : in STD_LOGIC;
	      s, cout   : out STD_LOGIC);
END fa;

ARCHITECTURE dataflow OF fa IS
BEGIN
	s <= a XOR b XOR cin;
	cout <= (a AND b) OR (a AND cin) OR (b AND cin);
END dataflow;

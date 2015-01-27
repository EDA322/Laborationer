library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY cmp IS
	PORT( a, b : in STD_LOGIC_VECTOR(7 downto 0);
	      eq, neq : out STD_LOGIC);
END cmp;

ARCHITECTURE dataflow OF cmp IS
SIGNAL not_eq : STD_LOGIC;
BEGIN
	not_eq <= (a(0) XOR b(0)) OR (a(1) XOR b(1)) OR
		  (a(2) XOR b(2)) OR (a(3) XOR b(3)) OR
		  (a(4) XOR b(4)) OR (a(5) XOR b(5)) OR
		  (a(6) XOR b(6)) OR (a(7) XOR b(7));
	eq <= NOT not_eq;
	neq <= not_eq;
END dataflow;

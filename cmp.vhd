library ieee;
use ieee.std_logic_1164.ALL;

entity cmp is
	port ( a, b 	: in std_logic_vector(7 downto 0);
	      eq, neq : out std_logic	);
end cmp;

architecture dataflow of cmp is
signal not_eq 	: std_logic;
begin
	not_eq <=
		(a(0) xor b(0)) or (a(1) xor b(1)) or
	  (a(2) xor b(2)) or (a(3) xor b(3)) or
	  (a(4) xor b(4)) or (a(5) xor b(5)) or
	  (a(6) xor b(6)) or (a(7) xor b(7));
	eq <= not not_eq;
	neq <= not_eq;
end dataflow;

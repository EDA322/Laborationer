library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- 8-bit Carry-Lookahead Unit
ENTITY clu_8b IS
	PORT( G, P   : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
              cin    : IN  STD_LOGIC;
	      couts  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
END clu_8b;

ARCHITECTURE dataflow OF clu_8b IS
BEGIN 
	couts(0) <= G(0) OR (P(0) AND cin)
	couts(1) <= G(1) OR (P(1) AND G(0)) OR
			    (P(1) AND P(0) AND cin)
	couts(2) <= G(2) OR (P(2) AND G(1)) OR
			    (P(2) AND P(1) AND G(0)) OR
			    (P(2) AND P(1) AND P(0) AND cin)
	couts(3) <= G(3) OR (P(3) AND G(2)) OR
			    (P(3) AND P(2) AND G(1)) OR
			    (P(3) AND P(2) AND P(1) AND G(0)) OR
			    (P(3) AND P(2) AND P(1) AND P(0) AND cin)
	couts(4) <= G(4) OR (P(4) AND G(3)) OR
			    (P(4) AND P(3) AND G(2)) OR
			    (P(4) AND P(3) AND P(2) AND G(1)) OR
			    (P(4) AND P(3) AND P(2) AND P(1) AND G(0)) OR
			    (P(4) AND P(3) AND P(2) AND P(1) AND P(0) AND cin)
	couts(5) <= G(5) OR (P(5) AND G(4)) OR
			    (P(5) AND P(4) AND G(3)) OR
			    (P(5) AND P(4) AND P(3) AND G(2)) OR
			    (P(5) AND P(4) AND P(3) AND P(2) AND G(1)) OR
			    (P(5) AND P(4) AND P(3) AND P(2) AND P(1) AND G(0)) OR
			    (P(5) AND P(4) AND P(3) AND P(2) AND P(1) AND P(0) AND cin)
	couts(6) <= G(6) OR (P(6) AND G(5)) OR
			    (P(6) AND P(5) AND G(4)) OR
			    (P(6) AND P(5) AND P(4) AND G(3)) OR
			    (P(6) AND P(5) AND P(4) AND P(3) AND G(2)) OR
			    (P(6) AND P(5) AND P(4) AND P(3) AND P(2) AND G(1)) OR
			    (P(6) AND P(5) AND P(4) AND P(3) AND P(2) AND P(1) AND G(0)) OR
			    (P(6) AND P(5) AND P(4) AND P(3) AND P(2) AND P(1) AND P(0) AND cin)
	couts(7) <= G(7) OR (P(7) AND G(6)) OR
			    (P(7) AND P(6) AND G(5)) OR
			    (P(7) AND P(6) AND P(5) AND G(4)) OR
			    (P(7) AND P(6) AND P(5) AND P(4) AND G(3)) OR
			    (P(7) AND P(6) AND P(5) AND P(4) AND P(3) AND G(2)) OR
			    (P(7) AND P(6) AND P(5) AND P(4) AND P(3) AND P(2) AND G(1)) OR
			    (P(7) AND P(6) AND P(5) AND P(4) AND P(3) AND P(2) AND P(1) AND G(0)) OR
			    (P(7) AND P(6) AND P(5) AND P(4) AND P(3) AND P(2) AND P(1) AND P(0) AND cin)
END structure;

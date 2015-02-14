library ieee;
use ieee.std_logic_1164.all;

-- 8-bit Carry-Lookahead Unit
entity clu_8b is
	port (	G, P   : in  std_logic_vector(7 downto 0);
          cin    : in  std_logic;
	      	couts  : out std_logic_vector(7 downto 0)	);
end clu_8b;

architecture dataflow of clu_8b is
begin
	couts(0) <= G(0) or
	(P(0) and cin);
	couts(1) <=
		G(1) or
		(P(1) and G(0)) or
		(P(1) and P(0) and cin);
	couts(2) <=
		G(2) or
		(P(2) and G(1)) or
    (P(2) and P(1) and G(0)) or
    (P(2) and P(1) and P(0) and cin);
	couts(3) <=
		G(3) or
		(P(3) and G(2)) or
  	(P(3) and P(2) and G(1)) or
    (P(3) and P(2) and P(1) and G(0)) or
  	(P(3) and P(2) and P(1) and P(0) and cin);
	couts(4) <=
		G(4) or
		(P(4) and G(3)) or
    (P(4) and P(3) and G(2)) or
  	(P(4) and P(3) and P(2) and G(1)) or
  	(P(4) and P(3) and P(2) and P(1) and G(0)) or
    (P(4) and P(3) and P(2) and P(1) and P(0) and cin);
	couts(5) <=
		G(5) or
		(P(5) and G(4)) or
    (P(5) and P(4) and G(3)) or
    (P(5) and P(4) and P(3) and G(2)) or
    (P(5) and P(4) and P(3) and P(2) and G(1)) or
    (P(5) and P(4) and P(3) and P(2) and P(1) and G(0)) or
    (P(5) and P(4) and P(3) and P(2) and P(1) and P(0) and cin);
	couts(6) <=
		G(6) or
		(P(6) and G(5)) or
    (P(6) and P(5) and G(4)) or
    (P(6) and P(5) and P(4) and G(3)) or
    (P(6) and P(5) and P(4) and P(3) and G(2)) or
    (P(6) and P(5) and P(4) and P(3) and P(2) and G(1)) or
    (P(6) and P(5) and P(4) and P(3) and P(2) and P(1) and G(0)) or
    (P(6) and P(5) and P(4) and P(3) and P(2) and P(1) and P(0) and cin);
	couts(7) <=
		G(7) or
		(P(7) and G(6)) or
    (P(7) and P(6) and G(5)) or
    (P(7) and P(6) and P(5) and G(4)) or
    (P(7) and P(6) and P(5) and P(4) and G(3)) or
    (P(7) and P(6) and P(5) and P(4) and P(3) and G(2)) or
    (P(7) and P(6) and P(5) and P(4) and P(3) and P(2) and G(1)) or
    (P(7) and P(6) and P(5) and P(4) and P(3) and P(2) and P(1) and G(0)) or
    (P(7) and P(6) and P(5) and P(4) and P(3) and P(2) and P(1) and P(0) and cin);
end dataflow;

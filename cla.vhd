LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

-- Carry-Lookahead Adder
ENTITY cla IS
	PORT( a, b : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
              cin  : IN STD_LOGIC;
	      s    : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	      cout : OUT STD_LOGIC);
END cla;

ARCHITECTURE structure OF cla IS

-- Internal signals
SIGNAL couts: STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL G: STD_LOGIV_VECTOR(7 DOWNTO 0);
SIGNAL P: STD_LOGIV_VECTOR(7 DOWNTO 0);

-- Components
COMPONENT fa_cla
	PORT( a, b, cin : IN STD_LOGIC;
	      s, g, p   : OUT STD_LOGIC);
END COMPONENT;

COMPONENT clu_8b
	PORT( G, P  : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
	      cin   : IN  STD_LOGIC;
	      couts : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
END COMPONENT;

BEGIN
-- Full-adders
	fa_0: fa_cla PORT MAP (a(0) => a, b(0) => b, cin => cin, s(0) => s, G(0) => g, P(0) => p);
	fa_1: fa_cla PORT MAP (a(1), b(1), couts(0), s(1), G(1), P(1));
	fa_2: fa_cla PORT MAP (a(2), b(2), couts(1), s(2), G(2), P(2));
	fa_3: fa_cla PORT MAP (a(3), b(3), couts(2), s(3), G(3), P(3));
	fa_4: fa_cla PORT MAP (a(4), b(4), couts(3), s(4), G(4), P(4));
	fa_5: fa_cla PORT MAP (a(5), b(5), couts(4), s(5), G(5), P(5));
	fa_6: fa_cla PORT MAP (a(6), b(6), couts(5), s(6), G(6), P(6));
	fa_7: fa_cla PORT MAP (a(7), b(7), couts(6), s(7), G(7), P(7));
-- Carry-Lookahead Unit
	clu: clu_8b PORT MAP (G => G, P => P, cin => cin, couts => couts); 
-- Carry out
	cout <= couts(7);
END dataflow;

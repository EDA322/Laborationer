library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY rca IS
	PORT( a, b : in STD_LOGIC_VECTOR(7 downto 0);
              cin  : in STD_LOGIC;
	      s    : out STD_LOGIC_VECTOR(7 downto 0);
	      cout : out STD_LOGIC);
END rca;

ARCHITECTURE structure OF rca IS
SIGNAL couts : STD_LOGIC_VECTOR(6 downto 0);
COMPONENT FA  
	PORT( a, b, cin : in STD_LOGIC;
	      s, cout   : out STD_LOGIC);
END COMPONENT;

BEGIN 
	fa_0 : FA port map (a(0), b(0), cin, s(0), couts(0));
	fa_1 : FA port map (a(1), b(1), couts(0), s(1), couts(1));
	fa_2 : FA port map (a(2), b(2), couts(1), s(2), couts(2));
	fa_3 : FA port map (a(3), b(3), couts(2), s(3), couts(3));
	fa_4 : FA port map (a(4), b(4), couts(3), s(4), couts(4));
	fa_5 : FA port map (a(5), b(5), couts(4), s(5), couts(5));
	fa_6 : FA port map (a(6), b(6), couts(5), s(6), couts(6));
	fa_7 : FA port map (a(7), b(7), couts(6), s(7), cout);
END structure;
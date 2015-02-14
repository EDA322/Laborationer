library ieee;
use ieee.std_logic_1164.ALL;

entity rca IS
	port (	a, b : in std_logic_vector(7 downto 0);
					cin  : in std_logic;
					s    : out std_logic_vector(7 downto 0);
					cout : out std_logic	);
end rca;

architecture structure of rca is
signal couts 				: std_logic_vector(8 downto 0);
component FA
	port (	a, b, cin : in std_logic;
	      	s, cout   : out std_logic	);
end component;

begin
	couts(0) <= cin;
	cout <= couts(8);
	fullAdders: for i in 0 to 7 generate
			port map (	a => a(i),
									b => b(i),
									cin => couts(i),
									s => s(i),
									cout => couts(i+1)	);
end structure;

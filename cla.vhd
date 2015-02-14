library ieee;
use ieee.std_logic_1164.all;

-- Carry-Lookahead Adder
entity cla is
	port ( 	a, b 	: in std_logic_vector(7 downto 0);
          cin  	: in std_logic;
	      	s    	: out std_logic_vector(7 downto 0);
	      	cout 	: out std_logic	);
end cla;

architecture structure of cla is

-- Internal signals
signal carries			: std_logic_vector(7 downto 0);
signal G						: std_logic_vector(7 downto 0);
signal P						: std_logic_vector(7 downto 0);

-- Components
component fa_cla
	port ( 	a, b, cin : in std_logic;
	      	s, g, p   : out std_logic	);
end component;

component clu_8b
	port (	G, P  		: in  std_logic_vector(7 downto 0);
	      	cin   		: in  std_logic;
	      	couts 		: out std_logic_vector(7 downto 0)	);
end component;

begin
	carries(0) <= cin;
	cout <= carries(8);

-- Full-adders
	full_adders: for i in 0 to 7 generate
		port map (	a => a(i),
								b => b(i),
								cin => carries(i),
								s => s(i),
								g => G(i),
								p => P(i)	);
	end generate;
-- Carry-Lookahead Unit
	clu: clu_8b
		port map (	G => G,
								P => P,
								cin => carries(0),
								couts => carries(8 downto 1)	);
end structure;

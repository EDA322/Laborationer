library ieee;
use ieee.std_logic_1164.all;

entity fa_cla IS
	port ( 	a, b, cin : in std_logic;
	      	s, g, p   : out std_logic	);
end fa_cla;

architecture dataflow of fa_cla is
variable aplusb: std_logic := a xor b;
begin
	s <= aplusb xor cin;
	g <= a and b;
	p <= aplusb;
end dataflow;

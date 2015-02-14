library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux2to1 IS
	generic ( width: integer:=8	);
	port (	w1 	: in std_logic_vector(width-1 downto 0);
	       	w2 	: in std_logic_vector(width-1 downto 0);
	       	f 	: out std_logic_vector(width-1 downto 0);
	       	sel : in std_logic);
end mux2to1;

architecture dataflow of mux2to1 is
begin
	with sel select
		f <= w1 when '0',
		     w2 when others;
end dataflow;

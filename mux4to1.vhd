library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux4to1 IS
	generic ( width	: integer:=8);
	port ( 	w1 	: in std_logic_vector(width-1 downto 0);
	       	w2 	: in std_logic_vector(width-1 downto 0);
	       	w3 	: in std_logic_vector(width-1 downto 0);
	       	w4 	: in std_logic_vector(width-1 downto 0);
	       	f 	: out std_logic_vector(width-1 downto 0);
	       	sel : in std_logic_vector(1 downto 0)	);
end mux4to1;

architecture dataflow OF mux4to1 IS
begin
	with sel select
		f <= w1 when "00",
		     w2 when "01",
		     w3 when "10",
		     w4 when others;
end dataflow;

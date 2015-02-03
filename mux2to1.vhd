LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY mux2to1 IS
	GENERIC ( width: integer:=8);
	PORT ( w1 : in STD_LOGIC_VECTOR(width-1 downto 0);
	       w2 : in STD_LOGIC_VECTOR(width-1 downto 0);	
	       f : out STD_LOGIC_VECTOR(width-1 downto 0);	
	       sel : in STD_LOGIC);
END mux2to1;
	
ARCHITECTURE dataflow OF mux2to1 IS
BEGIN
	WITH sel SELECT
		f <= w1 WHEN '0',
		     w2 WHEN OTHERS;
END dataflow;
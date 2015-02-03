LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY mux4to1 IS
	GENERIC ( width: integer:=8);
	PORT ( w1 : in STD_LOGIC_VECTOR(width-1 downto 0);
	       w2 : in STD_LOGIC_VECTOR(width-1 downto 0);
	       w3 : in STD_LOGIC_VECTOR(width-1 downto 0);
	       w4 : in STD_LOGIC_VECTOR(width-1 downto 0);	
	       f : out STD_LOGIC_VECTOR(width-1 downto 0);	
	       sel : in STD_LOGIC_VECTOR(1 downto 0));
END mux4to1;
	
ARCHITECTURE dataflow OF mux4to1 IS
BEGIN
	WITH sel SELECT
		f <= w1 WHEN "00",
		     w2 WHEN "01",
		     w3 WHEN "10",
		     w4 WHEN OTHERS;
END dataflow;
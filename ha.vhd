library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ha is 
	Port ( a : in STD_LOGIC;
	       b : in STD_LOGIC;
	       s : out STD_LOGIC;
	       c : out STD_LOGIC);
end ha;

architecture ha_arc of ha is
begin
	s <= a xor b;
	c <= a and b;
end ha_arc;
	     
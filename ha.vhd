library ieee;
use ieee.std_logic_1164.ALL;

entity ha is
	port ( a : in std_logic;
	       b : in std_logic;
	       s : out std_logic;
	       c : out std_logic	);
end ha;

architecture ha_arc of ha is
begin
	s <= a xor b;
	c <= a and b;
end ha_arc;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY cla IS
	PORT( a, b : in STD_LOGIC_VECTOR(7 downto 0);
              cin  : in STD_LOGIC;
	      s    : out STD_LOGIC_VECTOR(7 downto 0);
	      cout : out STD_LOGIC);
END cla;
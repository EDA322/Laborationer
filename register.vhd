LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY register IS
	GENERIC( width: integer := 8 );
	PORT( CLK 	 : IN std_logic;
	      ARESETN	 : IN std_logic;
	      loadEnable : IN std_logic;
	      in         : IN std_logic_vector(width-1 DOWNTO 0);
	      res        : OUT std_logic_vector(width-1 DOWNTO 0)
	);
END register;

	      	

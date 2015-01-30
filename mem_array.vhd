LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY mem_array IS
	GENERIC ( DATA_WIDTH : integer := 12;
		  ADDR_WIDTH : integer := 8;
		  INIT_FILE  : string  := ”inst_mem.mif” );
	PORT ( ADDR    : IN STD_LOGIC_VECTOR (ADDR_WIDTH-1 DOWNTO 0);
	       DATA_IN : IN STD_LOGIC_VECTOR (DATA_WIDTH-1 DOWNTO 0);
	       CLK     : IN STD_LOGIC;
	       WE      : IN STD_LOGIC;
	       OUTPUT  : OUT STD_LOGIC_VECTOR (DATA_WIDTH-1 DOWNTO 0) );
END mem_array;
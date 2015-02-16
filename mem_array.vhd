library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity mem_array is
	generic (	DATA_WIDTH : integer := 12;
		  			ADDR_WIDTH : integer := 8;
		  			INIT_FILE  : string  := "data_mem.mif"	);
	port (	ADDR    : in std_logic_vector (ADDR_WIDTH-1 downto 0);
	       	DATA_IN : in std_logic_vector (DATA_WIDTH-1 downto 0);
	       	CLK     : in std_logic;
	       	WE      : in std_logic;
	       	OUTPUT  : out std_logic_vector (DATA_WIDTH-1 downto 0)	);
end mem_array;

architecture behavioral of mem_array is
type MEMORY_ARRAY is array (0 to 2**ADDR_WIDTH-1)
	of std_logic_vector(DATA_WIDTH-1 downto 0);
impure function init_memory_wfile(mif_file_name : in string)
		return MEMORY_ARRAY is
  file mif_file 		: text open read_mode is mif_file_name;
  variable mif_line : line;
  variable temp_bv 	: bit_vector(DATA_WIDTH-1 downto 0);
  variable temp_mem : MEMORY_ARRAY;
begin
  for i in MEMORY_ARRAY'range loop
    readline(mif_file, mif_line);
  	read(mif_line, temp_bv);
    temp_mem(i) := to_stdlogicvector(temp_bv);
  end loop;
  return temp_mem;
end function;

signal memory : MEMORY_ARRAY := init_memory_wfile(INIT_FILE);

begin
OUTPUT <= memory(to_integer(unsigned(ADDR)));
process(CLK)
begin
	if rising_edge(CLK) then
		if WE = '1' then
			memory(to_integer(unsigned(ADDR))) <= DATA_IN;
		end if;
	end if;
end process;
end behavioral;

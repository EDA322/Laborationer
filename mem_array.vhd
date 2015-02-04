LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE std.textio.all;

ENTITY mem_array IS
	GENERIC ( DATA_WIDTH : integer := 12;
		  ADDR_WIDTH : integer := 8;
		  INIT_FILE  : string  := "inst_mem.mif");
	PORT ( ADDR    : IN STD_LOGIC_VECTOR (ADDR_WIDTH-1 DOWNTO 0);
	       DATA_IN : IN STD_LOGIC_VECTOR (DATA_WIDTH-1 DOWNTO 0);
	       CLK     : IN STD_LOGIC;
	       WE      : IN STD_LOGIC;
	       OUTPUT  : OUT STD_LOGIC_VECTOR (DATA_WIDTH-1 DOWNTO 0));
END mem_array;

ARCHITECTURE behavioral OF mem_array IS
Type MEMORY_ARRAY is ARRAY (0 to 2**ADDR_WIDTH-1) of STD_LOGIC_VECTOR(DATA_WIDTH-1 DOWNTO 0);
impure function init_memory_wfile(mif_file_name : in string) return MEMORY_ARRAY is
    file mif_file : text open read_mode is mif_file_name;
    variable mif_line : line;
    variable temp_bv : bit_vector(DATA_WIDTH-1 downto 0);
    variable temp_mem : MEMORY_ARRAY;
begin
    for i in MEMORY_ARRAY'range loop
        readline(mif_file, mif_line);
        read(mif_line, temp_bv);
        temp_mem(i) := to_stdlogicvector(temp_bv);
    end loop;
    return temp_mem;
end function;

SIGNAL memory : MEMORY_ARRAY := init_memory_wfile(INIT_FILE);

BEGIN
OUTPUT <= memory(to_integer(unsigned(ADDR)));
PROCESS(CLK)
begin
	if rising_edge(CLK) then 
		if WE = '1' then
			memory(to_integer(unsigned(ADDR))) <= DATA_IN;
		end if;
	end if;
END PROCESS;
END behavioral;

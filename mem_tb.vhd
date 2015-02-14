library ieee;
use ieee.std_logic_1164.all;

entity mem_tb is
end mem_tb;

architecture behavioral of mem_tb is

signal instrOut:                             std_logic_vector(11 downto 0);
signal instrAddr, dataAddr, dataIn, dataOut: std_logic_vector(7 downto 0);
signal CLK, dataWE:                          std_logic;

component mem_array
	generic ( DATA_WIDTH : integer := 12;
			  		ADDR_WIDTH : integer := 8;
			  		INIT_FILE  : string  := "inst_mem.mif"	);
	PORT ( 	ADDR    : in std_logic_vector (ADDR_WIDTH-1 downto 0);
	       	DATA_IN : in std_logic_vector (DATA_WIDTH-1 downto 0);
	       	CLK     : in std_logic;
	       	WE      : in std_logic;
	       	OUTPUT  : out std_logic_vector (DATA_WIDTH-1 downto 0)	);
end component;

begin
	instrMem: mem_array
		generic map (	DATA_WIDTH => 12,
									ADDR_WIDTH => 8,
									INIT_FILE => "inst_mem.mif")
		port map (	instrAddr,
								(others => '0'),
								CLK,
								'0',
								instrOut	);
	dataMem: mem_array
		generic map (	DATA_WIDTH => 8,
									ADDR_WIDTH => 8,
									INIT_FILE => "data_mem.mif")
		port map (	dataAddr,
								dataIn,
								CLK,
								dataWE,
								dataOut	);
	dataAddr <= instrOut(7 downto 0);
process
begin
	CLK <= '0';
	dataWE <= '0';
	instrAddr <= "00000001";
	dataIn <= "11001100";
	wait for 100 ns;
	CLK <= '1';
	wait for 100 ns;
	CLK <= '0';
	dataWe <= '1';
	wait for 100 ns;
	CLK <= '1';
	wait for 66 ns;
	dataIn <= "11110000";
	wait for 34 ns;
	CLK <= '0';
	wait for 33 ns;
	instrAddr <= (OTHERS => '0');
	wait for 67 ns;
	CLK <= '1';
	wait for 100 ns;
end process;
end behavioral;

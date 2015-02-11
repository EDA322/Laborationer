LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY mem_tb IS
END mem_tb;

ARCHITECTURE behavioral OF mem_tb IS

SIGNAL instrOut:                             STD_LOGIC_VECTOR(11 downto 0);
SIGNAL instrAddr, dataAddr, dataIn, dataOut: STD_LOGIC_VECTOR(7 downto 0);
SIGNAL CLK, dataWE:                          STD_LOGIC;

COMPONENT mem_array
	GENERIC ( DATA_WIDTH : integer := 12;
			  ADDR_WIDTH : integer := 8;
			  INIT_FILE  : string  := "inst_mem.mif");
	PORT ( ADDR    : IN STD_LOGIC_VECTOR (ADDR_WIDTH-1 DOWNTO 0);
	       DATA_IN : IN STD_LOGIC_VECTOR (DATA_WIDTH-1 DOWNTO 0);
	       CLK     : IN STD_LOGIC;
	       WE      : IN STD_LOGIC;
	       OUTPUT  : OUT STD_LOGIC_VECTOR (DATA_WIDTH-1 DOWNTO 0));
END COMPONENT;

BEGIN
	instrMem: mem_array
		generic map (DATA_WIDTH => 12, ADDR_WIDTH => 8, INIT_FILE => "inst_mem.mif")
		port map (instrAddr, (OTHERS => '0'), CLK, '0', instrOut);
	dataMem: mem_array
		generic map (DATA_WIDTH => 8, ADDR_WIDTH => 8, INIT_FILE => "data_mem.mif")
		port map (dataAddr, dataIn, CLK, dataWE, dataOut);
	dataAddr <= instrOut(7 downto 0);
process
BEGIN
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
END process;
END behavioral;
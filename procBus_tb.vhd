LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY procBus_tb IS
END procBus_tb;

ARCHITECTURE behavioral OF procBus_tb IS

SIGNAL instr, data, acc, ext, output: 	  	   STD_LOGIC_VECTOR(7 downto 0);
SIGNAL err, instrSEL, dataSEL, accSEL, extSEL: STD_LOGIC;

COMPONENT procBus
	PORT ( INSTRUCTION : IN  std_logic_vector (7 DOWNTO 0);
           DATA	       : IN  std_logic_vector (7 DOWNTO 0);
           ACC 	       : IN  std_logic_vector (7 DOWNTO 0);
           EXTDATA     : IN  std_logic_vector (7 DOWNTO 0);
           OUTPUT      : OUT std_logic_vector (7 DOWNTO 0);
           ERR         : OUT std_logic;
           instrSEL    : IN  std_logic;
           dataSEL     : IN  std_logic;
           accSEL      : IN  std_logic;
           extdataSEL  : IN  std_logic);
END COMPONENT;

BEGIN
	theBus: procBus
		port map (instr, data, acc, ext, output, err,
				  instrSEL, dataSEL, accSEL, extSEL);
process
BEGIN
	instr <= "11111111";
	data  <= "11110000";
	acc   <= "11001100";
	ext   <= "10101010";
	instrSEL <= '0';
	dataSEL  <= '0';
	accSEL   <= '0';
	extSEL   <= '0';
	wait for 100 ns;
	instrSEL
	
END process;
END behavioral;
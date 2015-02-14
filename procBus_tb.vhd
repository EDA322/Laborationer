library ieee;
use ieee.std_logic_1164.all;

entity procBus_tb is
end procBus_tb;

architecture behavioral of procBus_tb is

signal instr, data, acc, ext, output					: std_logic_vector(7 downto 0);
signal err, instrSEL, dataSEL, accSEL, extSEL	: std_logic;

component procBus
	port (	INSTRUCTION	: in  std_logic_vector (7 downto 0);
          DATA	      : in  std_logic_vector (7 downto 0);
          ACC 	      : in  std_logic_vector (7 downto 0);
         	EXTDATA     : in  std_logic_vector (7 downto 0);
          OUTPUT      : out std_logic_vector (7 downto 0);
          ERR         : out std_logic;
          instrSEL    : in  std_logic;
          dataSEL     : in  std_logic;
          accSEL      : in  std_logic;
          extdataSEL  : in  std_logic	);
end component;

begin
	theBus: procBus
		port map (	INSTRUCTION => instr,
								DATA => data,
								ACC => acc,
								EXTDATA => ext,
								OUTPUT => output,
								ERR => err,
				  			instrSEL => instrSEL,
								dataSEL => dataSEL,
								accSEL => accSEL,
								extdataSEL => extSEL	);
process
begin
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

end process;
end behavioral;

library ieee;
use ieee.std_logic_1164.all;

entity procCon_tb is
end procCon_tb;

architecture behavioral of procCon_tb is
constant clk_cycle: time := 10 ns;

signal op: std_logic_vector(3 downto 0) := "0000";
signal eq: std_logic  := '1';
signal neq: std_logic := '0';
signal CLK: std_logic := '0';

component procController
    port ( master_load_enable : in  STD_LOGIC;
		   opcode 			  : in  STD_LOGIC_VECTOR (3 downto 0);
		   neq 				  : in  STD_LOGIC;
		   eq 				  : in  STD_LOGIC; 
		   CLK 				  : in  STD_LOGIC;
		   ARESETN 			  : in  STD_LOGIC;
		   pcSel 			  : out STD_LOGIC;
		   pcLd 			  : out STD_LOGIC;
		   instrLd 			  : out STD_LOGIC;
		   addrMd 			  : out STD_LOGIC;
		   dmWr 			  : out STD_LOGIC;
		   dataLd 			  : out STD_LOGIC;
		   flagLd 			  : out STD_LOGIC;
		   accSel 			  : out STD_LOGIC;
		   accLd 			  : out STD_LOGIC;
		   im2bus 			  : out STD_LOGIC;
		   dmRd 			  : out STD_LOGIC;
		   acc2bus 			  : out STD_LOGIC;
		   ext2bus 			  : out STD_LOGIC;
		   dispLd			  : out STD_LOGIC;
		   aluMd 			  : out STD_LOGIC_VECTOR(1 downto 0)
		   );
end component;

begin
	procCon: procController
		port map (
			master_load_enable => '1',
			opcode => op,
			neq => neq,
			eq => eq,
			CLK => CLK,
			ARESETN => '1',
			pcSel => open,
			pcLd => open,
			instrLd => open,
		   	addrMd => open,
		   	dmWr => open,
		   	dataLd => open,	
		   	flagLd => open,
			accSel => open,
		   	accLd => open,
		   	im2bus => open,
		   	dmRd => open,
		   	acc2bus => open,
		   	ext2bus => open,
		   	dispLd => open,
		   	aluMd => open
		);
			
clock: process
begin
	CLK <= '1';
	wait for clk_cycle/2;
	CLK <= '0';
	wait for clk_cycle/2;
end process;

testing: process
begin
	op <= "0000";
	wait for 3*clk_cycle;
	op <= "0001";
	wait for 3*clk_cycle;
	op <= "0010";
	wait for 3*clk_cycle;
	op <= "0011";
	wait for 3*clk_cycle;
	op <= "0100";
	wait for 3*clk_cycle;
	op <= "0101";
	wait for 3*clk_cycle;
	op <= "0110";
	wait for 3*clk_cycle;
	op <= "0111";
	wait for 3*clk_cycle;
	op <= "1000";
	wait for 4*clk_cycle;
	op <= "1001";
	wait for 4*clk_cycle;
	op <= "1010";
	wait for 4*clk_cycle;
	op <= "1011";
	wait for 2*clk_cycle;
	op <= "1100";
	wait for 2*clk_cycle;
	op <= "1101";
	wait for 2*clk_cycle;
	op <= "1110";
	wait for 2*clk_cycle;
	op <= "1111";
	wait for 3*clk_cycle;
end process;
	
end behavioral;




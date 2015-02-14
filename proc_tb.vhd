library ieee;
use ieee.std_logic_1164.all;

entity proc_tb is
end proc_tb;

architecture behavioral of proc_tb is

signal ovf, zero, CLK,
	master_load_enable, ARESETN		: STD_LOGIC;
signal externalIn								: STD_LOGIC_VECTOR(7 downto 0);

component EDA322_processor
	port ( 	externalIn 	  			: in  std_logic_vector (7 downto 0);
	   			CLK 		  					: in  std_logic;
	   			master_load_enable 	: in  std_logic;
       		ARESETN 	   	  		: in  std_logic;
       		pc2seg 	 	  				: out std_logic_vector (7 downto 0);
       		instr2seg 	 				: out std_logic_vector (11 downto 0);
       		Addr2seg   	 				: out std_logic_vector (7 downto 0);
       		dMemOut2seg 	 			: out std_logic_vector (7 downto 0);
       		aluOut2seg  	 			: out std_logic_vector (7 downto 0);
       		acc2seg 	   	 			: out std_logic_vector (7 downto 0);
       		flag2seg    	 			: out std_logic_vector (3 downto 0);
       		busOut2seg  	 			: out std_logic_vector (7 downto 0);
       		disp2seg   	 				: out std_logic_vector(7 downto 0);
       		errSig2seg  			 	: out std_logic;
       		ovf	   	 						: out std_logic;
       		zero 	   						: out std_logic);
end component;

begin
	proc: EDA322_processor
		port map (	externalIn,
								CLK,
								master_load_enable,
								ARESETN,
				  			pc2seg => open,
								instr2seg => open,
								Addr2seg => open,
								dMemOut2seg => open,
								aluOut2seg => open,
								acc2seg => open,
								flag2seg => open,
								busOut2seg => open,
								disp2seg => open,
								errSig2seq => open,
				  			ovf,
								zero	);

process
begin
	externalIn <= "00110011";
	CLK <= '0';
	master_load_enable <= '1';
	ARESETN <= '0';
	wait for 1 ns;
	CLK <= '1';
	wait for 1 ns;
	CLK <= '0';
	wait for 1 ns;
	CLK <= '1';
	wait for 1 ns;
	CLK <= '0';
	wait for 1 ns;
	CLK <= '1';
	wait for 1 ns;
	CLK <= '0';
end process;
end behavioral;

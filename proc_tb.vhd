LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY proc_tb IS
END proc_tb;

ARCHITECTURE behavioral OF proc_tb IS

SIGNAL ovf, zero, CLK, master_load_enable, ARESETN: STD_LOGIC;
SIGNAL externalIn: STD_LOGIC_VECTOR(7 downto 0);

COMPONENT EDA322_processor
Port ( externalIn 	  		: IN  std_logic_vector (7 DOWNTO 0); 
	   CLK 		  			: IN  std_logic;
	   master_load_enable 	: IN  std_logic;
       ARESETN 	   	  		: IN  std_logic;
       pc2seg 	 	  		: OUT std_logic_vector (7 DOWNTO 0); 
       instr2seg 	 		: OUT std_logic_vector (11 DOWNTO 0);
       Addr2seg   	 		: OUT std_logic_vector (7 DOWNTO 0); 
       dMemOut2seg 	 		: OUT std_logic_vector (7 DOWNTO 0); 
       aluOut2seg  	 		: OUT std_logic_vector (7 DOWNTO 0); 
       acc2seg 	   	 		: OUT std_logic_vector (7 DOWNTO 0); 
       flag2seg    	 		: OUT std_logic_vector (3 DOWNTO 0); 
       busOut2seg  	 		: OUT std_logic_vector (7 DOWNTO 0); 
       disp2seg   	 		: OUT std_logic_vector(7 DOWNTO 0); 
       errSig2seg  		 	: OUT std_logic;                 
       ovf	   	 			: OUT std_logic;               
       zero 	   			: OUT std_logic);        
END COMPONENT;

BEGIN
	proc: EDA322_processor
		port map (externalIn, CLK, master_load_enable, ARESETN,
				  open, open, open, open, open, open, open, open, open, open,
				  ovf, zero);

process
BEGIN
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
END process;
END behavioral;
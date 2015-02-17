library ieee;
use ieee.std_logic_1164.all;

entity EDA322Testbench is
end EDA322Testbench;

architecture behavioral of EDA322Testbench is

component EDA322_processor
	port ( externalIn 					: in  std_logic_vector(7 downto 0);
	       CLK 		  						: in  std_logic;
	       master_load_enable 	: in  std_logic;
	       ARESETN 	   	  			: in  std_logic;
	       pc2seg 	 	  				: out std_logic_vector(7 downto 0);
	       instr2seg 	  				: out std_logic_vector(11 downto 0);
	       Addr2seg   	  			: out std_logic_vector(7 downto 0);
	       dMemOut2seg 	 	 			: out std_logic_vector(7 downto 0);
	       aluOut2seg  	  			: out std_logic_vector(7 downto 0);
	       acc2seg 	   	  			: out std_logic_vector(7 downto 0);
	       flag2seg    	  			: out std_logic_vector(3 downto 0);
	       busOut2seg  	  			: out std_logic_vector(7 downto 0);
	       disp2seg   	  			: out std_logic_vector(7 downto 0);
	       errSig2seg  	  			: out std_logic;
	       ovf	   	  					: out std_logic;
	       zero 	   	  				: out std_logic	);
end component;

begin
	proc: EDA322_processor
		port map (externalIn 					: in  std_logic_vector(7 downto 0);
	       CLK 		  						: in  std_logic;
	       master_load_enable 	: in  std_logic;
	       ARESETN 	   	  			: in  std_logic;
	       pc2seg 	 	  				: out std_logic_vector(7 downto 0);
	       instr2seg 	  				: out std_logic_vector(11 downto 0);
	       Addr2seg   	  			: out std_logic_vector(7 downto 0);
	       dMemOut2seg 	 	 			: out std_logic_vector(7 downto 0);
	       aluOut2seg  	  			: out std_logic_vector(7 downto 0);
	       acc2seg 	   	  			: out std_logic_vector(7 downto 0);
	       flag2seg    	  			: out std_logic_vector(3 downto 0);
	       busOut2seg  	  			: out std_logic_vector(7 downto 0);
	       disp2seg   	  			: out std_logic_vector(7 downto 0);
	       errSig2seg  	  			: out std_logic;
	       ovf	   	  					: out std_logic;
	       zero 	   	  				: out std_logic);
end behavioral;

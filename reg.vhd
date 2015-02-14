library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity reg is
	generic (	width: integer := 8 );
	port (	CLK					: in std_logic;
					ARESETN		 	: in std_logic;
					loadEnable 	: in std_logic;
					input 			: in std_logic_vector(width-1 downto 0);
					res     	  : out std_logic_vector(width-1 downto 0)	);
end reg;


architecture behavioral of reg is
signal reg_out		: std_logic_vector(width-1 downto 0);
signal reg_in			: std_logic_vector(width-1 downto 0);
component mux2to1
	generic ( width: integer:=8);
	port (	w1 			: in std_logic_vector(width-1 downto 0);
					w2 			: in std_logic_vector(width-1 downto 0);
					f 			: out std_logic_vector(width-1 downto 0);
					sel 		: in std_logic	);
end component;

begin
	mux : mux2to1
		generic map	(	width => width	)
  	port map (	w1 => reg_out,
								w2 => input,
								f => reg_in,
								sel => loadEnable	);
	res <= reg_out;

process(ARESETN, CLK)
begin
	if ARESETN = '0' then
		reg_out <= (others => '0');
	elsif rising_edge(CLK) then
		reg_out <= reg_in;
	end if;
end process;
end behavioral;

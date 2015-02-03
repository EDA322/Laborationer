LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY reg IS
	GENERIC( width: integer := 8 );
	PORT( CLK 	 : IN std_logic;
	      ARESETN	 : IN std_logic;
	      loadEnable : IN std_logic;
	      input         : IN std_logic_vector(width-1 DOWNTO 0);
	      res        : OUT std_logic_vector(width-1 DOWNTO 0)
	);
END reg;

	      	
ARCHITECTURE behavioral OF reg IS
SIGNAL reg_out : STD_LOGIC_VECTOR(width-1 downto 0);
SIGNAL reg_in : STD_LOGIC_VECTOR(width-1 downto 0);
COMPONENT mux2to1
	GENERIC ( width: integer:=8);
	PORT ( w1 : in STD_LOGIC_VECTOR(width-1 downto 0);
	       w2 : in STD_LOGIC_VECTOR(width-1 downto 0);	
	       f : out STD_LOGIC_VECTOR(width-1 downto 0);	
	       sel : in STD_LOGIC);
END COMPONENT;

BEGIN
mux : mux2to1 generic map(width => width)
	      port map (w1 => reg_out, w2 => input, f => reg_in, sel => loadEnable);

PROCESS( ARESETN, CLK)
BEGIN
	IF ARESETN = '0' then
		reg_out <= (OTHERS => '0');
	ELSIF rising_edge(CLK) then
		reg_out <= reg_in;
	END IF;
END PROCESS;

res <= reg_out;
END behavioral;
		



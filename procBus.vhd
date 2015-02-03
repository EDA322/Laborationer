LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY procBus IS    PORT ( INSTRUCTION : IN  std_logic_vector (7 DOWNTO 0);           DATA	       : IN  std_logic_vector (7 DOWNTO 0);           ACC 	       : IN  std_logic_vector (7 DOWNTO 0);           EXTDATA     : IN  std_logic_vector (7 DOWNTO 0);           OUTPUT      : OUT std_logic_vector (7 DOWNTO 0);           ERR         : OUT std_logic;           instrSEL    : IN  std_logic;           dataSEL     : IN  std_logic;           accSEL      : IN  std_logic;           extdataSEL  : IN  std_logic);END procBus;

ARCHITECTURE structure Of procBus IS
SIGNAL enc_sel: STD_LOGIC_VECTOR(1 downto 0);

COMPONENT mux4to1
	GENERIC ( width: integer:=8);
	PORT ( w1 : in STD_LOGIC_VECTOR(width-1 downto 0);
	       w2 : in STD_LOGIC_VECTOR(width-1 downto 0);
	       w3 : in STD_LOGIC_VECTOR(width-1 downto 0);
	       w4 : in STD_LOGIC_VECTOR(width-1 downto 0);	
	       f : out STD_LOGIC_VECTOR(width-1 downto 0);	
	       sel : in STD_LOGIC_VECTOR(1 downto 0));
END COMPONENT;
BEGIN
	ERR <= not ((not instrSEL and not dataSEL and not accSEL and not extdataSEL) or
		    (    instrSEL and not dataSEL and not accSEL and not extdataSEL) or
	            (not instrSEL and     dataSEL and not accSEL and not extdataSEL) or
	            (not instrSEL and not dataSEL and     accSEL and not extdataSEL) or
	            (not instrSEL and not dataSEL and not accSEL and     extdataSEL));
	mux: mux4to1
		generic map(width => 8)
		port map (w1 => INSTRUCTION, w2 => DATA, w3 => ACC, w4 => EXTDATA,
				f => OUTPUT, sel => enc_sel);
	enc_sel <= (instrSEL NOR dataSEL) & (instrSEL NOR accSEL);
END structure;


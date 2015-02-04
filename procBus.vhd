LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY procBus IS
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
END procBus;

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
-- Encoding for the bus mux selector.
-- s1 = a nor b
-- s0 = a nor c
	enc_sel <= (instrSEL nor dataSEL) & (instrSEL nor accSEL);
-- f = (a+c+d)·(a+b+c)·(b+c+d)·(a+b+d). This expression is valid given
-- that when no select signal is set, the mux selection is don't care.
	ERR <= (instrSEL or dataSEL or accSEL)     and
		   (instrSEL or dataSEL or extdataSEL) and
		   (instrSEL or accSEL  or extdataSEL) and
		   (dataSEL  or accSEL  or extdataSEL);
	mux: mux4to1
		generic map(width => 8)
		port map (w1 => INSTRUCTION, w2 => DATA, w3 => ACC, w4 => EXTDATA,
				f => OUTPUT, sel => enc_sel);
END structure;


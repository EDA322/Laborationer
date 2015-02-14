library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity procBus is
    port ( INSTRUCTION : in  std_logic_vector (7 downto 0);
           DATA	       : in  std_logic_vector (7 downto 0);
           ACC 	       : in  std_logic_vector (7 downto 0);
           EXTDATA     : in  std_logic_vector (7 downto 0);
           OUTPUT      : OUT std_logic_vector (7 downto 0);
           ERR         : OUT std_logic;
           instrSEL    : in  std_logic;
           dataSEL     : in  std_logic;
           accSEL      : in  std_logic;
           extdataSEL  : in  std_logic  );
end procBus;

architecture structure of procBus is
signal enc_sel: std_logic_vector(1 downto 0);

component mux4to1
  generic ( width: integer:=8 );
	port ( w1  : in std_logic_vector(width-1 downto 0);
	       w2  : in std_logic_vector(width-1 downto 0);
	       w3  : in std_logic_vector(width-1 downto 0);
	       w4  : in std_logic_vector(width-1 downto 0);
	       f   : out std_logic_vector(width-1 downto 0);
	       sel : in std_logic_vector(1 downto 0) );
end component;
begin
-- Encoding for the bus mux selector.
-- s1 = a nor b
-- s0 = a nor c
	enc_sel <= (instrSEL nor dataSEL) & (instrSEL nor accSEL);
-- f = (a+c+d)·(a+b+c)·(b+c+d)·(a+b+d). This expression is valid given
-- that when no select signal is set, the mux selection is don't care.
	ERR <=
    (instrSEL or dataSEL or accSEL)     and
		(instrSEL or dataSEL or extdataSEL) and
    (instrSEL or accSEL  or extdataSEL) and
    (dataSEL  or accSEL  or extdataSEL);
	mux: mux4to1
		generic map(  width => 8)
		port map (  w1 => INSTRUCTION,
                w2 => DATA,
                w3 => ACC,
                w4 => EXTDATA,
				        f => OUTPUT,
                sel => enc_sel  );
end structure;

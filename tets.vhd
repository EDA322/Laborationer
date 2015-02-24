
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY tets IS
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
END tets;


--zero<='0';
--			   FlagInp(1), CLK, ARESETN, pcSel, pcLd, instrLd, addrMd,
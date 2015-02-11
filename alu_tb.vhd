LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY alu_tb IS
END alu_tb;

ARCHITECTURE behavioral OF alu_tb IS

COMPONENT alu_wCLA
PORT( ALU_inA, ALU_inB            : in STD_LOGIC_VECTOR(7 downto 0);
	  Operation                   : in STD_LOGIC_VECTOR(1 downto 0);
	  ALU_out                     : out STD_LOGIC_VECTOR(7 downto 0);
	  Carry, NotEq, Eq, isOutZero : out STD_LOGIC);
END COMPONENT;

COMPONENT alu_wRCA
PORT( ALU_inA, ALU_inB            : in STD_LOGIC_VECTOR(7 downto 0);
	  Operation                   : in STD_LOGIC_VECTOR(1 downto 0);
	  ALU_out                     : out STD_LOGIC_VECTOR(7 downto 0);
	  Carry, NotEq, Eq, isOutZero : out STD_LOGIC);
END COMPONENT;

SIGNAL A, B, OutputCLA, OutputRCA: std_logic_vector(7 downto 0);
SIGNAL op: std_logic_vector(1 downto 0);
SIGNAL cCLA, cRCA, neqCLA, neqRCA, eqCLA, eqRCA, zeroCLA, zeroRCA: std_logic;

BEGIN
	alu_1: alu_wCLA
		port map (A, B, op, OutputCLA, cCLA, neqCLA, eqCLA, zeroCLA);
	alu_2: alu_wRCA
		port map (A, B, op, OutputRCA, cRCA, neqRCA, eqRCA, zeroRCA);
process
BEGIN
	A <= "11001100";
	B <= "00110011";
	op <= "00";
	wait for 1 ns;
	op <= "01";
	wait for 1 ns;
	op <= "10";
	wait for 1 ns;
	op <= "11";
	wait for 1 ns;
	op <= "00";
	B <= A;
	wait for 1 ns;
	op <= "01";
	wait for 1 ns;
END process;
END behavioral;
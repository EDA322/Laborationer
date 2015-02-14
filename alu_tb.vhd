library ieee;
use ieee.std_logic_1164.all;

entity alu_tb is
end alu_tb;

architecture behavioral of alu_tb is

component alu_wCLA
port (	ALU_inA, ALU_inB  	         	: in std_logic_vector(7 downto 0);
	  	 	Operation                   	: in std_logic_vector(1 downto 0);
	  	 	ALU_out                     	: out std_logic_vector(7 downto 0);
	  	 	Carry, NotEq, Eq, isOutZero 	: out std_logic	);
end component;

component alu_wRCA
port (	ALU_inA, ALU_inB            	: in std_logic_vector(7 downto 0);
	  		Operation                   	: in std_logic_vector(1 downto 0);
	  		ALU_out                     	: out std_logic_vector(7 downto 0);
	  		Carry, NotEq, Eq, isOutZero 	: out std_logic	);
end component;

signal A, B, OutputCLA, OutputRCA			: std_logic_vector(7 downto 0);
signal op															: std_logic_vector(1 downto 0);
signal cCLA, cRCA, neqCLA, neqRCA,
	eqCLA, eqRCA, zeroCLA, zeroRCA			: std_logic;

begin
	alu_1: alu_wCLA
		port map (A, B, op, OutputCLA, cCLA, neqCLA, eqCLA, zeroCLA	);
	alu_2: alu_wRCA
		port map (A, B, op, OutputRCA, cRCA, neqRCA, eqRCA, zeroRCA	);
process
begin
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
end process;
end behavioral;

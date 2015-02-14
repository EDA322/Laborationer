library ieee;
use ieee.std_logic_1164.all;

entity alu_wCLA is
	port ( 	ALU_inA, ALU_inB 						: in std_logic_vector(7 downto 0);
	      	Operation 									: in std_logic_vector(1 downto 0);
	      	ALU_out 										: out std_logic_vector(7 downto 0);
	      	Carry, NotEq, Eq, isOutZero : out std_logic	);
end alu_wCLA;

architecture alu_structure of alu_wCLA is

-- Operation Outputs
signal add_out  	: std_logic_vector(7 downto 0);
signal sub_out  	: std_logic_vector(7 downto 0);
signal nand_out 	: std_logic_vector(7 downto 0);
signal not_out  	: std_logic_vector(7 downto 0);

-- Adder internal signals
signal bsignal  	: std_logic_vector(7 downto 0);
signal sub      	: std_logic;
signal cla_out  	: std_logic_vector(7 downto 0);

-- Operation selector
signal mux_out  	: std_logic_vector(7 downto 0);

-- Components
component cmp
	port ( 	a, b 		: in std_logic_vector(7 downto 0);
	      	eq, neq : out std_logic	);
end component;

component cla
	port ( 	a, b 		: in std_logic_vector(7 downto 0);
        	cin 		: in std_logic;
	      	s    		: out std_logic_vector(7 downto 0);
	      	cout 		: out std_logic	);
end component;

begin
-- nand
	nand_out <= ALU_inA nand ALU_inB;
-- not
	not_out <= not ALU_inA;
-- ADD and SUB
	sub <= Operation(0);
	bsignal <=
		(ALU_inB(7) xor sub) & (ALU_inB(6) xor sub) &
   	(ALU_inB(5) xor sub) & (ALU_inB(4) xor sub) &
   	(ALU_inB(3) xor sub) & (ALU_inB(2) xor sub) &
   	(ALU_inB(1) xor sub) & (ALU_inB(0) xor sub);
	cla_8bit : cla
		port map (ALU_inA, bsignal, sub, cla_out, Carry	);
	add_out <= cla_out;
	sub_out <= cla_out;
-- MUX
	with Operation select
		mux_out <=
			add_out when "00",
			sub_out when "01",
			nand_out when "10",
	   	not_out when others;
-- CMP
	cmp_ab : cmp
		port map (ALU_inA, ALU_inB, Eq, NotEq	);
-- isOutZero
	cmp_zero : cmp
		port map ("00000000", mux_out, isOutZero, open	);
-- ALU_out
	ALU_out <= mux_out;

end alu_structure;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

ENTITY alu_wRCA IS
	PORT( ALU_inA, ALU_inB : in STD_LOGIC_VECTOR(7 downto 0);
	      Operation : in STD_LOGIC_VECTOR(1 downto 0);
	      ALU_out : out STD_LOGIC_VECTOR(7 downto 0);
	      Carry, NotEq, Eq, isOutZero : out STD_LOGIC);
END alu_wRCA;

ARCHITECTURE alu_structure OF alu_wRCA IS

-- Operation Outputs
SIGNAL add_out : STD_LOGIC_VECTOR(7 downto 0);
SIGNAL sub_out : STD_LOGIC_VECTOR(7 downto 0);
SIGNAL nand_out : STD_LOGIC_VECTOR(7 downto 0);
SIGNAL not_out : STD_LOGIC_VECTOR(7 downto 0);

-- Adder internal signals
SIGNAL bsignal : STD_LOGIC_VECTOR(7 downto 0);
SIGNAL sub : STD_LOGIC;
SIGNAL rca_out : STD_LOGIC_VECTOR(7 downto 0);

-- Operation selector
SIGNAL mux_out : STD_LOGIC_VECTOR(7 downto 0);

-- Components
COMPONENT cmp
	PORT( a, b : in STD_LOGIC_VECTOR(7 downto 0);
	      eq, neq : out STD_LOGIC);
END COMPONENT;

COMPONENT rca 
	PORT( a, b : in STD_LOGIC_VECTOR(7 downto 0);
              cin  : in STD_LOGIC;
	      s    : out STD_LOGIC_VECTOR(7 downto 0);
	      cout : out STD_LOGIC);
END COMPONENT;

BEGIN
-- NAND
	nand_out <= ALU_inA NAND ALU_inB;
-- NOT
	not_out <= NOT ALU_inA;
-- ADD and SUB
	sub <= Operation(0);
	bsignal <= (ALU_inB(7) XOR sub)& (ALU_inB(6) XOR sub)& (ALU_inB(5) XOR sub)& (ALU_inB(4) XOR sub)& (ALU_inB(3) XOR sub)& (ALU_inB(2) XOR sub)& (ALU_inB(1) XOR sub)& (ALU_inB(0) XOR sub); 
	rca_8bit : rca port map (ALU_inA, bsignal, sub, rca_out, Carry);
	add_out <= rca_out;
	sub_out <= rca_out;
-- MUX
	WITH Operation SELECT
		mux_out <= add_out WHEN "00",
			   sub_out WHEN "01",
			   nand_out WHEN "10",
			   not_out WHEN OTHERS;
-- CMP
	cmp_ab : cmp port map (ALU_inA, ALU_inB, Eq, NotEq);
-- isOutZero
	cmp_zero : cmp port map ("00000000", mux_out, isOutZero, open);
-- ALU_out
	ALU_out <= mux_out;

END alu_structure;
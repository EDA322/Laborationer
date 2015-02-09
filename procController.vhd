library ieee;
use ieee.std_logic_1164.all;

entity procController is
    Port ( master_load_enable : in  STD_LOGIC;
		   opcode 			  : in  STD_LOGIC_VECTOR (3 downto 0);
		   neq 				  : in  STD_LOGIC;
		   eq 				  : in  STD_LOGIC; 
		   CLK 				  : in  STD_LOGIC;
		   ARESETN 			  : in  STD_LOGIC;
		   pcSel 			  : out STD_LOGIC;
		   pcLd 			  : out STD_LOGIC;
		   instrLd 			  : out STD_LOGIC;
		   addrMd 			  : out STD_LOGIC;
		   dmWr 			  : out STD_LOGIC;
		   dataLd 			  : out STD_LOGIC;
		   flagLd 			  : out STD_LOGIC;
		   accSel 			  : out STD_LOGIC;
		   accLd 			  : out STD_LOGIC;
		   im2bus 			  : out STD_LOGIC;
		   dmRd 			  : out STD_LOGIC;
		   acc2bus 			  : out STD_LOGIC;
		   ext2bus 			  : out STD_LOGIC;
		   dispLd			  : out STD_LOGIC;
		   aluMd 			  : out STD_LOGIC_VECTOR(1 downto 0));
end procController;

architecture behavioral of procController is
type state is (FE, DE, DE_2, EX, ME);
signal mealy_state: state 					  := EX;
signal control: std_logic_vector(15 downto 0) := (others => '0');

function nextState(currentState: in state; op: in std_logic_vector(3 downto 0))
		return state is
	begin
	if currentState = FE then
		return DE;
	elsif currentState = DE then
		if ((op(3) and op(2) and not op(1))
				or (op(3) and op(1) and (op(2) xor op(0)))) = '1' then
			return FE;
		elsif (op(3) and not op(2) and not (op(1) and op(0))) = '1' then
			return DE_2;
		elsif ((not op(3) and not (op(2) and op(1)))
				or (op(2) and op(1) and (op(3) xor not op(0)))) ='1' then
			return EX;
		elsif op = "0111" then
			return ME;
		end if;
	elsif currentState = DE_2 then
		if (op(3) and not op(2) and not op(1)) = '1' then
			return EX;
		elsif op = "1010" then
			return ME;
		end if;
	else
		return FE;
	end if; 
end function;

begin
combinatorial: process(CLK, ARESETN)
begin
	if ARESETN = '0' then
		mealy_state <= EX;
	elsif rising_edge(CLK) then
		if master_load_enable = '1' then
			mealy_state <= nextState(mealy_state, opcode);
		end if;
	end if;
end process;

output: process(CLK, ARESETN)
variable op: std_logic_vector(3 downto 0);
begin
	for i in 0 to 3 loop
		op(i) := opcode(i);
	end loop;
	if ARESETN='0' then
		control <= (others => '0');
	elsif rising_edge(CLK) then
   		if master_load_enable = '1' then
   			-- All states
   			control <= (others => '0');
   			control(13) <= '1';		-- instrLd
   			if (op(3) and op(2) and not (op(1) and op(0))) = '1' then
 	  			control(6) <= '1';	-- im2bus
   			end if;
   			if (op = "0111" or op = "1010") then 
	   			control(4) <= '1';	-- acc2bus
   			end if;
   			if (op = "1011") then
   				control(3) <= '1';	-- ext2bus
			end if;
   			if ((op(2) and not op(1))
   					or (not op(3) and op(1) and op(0))) = '1' then
	   			control(1) <= '1';	-- aluMd(1)
   			end if;
   			if ((op(2) and not op(1))
   					or (op(1) and not op(0))) = '1' then
	   			control(0) <= '1';	-- aluMd(0)
   			end if;
   			-- Decode state
   			if nextState(mealy_state, opcode) = DE then
   				if (op = "1100" or ((op = "1101") and (eq = '1'))
   						or ((op = "1110") and (neq = '1'))) then
	   				control(15) <= '1';	-- pcSel
				end if;
   				if ((op(3) and op(2) and not op(1))
   						or (op(3) and op(1) and (op(2) xor op(0)))) = '1' then
	   				control(14) <= '1';	-- pcLd
				end if;   		
   				if (op = "1011") then
	   				control(11) <= '1';	-- dmWr
   				end if;
   				if (not (op(3) and op(2)) and not (op(2) and op(1) and op(0))
   						and not (op(3) and op(1) and op(0))) = '1' then
	   				control(10) <= '1';	-- dataLd
   				end if;
   			-- Second decode state
   			elsif nextState(mealy_state, opcode) = DE_2 then
   				if (op(3) and not op(2) and not op(1)) = '1' then
	   				control(12) <= '1';	-- addrMd
   				end if;
   				if (op(3) and not op(2) and not op(1)) = '1' then
	   				control(10) <= '1';	-- dataLd
   				end if;
   			-- Execute state
   			elsif nextState(mealy_state, opcode) = EX then
   				if (not (op(3) and op(2) and not op(1))
   						and not (op(3) and not op(2) and op(1))
   						and not (op(3) and op(1) and not op(0))
   						and not (not op(3) and op(2) and op(1) and op(0))) = '1' then
	   				control(14) <= '1';	-- pcLd
   				end if;
   				if (not (op(3) or op(1)) or not (op(3) or op(2))
   						or not (op(2) or op(1) or op(0))) = '1' then
	   				control(9) <= '1';	-- flagLd
   				end if;
   				if (op = "0110" or op = "1001") then
	   				control(8) <= '1';	-- accSel
   				end if;
   				if (not (op(3) or op(2)) or not (op(3) or op(0))
   						or not (op(2) or op(1))) = '1' then
	   				control(7) <= '1';	-- accLd
   				end if;
   				if (not (op(3) and op(2)) and not (op(3) and op(1)) 
   						and not (op(2) and op(1) and op(0))) = '1' then
	   				control(5) <= '1';	-- dmRd
   				end if;
   				if (op = "1111") then
	   				control(2) <= '1';	-- dispLd
   				end if;
   			-- Memory state
   			elsif nextState(mealy_state, opcode) = ME then
   				if (op = "0111" or op = "1010") then
	   				control(14) <= '1';	-- pcLd
   				end if;
   				if (op = "1010") then
	   				control(12) <= '1';	-- addrMd
   				end if;
   				if (op = "0111" or op = "1010") then
	   				control(11) <= '1';	-- dmWr
   				end if;
   			end if;
   	  	end if;
  	end if;
end process;

	pcSel 	<= control(15);
	pcLd 	<= control(14);
	instrLd <= control(13); 
	addrMd	<= control(12);
	dmWr 	<= control(11);
	dataLd 	<= control(10);
	flagLd 	<= control(9);
	accSel 	<= control(8);
	accLd 	<= control(7);
	im2bus 	<= control(6);
	dmRd 	<= control(5);
	acc2bus <= control(4);
	ext2bus <= control(3);
	dispLd 	<= control(2);
	aluMd 	<= control(1 downto 0);
end behavioral;




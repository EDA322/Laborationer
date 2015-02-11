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
signal mealy_state: state := EX;
signal next_state: state  := FE;
signal control: std_logic_vector(15 downto 0);

begin
combinatorial: process(opcode, mealy_state)
begin
	if mealy_state = FE then
		next_state <= DE;
	elsif mealy_state = DE then
		if (opcode(3) and ((opcode(2) and not opcode(1))
				or (opcode(1) and (opcode(2) xor opcode(0))))) = '1' then
			next_state <= FE;
		elsif (opcode(3) and not opcode(2)
				and (opcode(1) nand opcode(0))) = '1' then
			next_state <= DE_2;
		elsif ((not opcode(3) and (opcode(2) nand opcode(1)))
				or (opcode(2) and opcode(1)
					and (opcode(3) xor not opcode(0)))) ='1' then
			next_state <= EX;
		elsif opcode = "0111" then
			next_state <= ME;
		end if;
	elsif mealy_state = DE_2 then
		if (opcode(3) and not opcode(2) and not opcode(1)) = '1' then
			next_state <= EX;
		elsif opcode = "1010" then
			next_state <= ME;
		end if;
	else
		next_state <= FE;
	end if;
end process;

output: process(CLK, ARESETN)
begin
	if ARESETN='0' then
		control <= (others => '0');
		mealy_state <= EX;
	elsif rising_edge(CLK) then
   		if master_load_enable = '1' then
   			-- All states
   			control <= (others => '0');
   			control(13) <= '1';		-- instrLd
   			if (opcode(3) and opcode(2)
   					and not (opcode(1) and opcode(0))) = '1' then
 	  			control(6) <= '1';	-- im2bus
   			end if;
   			if (opcode = "0111" or opcode = "1010") then 
	   			control(4) <= '1';	-- acc2bus
   			end if;
   			if (opcode = "1011") then
   				control(3) <= '1';	-- ext2bus
			end if;
   			if ((opcode(2) and not opcode(1))
   					or (not opcode(3) and opcode(1) and opcode(0))) = '1' then
	   			control(1) <= '1';	-- aluMd(1)
   			end if;
   			if ((opcode(2) and not opcode(1))
   					or (opcode(1) and not opcode(0))) = '1' then
	   			control(0) <= '1';	-- aluMd(0)
   			end if;
   			-- Decode state
   			if next_state = DE then
   				if (opcode = "1100" or (opcode = "1101" and eq = '1')
   						or (opcode = "1110" and neq = '1')) then
	   				control(15) <= '1';	-- pcSel
				end if;
   				if ((opcode(3) and opcode(2) and not opcode(1))
   						or (opcode(3) and opcode(1)
   							and (opcode(2) xor opcode(0)))) = '1' then
	   				control(14) <= '1';	-- pcLd
				end if;   		
   				if (opcode = "1011") then
	   				control(11) <= '1';	-- dmWr
   				end if;
   				if (not (opcode(3) and opcode(2))
   						and not (opcode(2) and opcode(1) and opcode(0))
   						and not (opcode(3) and opcode(1) and opcode(0))) = '1' then
	   				control(10) <= '1';	-- dataLd
   				end if;
   			-- Second decode state
   			elsif next_state = DE_2 then
   				if (opcode(3) and not opcode(2) and not opcode(1)) = '1' then
	   				control(12) <= '1';	-- addrMd
   				end if;
   				if (opcode(3) and not opcode(2) and not opcode(1)) = '1' then
	   				control(10) <= '1';	-- dataLd
   				end if;
   			-- Execute state
   			elsif next_state = EX then
   				if (not (opcode(3) and opcode(2) and not opcode(1))
   						and not (opcode(3) and not opcode(2) and opcode(1))
   						and not (opcode(3) and opcode(1) and not opcode(0))
   						and not (not opcode(3) and opcode(2)
   							and opcode(1) and opcode(0))) = '1' then
	   				control(14) <= '1';	-- pcLd
   				end if;
   				if (not (opcode(3) or opcode(1))
   						or not (opcode(3) or opcode(2))
   						or not (opcode(2) or opcode(1) or opcode(0))) = '1' then
	   				control(9) <= '1';	-- flagLd
   				end if;
   				if (opcode = "0110" or opcode = "1001") then
	   				control(8) <= '1';	-- accSel
   				end if;
   				if (not (opcode(3) or opcode(2)) or not (opcode(3) or opcode(0))
   						or not (opcode(2) or opcode(1))) = '1' then
	   				control(7) <= '1';	-- accLd
   				end if;
   				if (not (opcode(3) and opcode(2)) and not (opcode(3) and opcode(1)) 
   						and not (opcode(2) and opcode(1) and opcode(0))) = '1' then
	   				control(5) <= '1';	-- dmRd
   				end if;
   				if (opcode = "1111") then
	   				control(2) <= '1';	-- dispLd
   				end if;
   			-- Memory state
   			elsif next_state = ME then
   				if (opcode = "0111" or opcode = "1010") then
	   				control(14) <= '1';	-- pcLd
   				end if;
   				if (opcode = "1010") then
	   				control(12) <= '1';	-- addrMd
   				end if;
   				if (opcode = "0111" or opcode = "1010") then
	   				control(11) <= '1';	-- dmWr
   				end if;
   			end if;
   	  	end if;
   	  	
   	  	mealy_state <= next_state;
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




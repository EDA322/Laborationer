library ieee;
use ieee.std_logic_1164.all;

entity procController is
    port (  master_load_enable  : in  std_logic;
            opcode              : in  std_logic_vector (3 downto 0);
            neq 				        : in  std_logic;
            eq                  : in  std_logic;
            CLK                 : in  std_logic;
            ARESETN             : in  std_logic;
            pcSel               : out std_logic;
            pcLd                : out std_logic;
            instrLd             : out std_logic;
            addrMd              : out std_logic;
            dmWr                : out std_logic;
            dataLd              : out std_logic;
            flagLd              : out std_logic;
            accSel              : out std_logic;
            accLd               : out std_logic;
            im2bus              : out std_logic;
            dmRd                : out std_logic;
            acc2bus 			      : out std_logic;
            ext2bus             : out std_logic;
            dispLd              : out std_logic;
            aluMd               : out std_logic_vector(1 downto 0));
end procController;

architecture behavioral of procController is
type state is (FE, DE, DE_2, EX, ME);
signal mealy_state: state;
signal next_state: state := FE;
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
			mealy_state <= next_state;
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
   			if mealy_state = DE then
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
   			elsif mealy_state = DE_2 then
   				if (opcode(3) and not opcode(2) and not opcode(1)) = '1' then
	   				control(12) <= '1';	-- addrMd
   				end if;
   				if (opcode(3) and not opcode(2) and not opcode(1)) = '1' then
	   				control(10) <= '1';	-- dataLd
   				end if;
   			-- Execute state
   			elsif mealy_state = EX then
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
   			elsif mealy_state = ME then
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

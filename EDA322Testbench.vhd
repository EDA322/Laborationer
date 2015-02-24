library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;

entity EDA322Testbench is
end EDA322Testbench;

architecture behavioral of EDA322Testbench is

type vector_array is array (0 to 65) of std_logic_vector(7 downto 0);

impure function read_vector_file(file_name : in string; length: in integer)
		return vector_array is
  file vector_file 		: text open read_mode is file_name;
  variable vector : line;
  variable temp_bv 	: bit_vector(7 downto 0);
  variable temp_arr : vector_array;
begin
  for i in 0 to (length-1) loop
    readline(vector_file, vector);
  	read(vector, temp_bv);
    temp_arr(i) := to_stdlogicvector(temp_bv);
  end loop;
  return temp_arr;
end function;

-- Clock, reset and master load enable
signal clk: std_logic := '0';
signal master_load_enable: std_logic := '0';
signal aresetn: std_logic := '0';

-- Vectors
signal acctrace: vector_array := read_vector_file("acctrace.txt", 30);
signal disptrace: vector_array := read_vector_file("disptrace.txt", 10);
signal dMemOuttrace: vector_array := read_vector_file("dMemOuttrace.txt", 20);
signal flagtrace: vector_array := read_vector_file("flagtrace.txt", 20);
signal pctrace: vector_array := read_vector_file("pctrace.txt", 66);

-- Register signals
signal accSeg: std_logic_vector(7 downto 0);
signal dispSeg: std_logic_vector(7 downto 0);
signal dMemOutSeg: std_logic_vector(7 downto 0);
signal flagSeg: std_logic_vector(3 downto 0);
signal pcSeg: std_logic_vector(7 downto 0);

-- Counters
signal clk_counter: integer := 0;
signal acc_counter: integer := 0;
signal disp_counter: integer := 0;
signal dMemOut_counter: integer := 0;
signal flag_counter: integer := 0;
signal pc_counter: integer := 0;

begin
	proc: entity work.EDA322_processor
		port map (externalIn => (others => '0'),
	       CLK => clk,
	       master_load_enable => master_load_enable,
	       ARESETN => aresetn,
	       pc2seg => pcSeg,
	       instr2seg => open,
	       Addr2seg => open,
	       dMemOut2seg => dMemOutSeg,
	       aluOut2seg => open,
	       acc2seg => accSeg,
	       flag2seg => flagSeg,
	       busOut2seg => open,
	       disp2seg => dispSeg,
	       errSig2seg => open,
	       ovf => open,
	       zero => open
	);

	clk <= not clk after 5 ns;
reset: process(clk)
begin
	if rising_edge(clk) then
		clk_counter <= clk_counter + 1;
		master_load_enable <= not master_load_enable;
	else
		master_load_enable <= not master_load_enable;
	end if;
	if clk_counter = 2 then
		aresetn <= '1'; -- release reset
	end if;
end process;

pc: process(pcSeg)
begin
	if aresetn = '1' then
		assert (pcSeg = pctrace(pc_counter))
			report "Read mismatch at line " & integer'IMAGE(pc_counter+1)
				& " in file pctrace.txt"
			severity failure;
		pc_counter <= pc_counter + 1;
	end if;
end process;

dMemOut: process(dMemOutSeg)
begin
	if aresetn = '1' then
		assert (dMemOutSeg = dMemOuttrace(dMemOut_counter))
			report "Read mismatch at line " & integer'IMAGE(dMemOut_counter+1)
				& " in file dMemOuttrace.txt"
			severity failure;
		dMemOut_counter <= dMemOut_counter + 1;
	end if;
end process;

acc: process(accSeg)
begin
	if aresetn = '1' then
		assert (accSeg = acctrace(acc_counter))
			report "Read mismatch at line " & integer'IMAGE(acc_counter+1)
				& " in file acctrace.txt"
			severity failure;
		acc_counter <= acc_counter + 1;
	end if;
end process;

flag: process(flagSeg)
begin
	if aresetn = '1' then
		assert ("0000" & flagSeg = flagtrace(flag_counter))
			report "Read mismatch at line " & integer'IMAGE(flag_counter+1)
				& " in file flagtrace.txt"
			severity failure;
		flag_counter <= flag_counter + 1;
	end if;
end process;

disp: process(dispSeg)
begin
	if aresetn = '1' then
		assert (dispSeg = disptrace(disp_counter))
			report "Read mismatch at line " & integer'IMAGE(disp_counter+1)
				& " in file pctrace.txt"
			severity error;
		disp_counter <= disp_counter + 1;
		if dispSeg = "10010000" then
			report "Test successful."
			severity failure;
		end if;
	end if;
end process;
end behavioral;

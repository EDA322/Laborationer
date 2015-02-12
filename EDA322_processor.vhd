LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
USE work.procComponents.all;

ENTITY EDA322_processor IS
	Port ( externalIn 	  : IN  std_logic_vector(7 DOWNTO 0);  -- "extIn" in Figure 1
	       CLK 		  : IN  std_logic;
	       master_load_enable : IN  std_logic;
	       ARESETN 	   	  : IN  std_logic;
	       pc2seg 	 	  : OUT std_logic_vector(7 DOWNTO 0);  -- PC
	       instr2seg 	  : OUT std_logic_vector(11 DOWNTO 0); -- Instruction register
	       Addr2seg   	  : OUT std_logic_vector(7 DOWNTO 0);  -- Address register
	       dMemOut2seg 	  : OUT std_logic_vector(7 DOWNTO 0);  -- Data memory output
	       aluOut2seg  	  : OUT std_logic_vector(7 DOWNTO 0);  -- ALU output
	       acc2seg 	   	  : OUT std_logic_vector(7 DOWNTO 0);  -- Accumulator
	       flag2seg    	  : OUT std_logic_vector(3 DOWNTO 0);  -- Flags
	       busOut2seg  	  : OUT std_logic_vector(7 DOWNTO 0);  -- Value on the bus
	       disp2seg   	  : OUT std_logic_vector(7 DOWNTO 0);   -- Display register
	       errSig2seg  	  : OUT std_logic;                      -- Bus Error signal
	       ovf	   	  : OUT std_logic;                      -- Overflow
	       zero 	   	  : OUT std_logic);			-- Zero
END EDA322_processor;

ARCHITECTURE structure OF EDA322_processor IS 
-- Controller outputs
SIGNAL pcSel, accSel, addrMd: STD_LOGIC;				-- Selectors to muxes
SIGNAL aluMd: STD_LOGIC_VECTOR(1 downto 0);				-- Selector to ALU
SIGNAL im2bus, dmRd, acc2bus, ext2bus: STD_LOGIC;			-- Selectors to bus input
SIGNAL pcLd, instrLd, dmWr, dataLd, accLd, dispLd, flagLd: STD_LOGIC; 	-- Load signals to registers and data memory

-- Bus output
SIGNAL busOut:  STD_LOGIC_VECTOR(7 DOWNTO 0);

-- ALU and PC-incrementor outputs
SIGNAL aluOut: STD_LOGIC_VECTOR(7 downto 0);
SIGNAL pcIncOut: STD_LOGIC_VECTOR(7 downto 0);
SIGNAL FlagInp: STD_LOGIC_VECTOR(3 downto 0);

-- Mux outputs
SIGNAL nxtpc, Addr, aluMuxOut: STD_LOGIC_VECTOR(7 downto 0);

-- Memory unit outputs
SIGNAL InstrMemOut: STD_LOGIC_VECTOR(11 downto 0);
SIGNAL DataMemOut: STD_LOGIC_VECTOR(7 downto 0);

-- Register outputs
SIGNAL FRegOut: STD_LOGIC_VECTOR(3 downto 0);
SIGNAL PC, MemDataOutReged, OutFromAcc: STD_LOGIC_VECTOR(7 downto 0);
SIGNAL Instruction: STD_LOGIC_VECTOR(11 downto 0);

BEGIN
-- Processor controller
	controller: procController 
		port map ( master_load_enable, Instruction(11 downto 8), FlagInp(2),
				   FlagInp(1), CLK, ARESETN, pcSel, pcLd, instrLd, addrMd,
				   dmWr, dataLd, flagLd, accSel, accLd, im2bus, dmRd, acc2bus,
				   ext2bus, dispLd, aluMd );

-- Processor bus
	theBus: procBus
		port map (INSTRUCTION => Instruction(7 downto 0), DATA => MemDataOutReged,
			  ACC => OutFromAcc, EXTDATA => externalIn, OUTPUT => busOut,
			  ERR => errSig2seg, instrSEL => im2bus, dataSEL => dmRd,
			  accSEL => acc2bus, extdataSEL => ext2bus);
	busOut2seg <= busOut;
-- ALU and PC-incrementor
	alu: alu_wRCA
		port map (ALU_inA => OutFromAcc, ALU_inB => busOut, Operation => aluMd, ALU_out => aluOut,
			  Carry => FlagInp(3), NotEq => FlagInp(2), Eq => FlagInp(1),
			  isOutZero => FlagInp(0));
	pcInc: alu_wRCA
		port map (ALU_inA => "00000001", ALU_inB => PC, Operation => "00",
			  ALU_out => pcIncOut, Carry => open, NotEq => open, Eq => open,
			  isOutZero => open);
		
-- Memory units
	InstructionMemory: mem_array
		generic map (DATA_WIDTH => 12, ADDR_WIDTH => 8, INIT_FILE => "inst_mem.mif")
		port map (ADDR => pc, DATA_IN => (OTHERS => '0'), CLK => CLK, WE => '0',
				  OUTPUT => InstrMemOut);
	DataMemory: mem_array
		generic map (DATA_WIDTH => 8, ADDR_WIDTH => 8, INIT_FILE => "data_mem.mif")
		port map (ADDR => Addr, DATA_IN => busOut, CLK => CLK, WE => dmWr,
				  OUTPUT => DataMemOut);
-- Muxes
	pcMux: mux2to1
		generic map (width => 8)
		port map (w1 => pcIncOut, w2 => busOut, f => nxtpc, sel => pcSel);
	addrMux: mux2to1
		generic map (width => 8)
		port map (w1 => Instruction(7 downto 0), w2 => MemDataOutReged, f => Addr, sel => addrMd);
	aluMux:	mux2to1
		generic map (width => 8)
		port map (w1 => aluOut, w2 => busOut, f => aluMuxOut, sel => accSel);
-- Registers
	FE: reg
		generic map (width => 8)
		port map (CLK, ARESETN, loadEnable => pcLd,
				  input => nxtpc, res => PC);
	FE_DE: reg
		generic map (width => 12)
		port map (CLK, ARESETN, loadEnable => instrLd,
				  input => InstrMemOut, res => Instruction);
	DE_EX: reg
		generic map (width => 8)
		port map (CLK, ARESETN, loadEnable => dataLd,
				  input => MemDataOutReged, res => MemDataOutReged);
	ACC: reg
		generic map (width => 8)
		port map (CLK, ARESETN, loadEnable => accLd,
				  input => aluMuxOut, res => OutFromAcc);
	Display: reg
		generic map (width => 8)
		port map (CLK, ARESETN, loadEnable => dispLd,
				  input => OutFromACC, res => disp2seg);
	FReg: reg
		generic map (width => 4)
		port map (CLK, ARESETN, loadEnable => flagLd,
				  input => FlagInp, res => FRegOut);
-- Displays and flags
	pc2seg 		<= pc;
	instr2seg	<= Instruction;
	Addr2seg	<= Addr;
	dMemOut2seg 	<= MemDataOutReged;
	aluOut2seg	<= aluOut;
	acc2seg 	<= OutFromAcc;
	flag2seg	<= FRegOut;
	ovf		<= FlagInp(3);
	zero		<= FlagInp(0);
END structure;

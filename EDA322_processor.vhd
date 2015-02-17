library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.procComponents.all;

entity EDA322_processor is
	port ( externalIn 					: in  std_logic_vector(7 downto 0);
	       CLK 		  						: in  std_logic;
	       master_load_enable 	: in  std_logic;
	       ARESETN 	   	  			: in  std_logic;
	       pc2seg 	 	  				: out std_logic_vector(7 downto 0);
	       instr2seg 	  				: out std_logic_vector(11 downto 0);
	       Addr2seg   	  			: out std_logic_vector(7 downto 0);
	       dMemOut2seg 	 	 			: out std_logic_vector(7 downto 0);
	       aluOut2seg  	  			: out std_logic_vector(7 downto 0);
	       acc2seg 	   	  			: out std_logic_vector(7 downto 0);
	       flag2seg    	  			: out std_logic_vector(3 downto 0);
	       busOut2seg  	  			: out std_logic_vector(7 downto 0);
	       disp2seg   	  			: out std_logic_vector(7 downto 0);
	       errSig2seg  	  			: out std_logic;
	       ovf	   	  					: out std_logic;
	       zero 	   	  				: out std_logic	);
end EDA322_processor;

architecture structure of EDA322_processor is
---- Controller outputs ----
-- Selectors to muxes
signal pcSel, accSel, addrMd						: std_logic;
-- Selector to ALU
signal aluMd														: std_logic_vector(1 downto 0);
-- Selectors to bus input
signal im2bus, dmRd, acc2bus, ext2bus		: std_logic;
-- Load signals to registers and data memory
signal pcLd, instrLd, dmWr, dataLd,
	accLd, dispLd,flagLd									: std_logic;

---- Bus output ----
signal busOut														: std_logic_vector(7 downto 0);

---- ALU and PC-incrementor outputs ----
signal aluOut														: std_logic_vector(7 downto 0);
signal pcIncOut													: std_logic_vector(7 downto 0);
signal FlagInp													: std_logic_vector(3 downto 0);

---- Mux outputs ----
signal nxtpc, Addr, aluMuxOut						: std_logic_vector(7 downto 0);

---- Memory unit outputs ----
signal InstrMemOut											: std_logic_vector(11 downto 0);
signal DataMemOut												: std_logic_vector(7 downto 0);

---- Register outputs ----
signal FRegOut													: std_logic_vector(3 downto 0);
signal PC, MemDataOutReged, OutFromAcc	: std_logic_vector(7 downto 0);
signal Instruction											: std_logic_vector(11 downto 0);

begin
-- Processor controller
	controller: procController
		port map ( 	master_load_enable,
				Instruction(11 downto 8),
				FlagInp(2),
				FlagInp(1),
				CLK,
				ARESETN,
				pcSel,
				pcLd,
				instrLd,
				addrMd,
				dmWr,
				dataLd,
				flagLd,
				accSel,
				accLd,
				im2bus,
				dmRd,
				acc2bus,
				ext2bus,
				dispLd,
				aluMd	);
-- Processor bus
	theBus: procBus
		port map (	INSTRUCTION => Instruction(7 downto 0),
								DATA => MemDataOutReged,
			  				ACC => OutFromAcc,
								EXTDATA => externalIn,
								OUTPUT => busOut,
			  				ERR => errSig2seg,
								instrSEL => im2bus,
								dataSEL => dmRd,
			  				accSEL => acc2bus,
								extdataSEL => ext2bus	);
	busOut2seg <= busOut;
-- ALU and PC-incrementor
	alu: alu_wRCA
		port map (	ALU_inA => OutFromAcc,
								ALU_inB => busOut,
								Operation => aluMd,
								ALU_out => aluOut,
			  				Carry => FlagInp(3),
								NotEq => FlagInp(2),
								Eq => FlagInp(1),
			  				isOutZero => FlagInp(0)	);
	pcInc: alu_wRCA
		port map (	ALU_inA => "00000001",
								ALU_inB => PC,
								Operation => "00",
			  				ALU_out => pcIncOut,
								Carry => open,
								NotEq => open,
								Eq => open,
			  				isOutZero => open	);
-- Memory units
	InstructionMemory: mem_array
		generic map (	DATA_WIDTH => 12,
									ADDR_WIDTH => 8,
									INIT_FILE => "inst_mem.mif")
		port map (	ADDR => pc,
								DATA_IN =>(OTHERS => '0'),
								CLK => CLK,
								WE => '0',
				  			OUTPUT => InstrMemOut	);
	DataMemory: mem_array
		generic map (	DATA_WIDTH => 8,
									ADDR_WIDTH => 8,
									INIT_FILE => "data_mem.mif")
		port map (	ADDR => Addr,
								DATA_IN => busOut,
								CLK => CLK,
								WE => dmWr,
				  			OUTPUT => DataMemOut	);
-- Muxes
	pcMux: mux2to1
		generic map (	width => 8)
		port map (	w1 => pcIncOut,
								w2 => busOut,
								f => nxtpc,
								sel => pcSel	);
	addrMux: mux2to1
		generic map (	width => 8)
		port map (	w1 => Instruction(7 downto 0),
								w2 => MemDataOutReged,
								f => Addr,
								sel => addrMd	);
	aluMux:	mux2to1
		generic map (	width => 8)
		port map (	w1 => aluOut,
								w2 => busOut,
								f => aluMuxOut,
								sel => accSel	);
-- Registers
	FE: reg
		generic map (	width => 8)
		port map (	CLK,
								ARESETN,
								loadEnable => pcLd,
				  			input => nxtpc,
								res => PC	);
	FE_DE: reg
		generic map (	width => 12)
		port map (	CLK,
								ARESETN,
								loadEnable => instrLd,
				  			input => InstrMemOut,
								res => Instruction	);
	DE_EX: reg
		generic map (	width => 8)
		port map (	CLK,
								ARESETN,
								loadEnable => dataLd,
				  			input => MemDataOutReged,
								res => MemDataOutReged	);
	ACC: reg
		generic map (	width => 8)
		port map (	CLK,
								ARESETN,
								loadEnable => accLd,
				  			input => aluMuxOut,
								res => OutFromAcc	);
	Display: reg
		generic map (	width => 8)
		port map (	CLK,
								ARESETN,
								loadEnable => dispLd,
				  			input => OutFromACC,
								res => disp2seg	);
	FReg: reg
		generic map (	width => 4)
		port map (	CLK,
								ARESETN,
								loadEnable => flagLd,
				  			input => FlagInp,
								res => FRegOut	);
-- Displays and flags
	pc2seg 				<= pc;
	instr2seg			<= Instruction;
	Addr2seg			<= Addr;
	dMemOut2seg 	<= MemDataOutReged;
	aluOut2seg		<= aluOut;
	acc2seg 			<= OutFromAcc;
	flag2seg			<= FRegOut;
	ovf						<= FlagInp(3);
	zero					<= FlagInp(0);
end structure;

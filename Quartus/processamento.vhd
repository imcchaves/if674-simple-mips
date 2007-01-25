library IEEE;
use IEEE.std_logic_1164.all;


entity processamento is
	PORT (
		load_trap			:	in	std_logic;
		equals				:	in	std_logic;
		IorD				:	in	std_logic;
		pc_write_cond		:	in	std_logic;
		pc_write			:	in	std_logic;
		beq					:	in	std_logic;
		ir_write			:	in	std_logic;
		reg_dest			:	in	std_logic_vector (1 downto 0);
		mem_write			:	in	std_logic;
		load_data_reg		:	in	std_logic;
		reset				:	in	std_logic;
		reset_pc			:	in	std_logic;
		shift_control		:	in	std_logic_vector(1 downto 0);
		alu_function		:	in	std_logic_vector(2 downto 0);
		unsigned_instruction: 	in	std_logic;
		compare_instruction	: 	in 	std_logic;
		alu_src_b			:	in	std_logic_vector(1 downto 0);
		alu_src_a			:	in	std_logic;
		mem_to_reg			:	in	std_logic_vector(2 downto 0);
		store_type			:	in	std_logic_vector(1 downto 0);
		reg_write			:	in	std_logic;
		invalid_opcode		:	in	std_logic;
		pc_source			:	in	std_logic_vector(1 downto 0);
		load_a				:	in	std_logic;
		load_b				:	in	std_logic;
		alu_or_trap			:	in	std_logic;
		load_alu_out		:	in	std_logic;
		alu_mux				: 	in 	std_logic_vector(1 downto 0);
		mult_control		:	in	std_logic_vector(1 downto 0);								
		clk					:	in	std_logic;
				
			
		funct				:	out	std_logic_vector(5 downto 0);
		nop_instruction		:	out	std_logic;		
		opcode				:	out	std_logic_vector(5 downto 0);
		zero				:	out	std_logic;		
		exception			:	out	std_logic;	
		end_multi			:	out	std_logic
	);
end processamento;

architecture ar of processamento is
	signal memory_to_IR								: std_logic_vector (31 downto 0);
	signal IR_to_shift_left2_01						: std_logic_vector (25 downto 0);
	signal IR_to_registers_bank_1					: std_logic_vector (4 downto 0); -- [25..21] para banco de registradores - read reg1
	signal IR_to_mux02_0							: std_logic_vector (4 downto 0); -- [20..16] 
	signal mux02_to_registers_bank					: std_logic_vector (4 downto 0); -- para banco de registradores -write reg
	signal lui_mask_to_mux03_4						: std_logic_vector (31 downto 0); -- entrada 4
	signal memory_data_register_to_mux03_3			: std_logic_vector (31 downto 0); -- entrada 3
	signal memory_data_register_to_sign_ext03		: std_logic_vector (7 downto 0); -- memory data register
	signal memory_data_register_to_sign_ext01		: std_logic_vector (15 downto 0); -- sign ext 01
	signal sign_ext01_to_mux03_2					: std_logic_vector (31 downto 0); -- entrada 2
	signal sign_ext03_to_mux03_1					: std_logic_vector (31 downto 0); -- sign ext 01
	signal sign_ext02_to_shift_left2_02				: std_logic_vector (31 downto 0);
	signal mux03_to_registers_bank					: std_logic_vector (31 downto 0); -- para banco de registrador - write data
	signal shift_left2_02_to_mux04_3				: std_logic_vector (31 downto 0); -- entrada 03
	signal registers_bank_to_reg_A					: std_logic_vector (31 downto 0); -- banco de registradores - read1
	signal registers_bank_to_reg_B					: std_logic_vector (31 downto 0); -- banco de registradores - read2
	signal mult_to_mux08_0							: std_logic_vector (31 downto 0); -- entrada 0
	signal registers_bank_to_shift					: std_logic_vector (31 downto 0); -- banco de registradores read2
	signal shift_to_mux08_1							: std_logic_vector (31 downto 0); -- entrada 1
	signal store_merge_to_memory					: std_logic_vector (31 downto 0); -- memory - write data
	signal mux01_to_memory							: std_logic_vector (31 downto 0); -- memory - adress
	signal reg_A_to_mux05_1							: std_logic_vector (31 downto 0); -- entrada 1
	signal reg_B_to_mux04_0							: std_logic_vector (31 downto 0); -- entrada 0
	signal mux05_to_aluA							: std_logic_vector (31 downto 0); -- entrada A
	signal mux04_to_aluB							: std_logic_vector (31 downto 0); -- entrada B
	signal alu_to_switch_0							: std_logic_vector (31 downto 0);
	signal temp_shift_left2_01_to_mux06_3			: std_logic_vector (27 downto 0);
	signal shift_left2_01_to_mux06_3				: std_logic_vector (31 downto 0);
	signal lt_to_switch_1							: std_logic;
	signal switch_to_alu_out						: std_logic_vector (31 downto 0);
	signal alu_out									: std_logic_vector (31 downto 0); -- entrada 1
	signal mux07_to_mux06_2							: std_logic_vector (31 downto 0); -- entrada 2
	signal mux_exc_to_mux07_0						: std_logic_vector (31 downto 0);
	signal epc_to_mux06_0							: std_logic_vector (31 downto 0); -- entrada 0
	signal pc_to_epc								: std_logic_vector (31 downto 0);
	signal pc_to_mux01_0							: std_logic_vector (31 downto 0); -- entrada 0
	signal mux00_to_pc								: std_logic_vector (31 downto 0);
	signal mux06_to_mux00_0							: std_logic_vector (31 downto 0); -- entrada 0
	signal entity_load_pc_to_load_pc				: std_logic;
	signal IR_to_signal_16_bits						: std_logic_vector(15 downto 0); -- apenas uma extençao de fio para os outros fios
	signal mux08_to_mux03_0							: std_logic_vector(31 downto 0);
	signal overflow_to_trap_epc						: std_logic;
	signal trap_epc_to_mux_exc						: std_logic;
	signal trap_epc_to_epc							: std_logic;
	signal invalid_opcode_to_trap_epc				: std_logic;
	signal mux07_to_mux06_3							: std_logic_vector(31 downto 0);
	signal alu_function_to_alu						: std_logic_vector(2 downto 0);
	signal alu_to_zero								: std_logic;
	signal nop										: std_logic;
	signal shift_control_to_shift					: std_logic_vector(1 downto 0);
	signal mult_control_to_mult						: std_logic_vector(1 downto 0);
	signal end_multiply								: std_logic;
	signal cu_to_pc_source                                         :  std_logic_vector(1 downto 0);
        signal cu_to_entity_load_pc_equals                             : std_logic;
        signal cu_to_entity_load_pc_pc_write                            : std_logic;
        signal cu_to_entity_load_pc_pc_write_cond                       : std_logic;
        signal cu_to_entity_load_pc_beq                                 : std_logic;

component store_merge
	PORT (
		storeType		:	in	std_logic_vector (1 downto 0);
		data, merge_in	:	in	std_logic_vector (31 downto 0);
		saida			:	out	std_logic_vector (31 downto 0)
	);
end component;


component ula32
	PORT (
		A 			:	in	std_logic_vector (31 downto 0);
		B 			:	in	std_logic_vector (31 downto 0);
		Seletor 	:	in	std_logic_vector (2 downto 0);
		s 			:	out	std_logic_vector (31 downto 0);
		Overflow 	:	out	bit;
		Negativo	:	out	bit;
		z 			:	out	bit;
		Igual		:	out	bit;
		Maior		:	out	bit;
		Menor		:	out	bit
	);
end component;


component registrador
	PORT (
		Clk		:	in	bit;
		Reset	:	in	bit;
		Load	:	in	bit;
		Entrada :	in	std_logic_vector (31 downto 0);
		Saida	:	out	std_logic_vector (31 downto 0)
	);
end component;


component regdesloc
	port (
		Clk		:	in	bit;
		Shift 	:	in	std_logic_vector (1 downto 0);
		N		:	in	std_logic_vector (4 downto 0);
		Entrada :	in	std_logic_vector (31 downto 0);
		Saida	:	out	std_logic_vector (31 downto 0)
	);
end component;


component memoria
	PORT (
		Address	:	in	std_logic_vector (31 downto 0);
		Clock	:	in	bit;
		Wr		:	in	bit;
		Dataout	:	out	std_logic_vector (31 downto 0);
		Datain	:	in	std_logic_vector (31 downto 0)
	);
end component;


component instr_reg
	PORT ( 
		Clk			:	in	bit;
		Reset		:	in	bit;
		Load_ir		:	in	bit;
		Entrada		:	in	std_logic_vector (31 downto 0);
		instr31_26	:	out	std_logic_vector (5 downto 0);
		instr25_21	:	out	std_logic_vector (4 downto 0);
		instr20_16	:	out	std_logic_vector (4 downto 0);
		instr15_0	:	out	std_logic_vector (15 downto 0)
	);
end component;


component banco_reg
	PORT (
		Clk			:	in	bit;
		Reset		:	in	bit;
		RegWrite	:	in	bit;
		ReadReg1	:	in	std_logic_vector (4 downto 0);
		ReadReg2	:	in	std_logic_vector (4 downto 0);
		WriteReg	:	in	std_logic_vector (4 downto 0);
		WriteData 	:	in	std_logic_vector (31 downto 0);
		ReadData1	:	out	std_logic_vector (31 downto 0);
		ReadData2	:	out	std_logic_vector (31 downto 0)
	);
end component;


component shift_left_2_26
	PORT (
		vector_26_input		: in	std_logic_vector (25 downto 0);
		vector_28_output	: out	std_logic_vector (27 downto 0)
	);
end component;


component shift_left_2_32
	PORT (
		vector_32_input		:	in	std_logic_vector (31 downto 0);
		vector_32_output	:	out	std_logic_vector (31 downto 0)
	);
end component;


component sign_ext_16
	PORT (
		vector_16	:	in	std_logic_vector (15 downto 0);
		vector_32	:	out	std_logic_vector (31 downto 0)
	);
end component;


component sign_ext_8
	PORT (
		vector_8	:	in	std_logic_vector (7 downto 0);
		vector_32	:	out	std_logic_vector (31 downto 0)
	);
end component;


component switch
	PORT (
		input0					:	in	std_logic_vector (31 downto 0);
		input1					:	in	std_logic;
		output					:	out	std_logic_vector (31 downto 0);
		unsigned_instruction	:	in	std_logic
	);
end component;


component lui_mask
	PORT (
		input	:	in	std_logic_vector (15 downto 0);
		output 	:	out	std_logic_vector (31 downto 0)
	);
end component;


component mux_2
	PORT (
		input0, input1 	:	in	std_logic_vector (31 downto 0);
		seletor			:	in	std_logic;
		output		 	:	out	std_logic_vector (31 downto 0)
	);
end component;


component mux_3
	PORT (
		input0, input1, input2	:	in	std_logic_vector (31 downto 0);
		seletor					:	in	std_logic_vector (1 downto 0);
		output				 	:	out	std_logic_vector (31 downto 0)
	);
end component;


component mux_4
	PORT (
		input0, input1, input2, input3	:	in	std_logic_vector (31 downto 0);
		seletor							:	in	std_logic_vector (1 downto 0);
		output						 	:	out	std_logic_vector (31 downto 0)
	);
end component;


component mux_5
	PORT (
		input0, input1, input2, input3, input4	:	in	std_logic_vector (31 downto 0);
		seletor									:	in	std_logic_vector (2 downto 0);
		output						 			:	out	std_logic_vector (31 downto 0)
	);
end component;


component mux_6
	PORT (
		input0, input1, input2, input3, input4, input5	:	in	std_logic_vector (31 downto 0);
		seletor											:	in	std_logic_vector (2 downto 0);
		output						 					:	out	std_logic_vector (31 downto 0)
	);
end component;


component nop_detector
	PORT (
		input	:	in	std_logic_vector (31 downto 0);
		output	:	out	std_logic
	);
end component;


component load_pc
	PORT (
		equals			:	in	std_logic;
		pc_write_cond	:	in	std_logic;
		pc_write		:	in	std_logic;
		beq				:	in	std_logic;
		load_pc			: 	out std_logic
	);
end component;	


component trap_epc
	PORT (
		unsigned_instruction	:	in	std_logic;
		invalid_opcode			:	in	std_logic;
		overflow				:	in	std_logic;
		trap_type				:	out	std_logic;
		load_epc				:	out	std_logic;
		exception				:	out	std_logic
	);
end component;


component MUX_4_5bits
	PORT (
		input0, input1, input2, input3	: IN   STD_LOGIC_VECTOR	(4 DOWNTO 0);
		seletor							: IN   STD_LOGIC_VECTOR	(1 DOWNTO 0);
		output						 	: OUT  STD_LOGIC_VECTOR	(4 DOWNTO 0)
	);
end component;


component multiplicador
	PORT (
		A, B	:	IN	STD_LOGIC_VECTOR (31 DOWNTO 0);
		control	:	IN	STD_LOGIC_VECTOR (1 DOWNTO 0);
		reset	:	IN	STD_LOGIC;
		clk		:	IN	STD_LOGIC;
		fim		:	OUT STD_LOGIC;
		saida	:	OUT	STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
end component;

begin

memory	:	memoria
	port map (
		mux01_to_memory,
		to_bit (clk),
		to_bit (mem_write),
		memory_to_IR,
		store_merge_to_memory
	);

banco_regs	:   banco_reg
	port map (
		to_bit (clk),
		to_bit (reset),
		to_bit (reg_write),
		ir_to_registers_bank_1,
		IR_to_mux02_0,
		mux02_to_registers_bank,
		mux03_to_registers_bank,
		registers_bank_to_reg_A,
		registers_bank_to_reg_B
	);

ula	:	ula32
	port map (
		mux05_to_aluA,
		mux04_to_aluB,
		alu_function_to_alu,
		alu_to_switch_0,
		to_stdulogic (Overflow)		=>	overflow_to_trap_epc,
		to_stdulogic (Z)			=>	alu_to_zero,
		to_stdulogic (Menor)		=>	lt_to_switch_1
	);

IR	:	instr_reg	
	port map (
		to_bit (clk),
		to_bit (reset),
		to_bit (ir_write),
		memory_to_IR,
		opcode,
		IR_to_registers_bank_1,
		IR_to_mux02_0,
		IR_to_signal_16_bits
	);

regA	:	registrador
	port map (
		to_bit (clk),
		to_bit (reset),
		to_bit (load_a),
		registers_bank_to_reg_A,
		reg_A_to_mux05_1
	);

regB	:	registrador
	port map (
		to_bit (clk),
		to_bit (reset),
		to_bit (load_b),
		registers_bank_to_reg_B,
		reg_B_to_mux04_0
	);

aluOut	:	registrador
	port map (
		to_bit (clk),
		to_bit (reset),
		to_bit (load_alu_out),
		switch_to_alu_out,
		alu_out
	);

epc	:	registrador
	port map (
		to_bit (clk),
		to_bit (reset),
		to_bit (trap_epc_to_epc),
		pc_to_mux01_0,
		epc_to_mux06_0
	);
	
pc	:	registrador
	port map (
		to_bit (clk),
		to_bit (reset_pc),
		to_bit (entity_load_pc_to_load_pc),
		mux00_to_pc,
		pc_to_mux01_0
	);

memoryDataRegister	:	registrador
	port map (
		to_bit (clk),
		to_bit (reset),
		to_bit (load_data_reg),
		memory_to_IR,
		memory_data_register_to_mux03_3
	);

shift	:	regdesloc
	port map (
		to_bit (clk),
		shift_control_to_shift,
		IR_to_signal_16_bits (10 downto 6),
		registers_bank_to_reg_A,
		shift_to_mux08_1
	);

mult	:	multiplicador
	port map (
		registers_bank_to_reg_A,
		registers_bank_to_reg_B,
		mult_control_to_mult,
		reset,
		clk,
		end_multiply,
		mult_to_mux08_0
	);

mux00	:	MUX_2
	port map (
		mux06_to_mux00_0,
		memory_to_IR,
		load_trap,
		mux00_to_pc
	);

mux01	:	MUX_2
	port map (
		pc_to_mux01_0,
		alu_out,
		IorD,
		mux01_to_memory
	);

mux02	:	MUX_4_5bits
	port map (
		IR_to_mux02_0,
		"11111",
		IR_to_signal_16_bits (15 downto 11),
		"11101",
		reg_dest,
		mux02_to_registers_bank
	);

mux03	:	MUX_6
	port map (
		mux08_to_mux03_0,
		sign_ext03_to_mux03_1,
		sign_ext01_to_mux03_2,
		memory_data_register_to_mux03_3,
		lui_mask_to_mux03_4,
		"00000000000000000000000011100011",
		mem_to_reg,
		mux03_to_registers_bank
	);

mux04	: 	MUX_4
	port map (
		reg_B_to_mux04_0,
		"00000000000000000000000000000100",
		sign_ext02_to_shift_left2_02,
		shift_left2_02_to_mux04_3,
		alu_src_b,
		mux04_to_alub
	);

mux05	:   MUX_2
	port map (
		pc_to_mux01_0,
		reg_A_to_mux05_1,
		alu_src_a,
		mux05_to_alua
	);

mux06	:   MUX_4
	port map (
		epc_to_mux06_0,
		alu_to_switch_0,
		mux07_to_mux06_2,
		shift_left2_01_to_mux06_3,
		cu_to_pc_source,
		mux06_to_mux00_0
	);

mux07	:	MUX_2
	port map (
		mux_exc_to_mux07_0,
		alu_out,
		alu_or_trap,
		mux07_to_mux06_2
	);

mux08	:   MUX_3
	port map (
		mult_to_mux08_0,
		shift_to_mux08_1,
		alu_out,
		alu_mux,
		mux08_to_mux03_0
	);

mux_exc	:	MUX_2
	port map (
		"00000000000000000000000011111101",
		"00000000000000000000000011111110",
		trap_epc_to_mux_exc,
		mux_exc_to_mux07_0
	);

storeMerge	:	store_merge
	port map (
		store_type,
		reg_B_to_mux04_0,
		memory_to_IR,
		store_merge_to_memory
	);

switch_alu	:	switch
	port map (
		alu_to_switch_0,
		lt_to_switch_1,
		switch_to_alu_out,
		compare_instruction
	);

epc_trap	:	trap_epc
	port map (
		unsigned_instruction,
		invalid_opcode_to_trap_epc,
		overflow_to_trap_epc,
		trap_epc_to_mux_exc,
		trap_epc_to_epc
	);

nopDetector	:	nop_detector
	port map (
		memory_to_IR,
		nop
	);

loadPc	: 	load_pc
	port map (
		cu_to_entity_load_pc_equals,
		cu_to_entity_load_pc_pc_write_cond,
		cu_to_entity_load_pc_pc_write,
		cu_to_entity_load_pc_beq,
		entity_load_pc_to_load_pc
	);

luiMask	: 	lui_mask
	port map (
		IR_to_signal_16_bits,
		lui_mask_to_mux03_4
	);

signExt01	:	sign_ext_16
	port map (
		memory_data_register_to_mux03_3 (15 downto 0),
		sign_ext01_to_mux03_2
	);

signExt02	: 	sign_ext_16
	port map (
		IR_to_signal_16_bits,
		sign_ext02_to_shift_left2_02
	);

signExt03	:	sign_ext_8
	port map (
		memory_data_register_to_mux03_3 (7 downto 0),
		sign_ext03_to_mux03_1
	);

shiftLeft_2_32	:	shift_left_2_32
	port map (
		sign_ext02_to_shift_left2_02,
		shift_left2_02_to_mux04_3
	);

shiftLeft_2_26	:  	shift_left_2_26
	port map (
		IR_to_shift_left2_01,
		temp_shift_left2_01_to_mux06_3
	);

-- seta 'exception' com o valor obtido pela porta 'load_epc' da entidade 'trap_epc'
exception <= trap_epc_to_epc;

-- junta 4 bits mais significativos de PC com 28 bits menos significativos da instrucao
shift_left2_01_to_mux06_3 (31 downto 28) <= alu_to_switch_0 (31 downto 28);
shift_left2_01_to_mux06_3 (27 downto 0) <= temp_shift_left2_01_to_mux06_3 (27 downto 0);

-- junta os primeiros 26 bits da instrucao para enviar ao 'shift_left2_01'
IR_to_shift_left2_01(15 downto 0)  <= IR_to_signal_16_bits;
IR_to_shift_left2_01(20 downto 16) <= IR_to_mux02_0;
IR_to_shift_left2_01(25 downto 21) <= IR_to_registers_bank_1;

--
funct <= IR_to_signal_16_bits(5 downto 0);

--
alu_function_to_alu <= alu_function;

--
zero <= alu_to_zero;

--
--aluMux <= alu_mux;

--
invalid_opcode_to_trap_epc <= invalid_opcode;

--
nop_instruction <= nop;

--
shift_control_to_shift <= shift_control;

--
mult_control_to_mult <= mult_control;
end_multi <= end_multiply;

cu_to_pc_source <= pc_source;

cu_to_entity_load_pc_equals <= equals;

cu_to_entity_load_pc_pc_write_cond <= pc_write_cond;
cu_to_entity_load_pc_pc_write <= pc_write;
cu_to_entity_load_pc_beq <= beq;

end ar;

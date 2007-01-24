library IEEE;
use IEEE.std_logic_1164.all;


entity processamento is
	port(
		load_trap			:	in	bit;
		equals				:	in	bit;
		IorD				:	in	bit;
		pc_write_cond		:	in	bit;
		pc_write			:	in	bit;
		beq					:	in	bit;
		ir_write			:	in	bit;
		reg_dest			:	in	std_logic_vector (1 downto 0);
		mem_write			:	in	bit;
		load_data_reg		:	in	bit;
		reset				:	in	bit;
		reset_pc			:	in	bit;
		shift_control		:	in	std_logic_vector(1 downto 0);
		alu_function		:	in	std_logic_vector(2 downto 0);
		unsigned_instruction: 	in	bit;
		compare_instruction	: 	in 	bit;
		alu_src_b			:	in	std_logic_vector(1 downto 0);
		alu_src_a			:	in	bit;
		mem_to_reg			:	in	std_logic_vector(2 downto 0);
		store_type			:	in	std_logic_vector(1 downto 0);
		reg_write			:	in	bit;
		invalid_opcode		:	in	bit;
		pc_source			:	in	std_logic_vector(1 downto 0);
		load_a				:	in	bit;
		load_b				:	in	bit;
		alu_or_trap			:	in	bit;
		load_alu_out		:	in	bit;
		alu_mux				: 	in 	std_logic_vector(1 downto 0);
		mult_control		:	in	std_logic_vector(1 downto 0);								
		clk					:	in	bit;
				
			
		funct				:	out	std_logic_vector(5 downto 0);
		nop_instruction		:	out	bit;		
		opcode				:	out	std_logic_vector(5 downto 0);
		zero				:	out	bit;		
		exception			:	out	bit;	
		end_multi			:	out	bit
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
	signal lt_to_switch_1							: bit;
	signal switch_to_alu_out						: std_logic_vector (31 downto 0);
	signal alu_out									: std_logic_vector (31 downto 0); -- entrada 1
	signal mux07_to_mux06_2							: std_logic_vector (31 downto 0); -- entrada 2
	signal mux_exc_to_mux07_0						: std_logic_vector (31 downto 0);
	signal epc_to_mux06_0							: std_logic_vector (31 downto 0); -- entrada 0
	signal pc_to_epc								: std_logic_vector (31 downto 0);
	signal pc_to_mux01_0							: std_logic_vector (31 downto 0); -- entrada 0
	signal mux00_to_pc								: std_logic_vector (31 downto 0);
	signal mux06_to_mux00_0							: std_logic_vector (31 downto 0); -- entrada 0
	signal entity_load_pc_to_load_pc				: bit;
	signal IR_to_signal_16_bits						: std_logic_vector(15 downto 0); -- apenas uma extençao de fio para os outros fios
	signal mux08_to_mux03_0							: std_logic_vector(31 downto 0);
	signal overflow_to_trap_epc						: bit;
	signal trap_epc_to_mux_exc						: bit;
	signal trap_epc_to_epc							: bit;
	signal invalid_opcode_to_trap_epc				: bit;
	signal mux07_to_mux06_3							: std_logic_vector(31 downto 0);
	signal alu_function_to_alu						: std_logic_vector(2 downto 0);
	signal alu_to_zero								: bit;
	signal nop										: bit;
	signal shift_control_to_shift					: std_logic_vector(1 downto 0);
	signal mult_control_to_mult						: std_logic_vector(1 downto 0);
	signal end_multiply								: bit;
	signal cu_to_pc_source                                         :  std_logic_vector(1 downto 0);
        signal cu_to_entity_load_pc_equals                             : bit;
        signal cu_to_entity_load_pc_pc_write                            : bit;
        signal cu_to_entity_load_pc_pc_write_cond                       : bit;
        signal cu_to_entity_load_pc_beq                                 : bit;

component store_merge
port(
	storeType	:	in	std_logic_vector(1 downto 0);
	data		:	in	std_logic_vector(31 downto 0);
	merge_in	:	in	std_logic_vector(31 downto 0);
	saida		:	out	std_logic_vector(31 downto 0)
	);
end component;
--
component ula32
	port ( 
		A 			: in bit_vector (31 downto 0);	-- Operando A da ULA
		B 			: in bit_vector (31 downto 0);	-- Operando B da ULA
		Seletor 	: in bit_vector(2 downto 0);	-- Seletor da operação da ULA
		S 			: out bit_vector (31 downto 0);	-- Resultado da operação (SOMA, SUB, AND, NOT, INCREMENTO, XOR)  
		Overflow 	: out bit;						-- Sinaliza overflow aritmético
		Negativo	: out bit;						-- Sinaliza valor negativo
		z 			: out bit;						-- Sinaliza quando S for zero
		Igual		: out bit;						-- Sinaliza se A=B
		Maior		: out bit;						-- Sinaliza se A>B
		Menor		: out bit 						-- Sinaliza se A<B
	);
end component;
--
component registrador
port (
		Clk		: IN	bit;						-- Clock do registrador
		Reset	: IN	bit;						-- Reinicializa o conteudo do registrador
		Load	: IN	bit;						-- Carrega o registrador com o vetor Entrada
		Entrada : IN	bit_vector (31 downto 0); 	-- Vetor de bits que possui a informação a ser carregada no registrador
		Saida	: OUT	bit_vector (31 downto 0)	-- Vetor de bits que possui a informação já carregada no registrador
	);
end component;
--
component regdesloc
port (
		Clk		: IN	bit;	-- Clock do sistema
		Shift 	: IN	bit_vector (1 downto 0);	-- Função a ser realizada pelo registrador 
		N		: IN	bit_vector (4 downto 0);	-- Quantidade de deslocamentos
		Entrada : IN	bit_vector (31 downto 0);	-- Vetor a ser deslocado
		Saida	: OUT	bit_vector (31 downto 0)	-- Vetor deslocado
	);
end component;
--
component memoria
port(
	   Address	: IN BIT_VECTOR(31 DOWNTO 0);	-- Endereço de memória a ser lido
       Clock	: IN BIT;						-- Clock do sistema
	   Wr		: IN BIT;						-- Indica se a memória será lida (0) ou escrita (1)
       Dataout	: OUT BIT_VECTOR (31 DOWNTO 0);	-- Valor a ser escrito quando Wr = 1
       Datain	: IN BIT_VECTOR(31 DOWNTO 0)	-- Valor lido da memória quando Wr = 0
   );
end component;
--
component instr_reg
port( 
	Clk			: in bit;	-- Clock do sistema
	Reset		: in bit;	-- Reset
	Load_ir		: in bit;	-- Bit para ativar carga do registrador de intruções
	Entrada		: in bit_vector (31 downto 0);	-- Intrução a ser carregada
	Instr31_26	: out bit_vector (5 downto 0);	-- Bits 31 a 26 da instrução
	Instr25_21	: out bit_vector (4 downto 0);	-- Bits 25 a 21 da instrução
	Instr20_16	: out bit_vector (4 downto 0);	-- Bits 20 a 16 da instrução
	Instr15_0	: out bit_vector (15 downto 0)	-- Bits 15 a 0 da instrução
);
end component;
--
component banco_reg
PORT(
		Clk			: IN	bit;						-- Clock do banco de registradores
		Reset		: IN	bit;						-- Reinicializa o conteudo dos registradores
		RegWrite	: IN	bit;						-- Indica se a operação é de escrita ou leitura
		ReadReg1	: IN	bit_vector (4 downto 0);	-- Indica o registrador #1 a ser lido
		ReadReg2	: IN	bit_vector (4 downto 0);	-- Indica o registrador #2 a ser lido
		WriteReg	: IN	bit_vector (4 downto 0);	-- Indica o registrador a ser escrito
		WriteData 	: IN	bit_vector (31 downto 0);	-- Indica o dado a ser escrito
		ReadData1	: OUT	bit_vector (31 downto 0);	-- Mostra a informaçao presente no registrador #1
		ReadData2	: OUT	bit_vector (31 downto 0)	-- Mostra a informação presente no registrador #2
);
end component;
--
component shift_left_2_26
PORT (
	vector_26_input		: IN	STD_LOGIC_VECTOR (25 DOWNTO 0);
	vector_28_output	: OUT	STD_LOGIC_VECTOR (27 DOWNTO 0)
);
end component;
--
component shift_left_2_32
PORT (
	vector_32_input		: IN	STD_LOGIC_VECTOR (31 DOWNTO 0);
	vector_32_output	: OUT	STD_LOGIC_VECTOR (31 DOWNTO 0)
);
end component;
--
component sign_ext_16
PORT (
		vector_16		: IN	STD_LOGIC_VECTOR (15 DOWNTO 0);
		vector_32		: OUT	STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
end component;
--
component sign_ext_8
PORT (
	vector_8		: IN	STD_LOGIC_VECTOR (7 DOWNTO 0);
	vector_32		: OUT	STD_LOGIC_VECTOR (31 DOWNTO 0)
);
end component;
--
component switch
Port (
         input0: in std_logic_vector (31 downto 0);
         input1: in bit;
         output: out std_logic_vector (31 downto 0);
         unsigned_instruction: in bit
      );
end component;
--
component lui_mask
PORT(
	input 							: IN	STD_LOGIC_VECTOR(15 DOWNTO 0);
	output						 	: OUT	STD_LOGIC_VECTOR(31 DOWNTO 0)
);
end component;
--
component mux_2
PORT(
	input0, input1 					: IN	STD_LOGIC_VECTOR(31 DOWNTO 0);
	seletor							: IN    BIT;
	output						 	: OUT	STD_LOGIC_VECTOR(31 DOWNTO 0)
);
end component;
--
component mux_3
PORT(
	input0, input1, input2			: IN	STD_LOGIC_VECTOR(31 DOWNTO 0);
	seletor							: IN   STD_LOGIC_VECTOR(1 DOWNTO 0);
	output						 	: OUT	STD_LOGIC_VECTOR(31 DOWNTO 0)
);
end component;
--
component mux_4
PORT(
	input0, input1, input2, input3	: IN	STD_LOGIC_VECTOR(31 DOWNTO 0);
	seletor							: IN   STD_LOGIC_VECTOR(1 DOWNTO 0);
	output						 	: OUT	STD_LOGIC_VECTOR(31 DOWNTO 0)
);
end component;
--
component mux_5
PORT(
		input0, input1, input2, input3, input4	: IN	STD_LOGIC_VECTOR(31 DOWNTO 0);
		seletor									: IN   STD_LOGIC_VECTOR(2 DOWNTO 0);
		output						 			: OUT	STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
end component;
--
component mux_6
PORT(
		input0, input1, input2, input3, input4, input5	: IN	STD_LOGIC_VECTOR(31 DOWNTO 0);
		seletor											: IN   STD_LOGIC_VECTOR(2 DOWNTO 0);
		output						 					: OUT	STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
end component;
--
component nop_detector
PORT(
		input							: IN	STD_LOGIC_VECTOR(31 DOWNTO 0);
		output							: OUT 	BIT 
);
end component;

component load_pc
port(
	equals			:	in	bit;
	pc_write_cond	:	in	bit;
	pc_write		:	in	bit;
	beq				:	in	bit;	
	load_pc			: 	out bit	
	);
end component;	

component trap_epc
	PORT
	(
		unsigned_instruction			: in	bit;
		invalid_opcode					: in    bit;
		overflow						: in 	bit;
		trap_type					 	: out	bit;
		load_epc						: out   bit;
		exception						: out	bit
	);
end component;

component MUX_4_5bits
PORT
	(
		input0, input1, input2, input3	: IN   STD_LOGIC_VECTOR(4 DOWNTO 0);
		seletor							: IN   STD_LOGIC_VECTOR(1 DOWNTO 0);
		output						 	: OUT  STD_LOGIC_VECTOR(4 DOWNTO 0)
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

mux00					:	MUX_2				port map(mux06_to_mux00_0, memory_to_IR, load_trap, mux00_to_pc);
mux01					:	MUX_2				port map(pc_to_mux01_0, alu_out, IorD, mux01_to_memory);
mux02					:	MUX_4_5bits			port map(IR_to_mux02_0, "11111", IR_to_signal_16_bits(15 downto 11), "11101", reg_dest, mux02_to_registers_bank);
mux03					:	MUX_6				port map(mux08_to_mux03_0, sign_ext03_to_mux03_1, sign_ext01_to_mux03_2, memory_data_register_to_mux03_3, lui_mask_to_mux03_4, "00000000000000000000000011100011", mem_to_reg, mux03_to_registers_bank);
mux04					: 	MUX_4				port map(reg_B_to_mux04_0, "00000000000000000000000000000100", sign_ext02_to_shift_left2_02, shift_left2_02_to_mux04_3, alu_src_b, mux04_to_alub);
mux05					:   MUX_2				port map(pc_to_mux01_0, reg_A_to_mux05_1,alu_src_a, mux05_to_alua);
mux06					:   MUX_4				port map(epc_to_mux06_0, alu_to_switch_0, mux07_to_mux06_2, shift_left2_01_to_mux06_3, cu_to_pc_source, mux06_to_mux00_0);
mux07					:	MUX_2				port map(mux_exc_to_mux07_0, alu_out, alu_or_trap, mux07_to_mux06_2);
mux08					:   MUX_3				port map(mult_to_mux08_0, shift_to_mux08_1, alu_out, alu_mux, mux08_to_mux03_0);
mux_exc					:	MUX_2				port map("00000000000000000000000011111101", "00000000000000000000000011111110", trap_epc_to_mux_exc, mux_exc_to_mux07_0);

regA					:	registrador			port map(clk, reset, load_a, registers_bank_to_reg_A, reg_A_to_mux05_1);
regB					:	registrador			port map(clk, reset, load_b, registers_bank_to_reg_B, reg_B_to_mux04_0);
aluOut					:	registrador			port map(clk, reset, load_alu_out, switch_to_alu_out, alu_out);
epc						:	registrador			port map(clk, reset, trap_epc_to_epc, pc_to_mux01_0, epc_to_mux06_0);
pc						:	registrador 		port map(clk, reset_pc, entity_load_pc_to_load_pc, mux00_to_pc, pc_to_mux01_0);
memoryDataRegister		:	registrador			port map(clk, reset, load_data_reg, memory_to_IR, memory_data_register_to_mux03_3);

memory					:	memoria				port map(mux01_to_memory, clk, mem_write, memory_to_IR, store_merge_to_memory);
storeMerge				:	store_merge			port map(store_type, reg_B_to_mux04_0, memory_to_IR, store_merge_to_memory);
IR						:	instr_reg			port map(clk, reset, ir_write, memory_to_IR, opcode, IR_to_registers_bank_1, IR_to_mux02_0,IR_to_signal_16_bits);
switch_alu				: 	switch				port map(alu_to_switch_0, lt_to_switch_1, switch_to_alu_out, compare_instruction);
banco_regs  			:   banco_reg			port map(clk, reset, reg_write, ir_to_registers_bank_1, IR_to_mux02_0, mux02_to_registers_bank, mux03_to_registers_bank, registers_bank_to_reg_A, registers_bank_to_reg_B);
epc_trap				:	trap_epc			port map(unsigned_instruction, invalid_opcode_to_trap_epc, overflow_to_trap_epc, trap_epc_to_mux_exc, trap_epc_to_epc);
nopDetector 			:	nop_detector 		port map(memory_to_IR,nop);
loadPc					: 	load_pc 			port map(cu_to_entity_load_pc_equals, cu_to_entity_load_pc_pc_write_cond, cu_to_entity_load_pc_pc_write,cu_to_entity_load_pc_beq, entity_load_pc_to_load_pc);
luiMask					: 	lui_mask 			port map(IR_to_signal_16_bits,lui_mask_to_mux03_4);
ula						:	ula32				port map(mux05_to_aluA, mux04_to_aluB, alu_function_to_alu, alu_to_switch_0, overflow_to_trap_epc, z => alu_to_zero, Menor => lt_to_switch_1);
shift					:	regdesloc			port map(clk, shift_control_to_shift, IR_to_signal_16_bits(10 downto 6), registers_bank_to_reg_B, shift_to_mux08_1);
--FALTA MULTIPLICACAO
mult					:	multiplicador		port map(registers_bank_to_reg_A, registers_bank_to_reg_B, mult_control_to_mult, reset, clk, end_multiply, mult_to_mux08_0);


signExt01				:	sign_ext_16			port map(memory_data_register_to_mux03_3(15 downto 0), sign_ext01_to_mux03_2);
signExt02				: 	sign_ext_16 		port map(IR_to_signal_16_bits, sign_ext02_to_shift_left2_02);
signExt03				:	sign_ext_8			port map(memory_data_register_to_mux03_3(7 downto 0), sign_ext03_to_mux03_1);

shiftLeft_2_32			: 	shift_left_2_32 	port map(sign_ext02_to_shift_left2_02,shift_left2_02_to_mux04_3);
shiftLeft_2_26			:  	shift_left_2_26 	port map(IR_to_shift_left2_01, temp_shift_left2_01_to_mux06_3);



-- seta 'exception' com o valor obtido pela porta 'load_epc' da entidade 'trap_epc'
exception <= trap_epc_to_epc;

-- junta 4 bits mais significativos de PC com 28 bits menos significativos da instrucao
shift_left2_01_to_mux06_3(31 downto 28) <= alu_to_switch_0(31 downto 28);
shift_left2_01_to_mux06_3(27 downto 0) <= temp_shift_left2_01_to_mux06_3(27 downto 0);


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

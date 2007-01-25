library IEEE;
use IEEE.std_logic_1164.all;
USE ieee.std_logic_arith.all;

entity cpu is
	PORT (
		reset_in			:	in	std_logic;
		clk_in				:	in	std_logic;

		ir_write_t			:   out std_logic;
		debug_32_a			:	out std_logic_vector (31 DOWNTO 0)
	);
end cpu;


architecture cpu_arch of cpu is
		signal load_trap			:	std_logic;
		signal equals				:	std_logic;
		signal IorD					:	std_logic;
		signal pc_write_cond		:	std_logic;
		signal pc_write				:	std_logic;
		signal beq					:	std_logic;
		signal ir_write				:	std_logic;
		signal reg_dest				:	std_logic_vector (1 downto 0);
		signal mem_write			:	std_logic;
		signal load_data_reg		:	std_logic;
		signal reset				:	std_logic;
		signal reset_pc				:	std_logic;
		signal shift_control		:	std_logic_vector(1 downto 0);
		signal alu_function			:	std_logic_vector(2 downto 0);
		signal unsigned_instruction	: 	std_logic;
		signal compare_instruction	: 	std_logic;
		signal alu_src_b			:	std_logic_vector(1 downto 0);
		signal alu_src_a			:	std_logic;
		signal mem_to_reg			:	std_logic_vector(2 downto 0);
		signal store_type			:	std_logic_vector(1 downto 0);
		signal reg_write			:	std_logic;
		signal invalid_opcode		:	std_logic;
		signal pc_source			:	std_logic_vector(1 downto 0);
		signal load_a				:	std_logic;
		signal load_b				:	std_logic;
		signal alu_or_trap			:	std_logic;
		signal load_alu_out			:	std_logic;
		signal alu_mux				: 	std_logic_vector(1 downto 0);
		signal mult_control			:	std_logic_vector(1 downto 0);								
		signal clk					:	std_logic;		
			
		signal funct				:	std_logic_vector(5 downto 0);
		signal nop_instruction		:	std_logic;		
		signal opcode				:	std_logic_vector(5 downto 0);
		signal zero					:	std_logic;		
		signal exception			:	std_logic;	
		signal end_multi			:	std_logic;


component processamento
	port(
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
end component;
--
		
component Control_Unit
PORT
(
		load_trap			:	out	std_logic;
		equals				:	out	std_logic;
		IorD				:	out	std_logic;
		pc_write_cond		:	out	std_logic;
		pc_write			:	out	std_logic;
		beq					:	out	std_logic;
		ir_write			:	out	std_logic;
		reg_dest			:	out	std_logic_vector(1 downto 0);
		mem_read_write		:	out	std_logic;
		reset_pc			:	out	std_logic;
		load_data_reg		: 	out std_logic;
		load_alu_out		:	out	std_logic;
		load_a				:	out	std_logic;
		load_b				:	out	std_logic;
		pc_source			:	out	std_logic_vector(1 downto 0);		
		reg_write			:	out	std_logic;
		store_type			:	out	std_logic_vector(1 downto 0);
		mem_to_reg			:	out	std_logic_vector(2 downto 0);
		alu_src_a			:	out	std_logic;
		alu_src_b			:	out	std_logic_vector(1 downto 0);
		unsigned_instruction : 	out	std_logic;
		compare_instruction	: 	out	std_logic;
		alu_func			:	out std_logic_vector(2 downto 0);
		alu_mux				: 	out	std_logic_vector(1 downto 0);
		shift_control		:   out std_logic_vector(1 downto 0);
		mult_control		: 	out std_logic_vector(1 downto 0);
		alu_or_trap			: 	out std_logic;
		invalid_opcode		:	out	std_logic;

		reset				:	in	std_logic;
		clk					:	in	std_logic;
		exception			:	in	std_logic;
		zero				:	in	std_logic;
		nop_instruction		:	in	std_logic;
		end_mult			:   in  std_logic;
		opcode				: 	in 	std_logic_vector (5 downto 0);
		funct				:   in  std_logic_vector (5 downto 0)
);
end component;


begin	
reset <= reset_in;
clk <= clk_in;

processing	:	processamento
	port map (
		load_trap,
		equals,
		IorD,
		pc_write_cond,
		pc_write,
		beq,
		ir_write,
		reg_dest,
		mem_write,
		load_data_reg,
		reset,
		reset_pc,
		shift_control,
		alu_function,
		unsigned_instruction,
		compare_instruction,
		alu_src_b,
		alu_src_a,
		mem_to_reg,
		store_type,
		reg_write,
		invalid_opcode,
		pc_source,
		load_a,
		load_b,
		alu_or_trap,
		load_alu_out,
		alu_mux,
		mult_control,
		clk,
		funct,
		nop_instruction,
		opcode,
		zero,
		exception,
		end_multi
	);

control	:	Control_Unit
	port map (
		load_trap,
		equals,
		IorD,
		pc_write_cond,
		pc_write,
		beq,
		ir_write,
		reg_dest,
		mem_write,
		reset_pc,
		load_data_reg,
		load_alu_out,
		load_a,
		load_b,
		pc_source,
		reg_write,
		store_type,
		mem_to_reg,
		alu_src_a,
		alu_src_b,
		unsigned_instruction,
		compare_instruction,
		alu_function,
		alu_mux,
		shift_control,
		mult_control,
		alu_or_trap,
		invalid_opcode,
		reset,
		clk,
		exception,
		zero,
		nop_instruction,
		end_multi,
		opcode,
		funct
	);														

debug_32_a (31 DOWNTO 26) <= opcode;
debug_32_a (25 DOWNTO 6) <= "00000000000000000000";
debug_32_a (5 DOWNTO 0) <= funct;
ir_write_t <= ir_write;

end cpu_arch;
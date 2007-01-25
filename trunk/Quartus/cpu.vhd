library IEEE;
use IEEE.std_logic_1164.all;
USE ieee.std_logic_arith.all;

entity cpu is
	port(
		reset_in			:	in	bit;
		clk_in				:	in	bit;

		ir_write_t			:   out bit;
		debug_32_a			:	out std_logic_vector (31 DOWNTO 0)
		);
end cpu;


architecture cpu_arch of cpu is
		signal load_trap			:	bit;
		signal equals				:	bit;
		signal IorD					:	bit;
		signal pc_write_cond		:	bit;
		signal pc_write				:	bit;
		signal beq					:	bit;
		signal ir_write				:	bit;
		signal reg_dest				:	std_logic_vector (1 downto 0);
		signal mem_write			:	bit;
		signal load_data_reg		:	bit;
		signal reset				:	bit;
		signal reset_pc				:	bit;
		signal shift_control		:	std_logic_vector(1 downto 0);
		signal alu_function			:	std_logic_vector(2 downto 0);
		signal unsigned_instruction	: 	bit;
		signal compare_instruction	: 	bit;
		signal alu_src_b			:	std_logic_vector(1 downto 0);
		signal alu_src_a			:	bit;
		signal mem_to_reg			:	std_logic_vector(2 downto 0);
		signal store_type			:	std_logic_vector(1 downto 0);
		signal reg_write			:	bit;
		signal invalid_opcode		:	bit;
		signal pc_source			:	std_logic_vector(1 downto 0);
		signal load_a				:	bit;
		signal load_b				:	bit;
		signal alu_or_trap			:	bit;
		signal load_alu_out			:	bit;
		signal alu_mux				: 	std_logic_vector(1 downto 0);
		signal mult_control			:	std_logic_vector(1 downto 0);								
		signal clk					:	bit;		
			
		signal funct				:	std_logic_vector(5 downto 0);
		signal nop_instruction		:	bit;		
		signal opcode				:	std_logic_vector(5 downto 0);
		signal zero					:	bit;		
		signal exception			:	bit;	
		signal end_multi			:	bit;


component processamento
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
end component;
--
		
component Control_Unit
PORT
(
		load_trap			:	out	bit;
		equals				:	out	bit;
		IorD				:	out	bit;
		pc_write_cond		:	out	bit;
		pc_write			:	out	bit;
		beq					:	out	bit;
		ir_write			:	out	bit;
		reg_dest			:	out	std_logic_vector(1 downto 0);
		mem_read_write		:	out	bit;
		reset_pc			:	out	bit;
		load_data_reg		: 	out bit;
		load_alu_out		:	out	bit;
		load_a				:	out	bit;
		load_b				:	out	bit;
		pc_source			:	out	std_logic_vector(1 downto 0);		
		reg_write			:	out	bit;
		store_type			:	out	std_logic_vector(1 downto 0);
		mem_to_reg			:	out	std_logic_vector(2 downto 0);
		alu_src_a			:	out	bit;
		alu_src_b			:	out	std_logic_vector(1 downto 0);
		unsigned_instruction : 	out	bit;
		compare_instruction	: 	out	bit;
		alu_func			:	out std_logic_vector(2 downto 0);
		alu_mux				: 	out	std_logic_vector(1 downto 0);
		shift_control		:   out std_logic_vector(1 downto 0);
		mult_control		: 	out std_logic_vector(1 downto 0);
		alu_or_trap			: 	out bit;
		invalid_opcode		:	out	bit;

		reset				:	in	bit;
		clk					:	in	bit;
		exception			:	in	bit;
		zero				:	in	bit;
		nop_instruction		:	in	bit;
		end_mult			:   in  bit;
		opcode				: 	in 	std_logic_vector (5 downto 0);
		funct				:   in  std_logic_vector (5 downto 0)
);
end component;


begin	
reset <= reset_in;
clk <= clk_in;

processing 				:	processamento	port map(load_trap, equals, IorD, pc_write_cond, pc_write, beq, ir_write, reg_dest, mem_write, load_data_reg, reset, reset_pc, shift_control, alu_function, unsigned_instruction, compare_instruction, alu_src_b, alu_src_a, mem_to_reg, store_type, reg_write, invalid_opcode, pc_source, load_a, load_b, alu_or_trap, load_alu_out, alu_mux, mult_control, clk, funct, nop_instruction, opcode, zero, exception, end_multi);
control					:	Control_Unit	port map(load_trap, equals, IorD, pc_write_cond, pc_write, beq, ir_write, reg_dest, mem_write, reset_pc, load_data_reg, load_alu_out, load_a, load_b, pc_source, reg_write, store_type, mem_to_reg, alu_src_a, alu_src_b, unsigned_instruction, compare_instruction, alu_function, alu_mux, shift_control, mult_control, alu_or_trap, invalid_opcode, reset, clk, exception, zero, nop_instruction, end_multi, opcode, funct);														

debug_32_a (31 DOWNTO 26) <= opcode;
debug_32_a (25 DOWNTO 6) <= "00000000000000000000";
debug_32_a (5 DOWNTO 0) <= funct;
ir_write_t <= ir_write;

end cpu_arch;
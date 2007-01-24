library IEEE;
use IEEE.std_logic_1164.all;
USE ieee.std_logic_arith.all;

entity load_pc is
port(
	equals			:	in	bit;
	pc_write_cond	:	in	bit;
	pc_write		:	in	bit;
	beq				:	in	bit;
	
	load_pc			: 	out bit	
	);
end load_pc;

ARCHITECTURE default OF load_pc IS

begin


process (pc_write_cond, pc_write, equals, beq)

variable temp_in_and_1	: bit;
variable temp_in_and_2	: bit;
variable temp_mux		: bit;
variable temp_load_pc	: bit;

begin
	temp_in_and_1	:= (not equals) and pc_write_cond;
	temp_in_and_2	:= equals and pc_write_cond;
	if (beq = '0') then 
	    temp_mux := temp_in_and_1;
	else 
	    temp_mux := temp_in_and_2;
	end if;
    load_pc	<= pc_write or temp_mux;
end process;
	
END default;
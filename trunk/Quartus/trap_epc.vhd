library IEEE;
use IEEE.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY TRAP_EPC IS
	PORT
	(
		unsigned_instruction			: in	bit;
		invalid_opcode					: in    bit;
		overflow						: in 	bit;
		trap_type					 	: out	bit;
		load_epc						: out   bit;
		exception						: out	bit
	);
END TRAP_EPC;

ARCHITECTURE TRAP_EPC_ARCH OF TRAP_EPC IS
	
BEGIN
process(unsigned_instruction, invalid_opcode, overflow)

variable trap_type_temp : bit;
variable load_epc_temp : bit;
begin
	trap_type_temp := (not unsigned_instruction) and overflow;
	trap_type <= trap_type_temp;
	load_epc_temp := trap_type_temp or invalid_opcode;
	exception <= load_epc_temp;
	load_epc <= load_epc_temp;
				
end process;

END TRAP_EPC_ARCH;

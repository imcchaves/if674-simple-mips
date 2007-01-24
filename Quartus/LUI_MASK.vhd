library IEEE;
use IEEE.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY LUI_MASK IS
	PORT
	(
		input 							: IN	STD_LOGIC_VECTOR(15 DOWNTO 0);
		output						 	: OUT	STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END LUI_MASK;

ARCHITECTURE LUI_MASK_ARCH OF LUI_MASK IS
	
BEGIN
	output (31 downto 16) <= input(15 downto 0);
	output (15 downto 0) <= "0000000000000000";
				

END LUI_MASK_ARCH;
library IEEE;
use IEEE.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY MUX_2 IS
	PORT
	(
		input0, input1 					: IN	STD_LOGIC_VECTOR(31 DOWNTO 0);
		seletor							: IN    BIT;
		output						 	: OUT	STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END MUX_2;

ARCHITECTURE MUX_2_ARCH OF MUX_2 IS

BEGIN
	WITH seletor SELECT
		output <= input0 WHEN '0',
			  input1 WHEN '1';
				
END MUX_2_ARCH;

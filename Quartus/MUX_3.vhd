library IEEE;
use IEEE.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY MUX_3 IS
	PORT
	(
		input0, input1, input2			: IN	STD_LOGIC_VECTOR(31 DOWNTO 0);
		seletor							: IN   STD_LOGIC_VECTOR(1 DOWNTO 0);
		output						 	: OUT	STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END MUX_3;

ARCHITECTURE MUX_3_ARCH OF MUX_3 IS
	
BEGIN
	WITH seletor SELECT
		output <= input0 WHEN "00", 
				  input1 WHEN "01",
				  input2 WHEN others;
				

END MUX_3_ARCH;
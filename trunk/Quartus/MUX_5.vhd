library IEEE;
use IEEE.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY MUX_5 IS
	PORT
	(
		input0, input1, input2, input3, input4	: IN	STD_LOGIC_VECTOR(31 DOWNTO 0);
		seletor									: IN   STD_LOGIC_VECTOR(2 DOWNTO 0);
		output						 			: OUT	STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END MUX_5;

ARCHITECTURE MUX_5_ARCH OF MUX_5 IS
	
BEGIN
	WITH seletor SELECT
		output <= input0 WHEN "000", 
				  input1 WHEN "001",
				  input2 WHEN "010",
				  input3 WHEN "011",
				  input4 WHEN others;
				

END MUX_5_ARCH;
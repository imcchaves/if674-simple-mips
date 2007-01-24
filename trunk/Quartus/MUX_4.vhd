library IEEE;
use IEEE.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY MUX_4 IS
	PORT
	(
		input0, input1, input2, input3	: IN	STD_LOGIC_VECTOR(31 DOWNTO 0);
		seletor							: IN   STD_LOGIC_VECTOR(1 DOWNTO 0);
		output						 	: OUT	STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END MUX_4;

ARCHITECTURE MUX_4_ARCH OF MUX_4 IS
	
BEGIN
	WITH seletor SELECT
		output <= input0 WHEN "00", 
				  input1 WHEN "01",
				  input2 WHEN "10",
				  input3 WHEN "11";
				

END MUX_4_ARCH;

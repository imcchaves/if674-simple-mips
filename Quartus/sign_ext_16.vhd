LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY sign_ext_16 IS
	PORT (
		vector_16		: IN	STD_LOGIC_VECTOR (15 DOWNTO 0);
		vector_32		: OUT	STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
END sign_ext_16;

ARCHITECTURE default OF sign_ext_16 IS
BEGIN
	vector_32 (15 DOWNTO 0) <= vector_16 (15 DOWNTO 0);
	
	WITH vector_16 (15) SELECT
		vector_32 (31 DOWNTO 16) <=  "0000000000000000" WHEN '0',
									 "1111111111111111" WHEN '1';
END default;


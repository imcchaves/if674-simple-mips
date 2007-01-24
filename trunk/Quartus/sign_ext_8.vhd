LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY sign_ext_8 IS
	PORT (
		vector_8		: IN	STD_LOGIC_VECTOR (7 DOWNTO 0);
		vector_32		: OUT	STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
END sign_ext_8;

ARCHITECTURE default OF sign_ext_8 IS
BEGIN
	vector_32 (7 DOWNTO 0) <= vector_8 (7 DOWNTO 0);
	
	WITH vector_8 (7) SELECT
		vector_32 (31 DOWNTO 8) <=  "000000000000000000000000" WHEN '0',
									"111111111111111111111111" WHEN '1';
END default;
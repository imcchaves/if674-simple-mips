LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY shift_left_2_32 IS
	PORT (
		vector_32_input		: IN	STD_LOGIC_VECTOR (31 DOWNTO 0);
		vector_32_output	: OUT	STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
END shift_left_2_32;

ARCHITECTURE default OF shift_left_2_32 IS
BEGIN
	vector_32_output (31) <= vector_32_input (29);
	vector_32_output (30) <= vector_32_input (28);
	vector_32_output (29) <= vector_32_input (27);
	vector_32_output (28) <= vector_32_input (26);
	vector_32_output (27) <= vector_32_input (25);
	vector_32_output (26) <= vector_32_input (24);
	vector_32_output (25) <= vector_32_input (23);
	vector_32_output (24) <= vector_32_input (22);
	vector_32_output (23) <= vector_32_input (21);
	vector_32_output (22) <= vector_32_input (20);
	vector_32_output (21) <= vector_32_input (19);
	vector_32_output (20) <= vector_32_input (18);
	vector_32_output (19) <= vector_32_input (17);
	vector_32_output (18) <= vector_32_input (16);
	vector_32_output (17) <= vector_32_input (15);
	vector_32_output (16) <= vector_32_input (14);
	vector_32_output (15) <= vector_32_input (13);
	vector_32_output (14) <= vector_32_input (12);
	vector_32_output (13) <= vector_32_input (11);
	vector_32_output (12) <= vector_32_input (10);
	vector_32_output (11) <= vector_32_input (9);
	vector_32_output (10) <= vector_32_input (8);
	vector_32_output (9) <= vector_32_input (7);
	vector_32_output (8) <= vector_32_input (6);
	vector_32_output (7) <= vector_32_input (5);
	vector_32_output (6) <= vector_32_input (4);
	vector_32_output (5) <= vector_32_input (3);
	vector_32_output (4) <= vector_32_input (2);
	vector_32_output (3) <= vector_32_input (1);
	vector_32_output (2) <= vector_32_input (0);
	vector_32_output (1 DOWNTO 0) <= "00";
END default;

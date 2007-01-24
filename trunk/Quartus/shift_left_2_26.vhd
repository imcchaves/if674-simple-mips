LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY shift_left_2_26 IS
	PORT (
		vector_26_input		: IN	STD_LOGIC_VECTOR (25 DOWNTO 0);
		vector_28_output	: OUT	STD_LOGIC_VECTOR (27 DOWNTO 0)
	);
END shift_left_2_26;

ARCHITECTURE default OF shift_left_2_26 IS
BEGIN
	vector_28_output (27) <= vector_26_input (25);
	vector_28_output (26) <= vector_26_input (24);
	vector_28_output (25) <= vector_26_input (23);
	vector_28_output (24) <= vector_26_input (22);
	vector_28_output (23) <= vector_26_input (21);
	vector_28_output (22) <= vector_26_input (20);
	vector_28_output (21) <= vector_26_input (19);
	vector_28_output (20) <= vector_26_input (18);
	vector_28_output (19) <= vector_26_input (17);
	vector_28_output (18) <= vector_26_input (16);
	vector_28_output (17) <= vector_26_input (15);
	vector_28_output (16) <= vector_26_input (14);
	vector_28_output (15) <= vector_26_input (13);
	vector_28_output (14) <= vector_26_input (12);
	vector_28_output (13) <= vector_26_input (11);
	vector_28_output (12) <= vector_26_input (10);
	vector_28_output (11) <= vector_26_input (9);
	vector_28_output (10) <= vector_26_input (8);
	vector_28_output (9) <= vector_26_input (7);
	vector_28_output (8) <= vector_26_input (6);
	vector_28_output (7) <= vector_26_input (5);
	vector_28_output (6) <= vector_26_input (4);
	vector_28_output (5) <= vector_26_input (3);
	vector_28_output (4) <= vector_26_input (2);
	vector_28_output (3) <= vector_26_input (1);
	vector_28_output (2) <= vector_26_input (0);
	vector_28_output (1 DOWNTO 0) <= "00";
END default;

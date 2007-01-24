library IEEE;
use IEEE.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY NOP_DETECTOR IS
	PORT
	(
		input							: IN	STD_LOGIC_VECTOR(31 DOWNTO 0);
		output							: OUT 	BIT 
	);
END NOP_DETECTOR;

ARCHITECTURE NOP_DETECTOR_ARCH OF NOP_DETECTOR IS
BEGIN
	PROCESS(input)
	BEGIN
		IF(input = "00000000000000000000000000000000") then
			output <= '1';

		ELSE
			output <= '0';
		END IF;
	END PROCESS;

END NOP_DETECTOR_ARCH;
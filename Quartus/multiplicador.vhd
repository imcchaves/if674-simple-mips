LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
USE IEEE.std_logic_arith.all;
USE IEEE.std_logic_unsigned.all;

ENTITY multiplicador IS
	PORT (
		A, B	:	IN	STD_LOGIC_VECTOR (31 DOWNTO 0);
		control	:	IN	STD_LOGIC_VECTOR (1 DOWNTO 0);
		reset	:	IN	STD_LOGIC;
		clk		:	IN	STD_LOGIC;
		fim		:	OUT STD_LOGIC;
		saida	:	OUT	STD_LOGIC_VECTOR (31 DOWNTO 0)
	);
END multiplicador;


ARCHITECTURE default OF multiplicador IS
	shared variable shift_reg 						:	STD_LOGIC_VECTOR (63 DOWNTO 0);
	shared variable current_b						:	STD_LOGIC_VECTOR (31 DOWNTO 0);
	shared variable counter 						:	STD_LOGIC_VECTOR (5 DOWNTO 0);
	shared variable op_type							:	STD_LOGIC_VECTOR (1 DOWNTO 0);
	shared variable last_bit						:	STD_LOGIC;
	shared variable its_done						:	STD_LOGIC;
	
BEGIN
	PROCESS (clk, reset) BEGIN	
		if (reset = '1') then
			last_bit 								:= '0';
			shift_reg 								:= "0000000000000000000000000000000000000000000000000000000000000000";
			counter 								:= "000000";
			fim										<= '1';
			its_done								:= '1';
			
		elsif (clk = '1' and clk'event) then
			if (control = "00") then
				if (its_done = '0') then
					op_type (0) 						:= last_bit;
					op_type (1) 						:= shift_reg (0);
										
					case (op_type) is
						when "00" | "11" =>
							shift_reg (63 DOWNTO 32) 	:= shift_reg (63 DOWNTO 32);
						when "10" =>
							shift_reg (63 DOWNTO 32) 	:= shift_reg (63 DOWNTO 32) - current_b;
						when "01" =>
							shift_reg (63 DOWNTO 32) 	:= shift_reg (63 DOWNTO 32) + current_b;
					end case;
					
					last_bit := shift_reg (0);
					
					shift_reg (63) 						:= shift_reg (63);
					shift_reg (62 DOWNTO 0) 			:= shift_reg (63 DOWNTO 1);
					
					if (shift_reg = "1111111111111111111111111111111111111111111111111111111111111111") then
						shift_reg := "0000000000000000000000000000000000000000000000000000000000000000";
					end if;
					
					counter := counter + '1';
					
					if (counter = "100000") then
						fim <= '1';
						its_done := '1';
					end if;
				end if;
			elsif (control = "01") then
				shift_reg (31 DOWNTO 0) 			:= A;
				current_b 							:= B;
				counter 							:= "000000";
				last_bit 							:= '0';
				fim									<= '0';
				its_done							:= '0';
			elsif (control = "10") then
				saida <= shift_reg (31 DOWNTO 0);
			else
				saida <= shift_reg (63 DOWNTO 32);
			end if;
		end if;
	END PROCESS;
END default;

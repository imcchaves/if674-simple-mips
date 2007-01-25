library IEEE;
use IEEE.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY Control_Unit IS
	PORT (	    
		load_trap			:	out	bit;
		equals				:	out	bit;
		IorD				:	out	bit;
		pc_write_cond		:	out	bit;
		pc_write			:	out	bit;
		beq					:	out	bit;
		ir_write			:	out	bit;
		reg_dest			:	out	std_logic_vector(1 downto 0);
		mem_read_write		:	out	bit;
		reset_pc			:	out	bit;
		load_data_reg		: 	out bit;
		load_alu_out		:	out	bit;
		load_a				:	out	bit;
		load_b				:	out	bit;
		pc_source			:	out	std_logic_vector(1 downto 0);		
		reg_write			:	out	bit;
		store_type			:	out	std_logic_vector(1 downto 0);
		mem_to_reg			:	out	std_logic_vector(2 downto 0);
		alu_src_a			:	out	bit;
		alu_src_b			:	out	std_logic_vector(1 downto 0);
		unsigned_instruction : 	out	bit;
		compare_instruction	: 	out	bit;
		alu_func			:	out std_logic_vector(2 downto 0);
		alu_mux				: 	out	std_logic_vector(1 downto 0);
		shift_control		:   out std_logic_vector(1 downto 0);
		mult_control		: 	out std_logic_vector(1 downto 0);
		alu_or_trap			: 	out bit;
		invalid_opcode		:	out	bit;
		
		reset				:	in	bit;
		clk					:	in	bit;
		exception			:	in	bit;
		zero				:	in	bit;
		nop_instruction		:	in	bit;
		end_mult			:   in  bit;
		opcode				: 	in 	std_logic_vector (5 downto 0);
		funct				:   in  std_logic_vector (5 downto 0)
	);
END Control_Unit;


ARCHITECTURE Control_Unit_Arch OF Control_Unit IS

type estados is ( start_up_1, start_up_2, wait_1,wait_2, wait_3,load,i_nop,exception_2,fetch,i_store_word
                  ,i_store_half,i_store_byte,i_load_word,i_load_half,i_load_byte, i_mfhi, i_mflo, load_shift, i_shift_ra,i_shift_rl,i_shift_ll
                  ,calc_addr_1,exception_1,i_ret,i_jump,i_jal_1,i_lui,i_mult,i_break,calc_addr_2,i_jal_2
                  ,wait_mult,shift_to_reg, calc_addr_3,load_ab,i_slti,i_xori,i_andi,i_addi_addui,i_sub_subu,i_add_addu
                  ,i_and_1,i_xor_1,i_slt,i_jr,imm_to_reg,i_beq,i_bne,alu_to_reg,pc_4);

signal estado_atual 	: estados;

signal fetch_v 		: std_logic;
signal exception_v 	: std_logic;
signal zero_v 		: std_logic;
	     
begin
		process(estado_atual, reset)
		begin
			load_trap				<= '0';
			mem_read_write			<= '0';
			ir_write				<= '0';
			iord					<= '0';
			pc_write				<= '0';
			beq						<= '0';
			pc_write_cond			<= '0';
			reset_pc				<= '0';
			alu_src_a				<= '0';
			alu_src_b				<= "01";
			pc_source				<= "01";
			load_trap				<= '0';
			alu_or_trap				<= '1';
			reg_write				<= '0';
			load_a					<= '0';
			load_b					<= '0';
			reg_dest				<= "00";
			load_data_reg			<= '0';
			mem_to_reg				<= "000";
			shift_control			<= "00";
			alu_mux					<= "10";
			load_data_reg			<= '0';
			compare_instruction		<= '0';
			unsigned_instruction	<= '0';
			reset_pc				<= '0';
			mult_control			<= "01";
			invalid_opcode			<= '0';
			load_alu_out			<= '0';
			alu_func				<= "001";
			equals					<= '0';
			store_type				<= "00";
			
			if (reset = '1') then
				
			else 		
				case estado_atual is
					when start_up_1 =>
						reset_pc <= '1';
				
					when start_up_2 =>
						reg_write <= '1';
						mem_to_reg <= "100";
						reg_dest <= "11";
					
					when wait_1 =>
								
					when wait_2 =>
						if (exception_v = '1') then

						elsif (fetch_v = '0') then						
							if (opcode = "100011" or  opcode = "100000" or  opcode = "100001") then
							elsif (opcode = "101011") then
							elsif (opcode = "101000") then
							elsif (opcode = "101001") then
							end if;
						elsif (nop_instruction = '1') then
						else
							--fetch_v := '1';
						end if;

					when wait_3 =>
						ir_write <= '1';

					when load =>
						--fetch_v := '1';
						load_data_reg <= '1';

					when i_nop =>
						pc_write <= '1';

					when exception_2 => 
						load_trap <= '1';
						--exception_v := '0';
						pc_write <= '1';
					
					when fetch =>
						if (opcode = "000000") then
							if (funct = "010000") then
							elsif (funct = "010010") then
							elsif (funct = "000011" or funct = "000010" or funct = "000000") then
							elsif (funct = "011000") then
							elsif (funct = "001101") then
							else							 
							end if;
						elsif (opcode = "100011" or opcode = "100000" or opcode = "100001" or opcode = "101011" or opcode = "101000" or opcode = "101001") then
						elsif (opcode = "010000" and funct = "010000") then
						elsif (opcode = "000010") then
						elsif (opcode = "000011") then
						elsif (opcode = "001111") then
						elsif (opcode = "001000" or opcode = "001001" or opcode = "001101" or opcode = "001110" or opcode = "001010") then
						elsif (opcode = "000100" or opcode = "000101") then
							pc_write <= '1';
						else	
							invalid_opcode <= '1';
							--exception_v := '1';
						end if;

					when i_store_word => 
						store_type <= "00";
						mem_read_write <= '1';
						iord <= '1';
						pc_write <= '1';
						
					when i_store_half => 
						store_type <= "01";
						mem_read_write <= '1';
						iord <= '1';
						pc_write <= '1';					

					when i_store_byte => 
						store_type <= "10";
						mem_read_write <= '1';
						iord <= '1';
						pc_write <= '1';
						
					when i_load_word =>
						mem_to_reg <= "011";
						reg_write <= '1';
						pc_write <= '1';

					when i_load_half =>
						mem_to_reg <= "010";
						reg_write <= '1';
						pc_write <= '1';

					when i_load_byte =>
						mem_to_reg <= "001";
						reg_write <= '1';
                     	pc_write <= '1';

					when i_mfhi =>
						reg_dest <= "10";
						mult_control <= "11";
						alu_mux <= "00";
						mem_to_reg <= "000";
						reg_write <= '1';
						pc_write <= '1';

					when i_mflo =>
						reg_dest <= "10";
						mult_control <= "10";
						alu_mux <= "00";
						mem_to_reg <= "000";
						reg_write <= '1';
						pc_write <= '1';

					when load_shift =>

					when i_shift_ra =>
						shift_control <= "01";

					when i_shift_rl =>
						shift_control <= "10";

					when i_shift_ll =>
						shift_control <= "11";

					when shift_to_reg =>
						alu_mux <= "01";
						reg_dest <= "10";
						reg_write <= '1';
						pc_write <= '1';

					when calc_addr_1 =>
						load_a <= '1';
						load_b <= '1';

					when calc_addr_2 =>
						alu_src_a <= '1';
						alu_src_b <= "10";
						alu_func <= "001";
						load_alu_out <= '1';

					when calc_addr_3 =>
						IorD <= '1';
						--fetch_v := '0';

					when exception_1 =>
						alu_or_trap <= '0';
						pc_source <= "10";
						pc_write <= '1';

					when i_ret =>
						pc_source <= "00";
						pc_write <= '1';

					when i_jump =>
						pc_source <= "11";
						pc_write <= '1';

					when i_jal_1 =>
						alu_func <= "000";
						load_alu_out <= '1';

					when i_jal_2 =>
						reg_dest <= "01";
						reg_write <='1';

					when i_lui =>
						mem_to_reg <= "100";
						reg_write <= '1';
						pc_write <= '1';

					when i_mult =>

					when wait_mult =>
						mult_control <= "00";
						
						if (end_mult = '1') then
							pc_write <= '1';
						end if;
					
					when i_break =>

					when load_ab =>
						load_a <= '1';
						load_b <= '1';

					when i_slti =>
					   	alu_src_a <= '1';
					   	alu_src_b <= "10";
					   	alu_func <= "111";
					   	compare_instruction <= '1';
					   	load_alu_out <= '1';

					when i_xori =>
					   	alu_src_a <= '1';
					   	alu_src_b <= "10";
					   	alu_func <= "110";
					   	load_alu_out <= '1';

					when i_andi =>
					 	alu_src_a <= '1';
					  	alu_src_b <= "10";
					  	alu_func <= "011";
					  	load_alu_out <= '1';

                    when i_sub_subu =>
						if (opcode = "000000" and funct = "100011") then
							unsigned_instruction <= '1';
						end if;

                       	alu_src_a <= '1';
                       	alu_src_b <= "00";
                       	alu_func <= "010";
                       	load_alu_out <= '1';

                        if (opcode = "000100") then
						   	if (zero = '1') then
							else
							end if;
						elsif (opcode = "000101") then 
						    if (zero = '0') then
                            else
							end if;
						else
							if (funct = "100010" and exception = '1') then
								--exception_v := '1';
							else

							end if;
						end if;        			

				    when i_add_addu =>
						if (opcode = "000000" and funct = "100001") then
							unsigned_instruction <= '1';
						end if;
						
				       	alu_src_a <= '1';
				       	alu_src_b <= "00";
				       	alu_func <= "001";
				       	load_alu_out <= '1';
				
						if (funct = "100000" and exception = '1') then
							--exception_v := '1';
						else 
						end if;

				    when i_and_1 =>
				        alu_src_a <= '1';
				        alu_src_b <= "00";
				        alu_func <= "011";
				        load_alu_out <= '1';

				    when i_xor_1 =>
				        alu_src_a <= '1';
				        alu_src_b <= "00";
				        alu_func <= "110";
				        load_alu_out <= '1';

					when i_slt =>
						alu_src_a <= '1';
						alu_src_b <= "00";
						alu_func <= "111";
						compare_instruction <= '1';
						load_alu_out <= '1';

					when i_jr =>
						alu_src_a <= '1';
						alu_func <= "000";
						pc_write <= '1';

					when i_addi_addui =>
						alu_src_a <= '1';
					  	alu_src_b <= "10";
					  	alu_func <= "001";
					 	load_alu_out <= '1';

						if (opcode = "001001") then
							unsigned_instruction <= '1'; --verificar isso
						elsif (opcode = "001000" and exception = '1') then
							--exception_v := '1';
						else

						end if;

					when alu_to_reg =>
					  	reg_dest  <= "01";
					  	reg_write <= '1';
					  	pc_write <= '1';

				    when i_bne =>
				    	alu_src_b <= "11";
				    	alu_func <= "001";
				    	pc_write_cond <= '1';
				    	beq <= '0';
				    	equals <= '0';

				   when i_beq =>
				     	alu_src_b  <= "11";
				     	alu_func <= "001";
				     	pc_write_cond <= '1';
				     	beq <= '1';
				     	equals <= '1';

				   when imm_to_reg =>
				      	reg_write <= '1';
				      	pc_write <= '1';

				   when pc_4 =>
             			pc_write <= '1';
				end case;
			end if;
		end process;

		process (clk,reset)
		begin
			if (reset = '1') then
				exception_v 	<= '0';
				fetch_v			<= '0';
				zero_v			<= '0';
				estado_atual <= start_up_1;

			elsif (clk = '1' and clk'EVENT) then
				case estado_atual is
					when start_up_1 =>
						estado_atual <= start_up_2;

					when start_up_2 =>
						estado_atual <= wait_1;

					when wait_1 =>
						estado_atual <= wait_2;

					when wait_2 =>
						if (exception_v = '1') then
							estado_atual <= exception_2;

						elsif (fetch_v = '0') then		-- ISOLEI ISSO AKI, PRO CODIGO FICAR MAIS LIMPO : tavl
							if (opcode = "100011" or opcode = "100000" or opcode = "100001") then
								estado_atual <= load;

							elsif (opcode = "101011") then
								estado_atual <= i_store_word;

							elsif (opcode = "101000") then	
						    	estado_atual <= i_store_byte;

							elsif (opcode = "101001") then
						    	estado_atual <= i_store_half;
							end if;

						elsif (nop_instruction = '1') then
							estado_atual <= i_nop;

	   					else
							fetch_v <= '1';
							estado_atual <= wait_3 ;
						end if;

					when wait_3 =>
						estado_atual <= fetch;

					when load =>
						fetch_v <= '1';
						if (opcode = "100000") then 
							estado_atual <= i_load_byte;

						elsif(opcode = "100001") then
							estado_atual <= i_load_half;

						else
							estado_atual <= i_load_word;

						end if;
					when i_nop =>
						estado_atual <= wait_1;
	
					when exception_2 =>
						exception_v <= '0';
						estado_atual <= wait_1;

					when fetch =>
						if (opcode = "000000") then
							if (funct = "010000") then
								estado_atual  <= i_mfhi;

							elsif (funct = "010010") then
								estado_atual <= i_mflo;

							elsif (funct = "000011" or funct = "000010" or funct = "000000") then
								estado_atual <= load_shift;

							elsif( funct = "011000") then
								estado_atual <= i_mult;

							elsif (funct = "001101") then
								estado_atual <= i_break;

							else 
								estado_atual <= load_ab;
							end if;
						elsif (opcode = "100011" or opcode = "100000" or opcode = "100001" or opcode = "101011" or opcode = "101000" or opcode = "101001") then
							estado_atual <= calc_addr_1;

						elsif (opcode = "010000" and funct = "010000") then
							estado_atual <= i_ret;

						elsif (opcode = "000010") then
							estado_atual <= i_jump;

						elsif (opcode = "000011") then
							estado_atual <= i_jal_1;

						elsif (opcode = "001111") then
							estado_atual <= i_lui;

						elsif (opcode = "001000" or opcode = "001001" or opcode = "001101" or opcode = "001110" or opcode = "001010") then
							estado_atual <= load_ab;

						elsif(opcode = "000100" or opcode = "000101") then
							estado_atual <= load_ab;

						else
						
	    				end if;

					when i_store_word => 
						estado_atual <= wait_1;

					when i_store_half => 
						estado_atual <= wait_1;

					when i_store_byte => 
						estado_atual <= wait_1;

					when i_load_word =>
						estado_atual <= wait_1;

					when i_load_half =>
					    estado_atual <= wait_1;

					when i_load_byte =>
                        estado_atual <= wait_1;

					when i_mfhi =>
						estado_atual <= wait_1;

					when i_mflo =>
					    estado_atual <= wait_1;

					when load_shift =>
						if (funct = "000011") then
							estado_atual <= i_shift_ra;

						elsif (funct = "000010") then 
							estado_atual <= i_shift_rl;

						else
							estado_atual <= i_shift_ll;
						end if;
					
					when i_shift_ra =>
						estado_atual <= shift_to_reg;

					when i_shift_rl =>
						estado_atual <= shift_to_reg;

					when i_shift_ll =>
						estado_atual <= shift_to_reg;

					when shift_to_reg =>
						estado_atual <= wait_1;

					when calc_addr_1 =>
						fetch_v <= '0';
						estado_atual <= calc_addr_2;

					when calc_addr_2 =>
        				estado_atual <= calc_addr_3;

					when calc_addr_3 =>
            			estado_atual <= wait_1;

					when exception_1 =>
						estado_atual <= wait_1;

					when i_ret =>
						estado_atual <= wait_1;

					when i_jump =>
						estado_atual <= wait_1;

					when i_jal_1 =>
						estado_atual <= i_jal_2;

					when i_jal_2 =>
						estado_atual <= i_jump;

					when i_lui =>
						estado_atual <= wait_1;

					when i_mult =>
						estado_atual <= wait_mult;

					when wait_mult =>
						if (end_mult = '1') then
							estado_atual <= wait_1;
						end if;

					when i_break =>
						estado_atual  <= i_break;

					when load_ab =>
						if (opcode = "001010") then
							estado_atual <= i_slti;

						elsif (opcode = "001110") then
							estado_atual <= i_xori;

						elsif (opcode = "001101") then
							estado_atual <= i_andi;

						elsif (opcode = "001000" or opcode = "001001") then
							estado_atual <= i_addi_addui;

						elsif (opcode =  "000000") then
							if (funct = "100010" or funct = "100011") then
								estado_atual <= i_sub_subu;

							elsif (funct = "100000" or funct = "100001") then
								estado_atual <= i_add_addu;

							elsif (funct = "100100") then
								estado_atual <= i_and_1;

							elsif (funct = "100110") then
								estado_atual <= i_xor_1;

							elsif (funct = "101010") then
								estado_atual <= i_slt;

							elsif (funct = "001000") then
							    estado_atual <= i_jr;
							end if;
					 	end if;

					when i_slti =>
					    estado_atual <= imm_to_reg;

					when i_xori =>
					    estado_atual <= imm_to_reg;

					when i_andi =>
						estado_atual <= imm_to_reg;

                    when i_sub_subu =>
						if (opcode = "000000" and funct = "100011") then

						elsif (opcode = "000100") then
						   	if (zero = '1') then
								estado_atual <= i_beq;

							else
								estado_atual <= pc_4;
							end if;

						elsif (opcode = "000101") then 
							if (zero = '0') then
								estado_atual <= i_bne;

                            else
								estado_atual <= pc_4;
							end if;
						else
							if (funct = "100010" and exception = '1') then
								exception_v <= '1';
								estado_atual <= exception_1;

							else
								estado_atual <= alu_to_reg;
							end if;
						end if;

				    when i_add_addu =>
						if (opcode = "000000" and funct = "100001") then

						elsif (funct = "100000" and exception = '1') then
							exception_v <= '1';
						else
							estado_atual <= alu_to_reg;
						end if;

				    when i_and_1 =>
						estado_atual <= alu_to_reg;

				    when i_xor_1 =>
						estado_atual <= alu_to_reg;

					when i_slt =>
						estado_atual <= alu_to_reg;

					when i_jr =>
						estado_atual <= wait_1;

					when i_addi_addui =>
						if (opcode = "001001") then

						elsif (opcode = "001000" and exception = '1') then
							exception_v <= '1';
							estado_atual <= exception_1;

						else 
							estado_atual <= imm_to_reg;
						end if;

					when alu_to_reg =>
						estado_atual <= wait_1;

				    when i_bne =>
						estado_atual <= wait_1;

				   when i_beq =>
				      	estado_atual <= wait_1;

				   when imm_to_reg =>
						estado_atual <= wait_1;

				   when pc_4 =>
						estado_atual <= wait_1;

				end case;
			end if;
      end process;
END Control_Unit_Arch;
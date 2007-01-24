--------------------------------------------------------------------------------
-- Title		: Banco de Registradores
-- Project		: CPU Multi-ciclo
--------------------------------------------------------------------------------
-- File			: Banco_reg.vhd
-- Author		: Emannuel Gomes Macêdo (egm@cin.ufpe.br)
--				  Fernando Raposo Camara da Silva (frcs@cin.ufpe.br)
--				  Pedro Machado Manhães de Castro (pmmc@cin.ufpe.br)
--				  Rodrigo Alves Costa (rac2@cin.ufpe.br)
-- Organization : Universidade Federal de Pernambuco
-- Created		: 29/07/2002
-- Last update	: 21/11/2002
-- Plataform	: Flex10K
-- Simulators	: Altera Max+plus II
-- Synthesizers	: 
-- Targets		: 
-- Dependency	: 
--------------------------------------------------------------------------------
-- Description	: Entidade que armazena o conjunto de registradores da cpu, no
-- qual pode ser efetuado leitura e escrita de dados.
--------------------------------------------------------------------------------
-- Copyright (c) notice
--		Universidade Federal de Pernambuco (UFPE).
--		CIn - Centro de Informatica.
--		Developed by computer science undergraduate students.
--		This code may be used for educational and non-educational purposes as 
--		long as its copyright notice remains unchanged. 
--------------------------------------------------------------------------------
-- Revisions		: 1
-- Revision Number	: 1.0
-- Version			: 1.1
-- Date				: 21/11/2002
-- Modifier			: Marcus Vinicius Lima e Machado (mvlm@cin.ufpe.br)
--				  	  Paulo Roberto Santana Oliveira Filho (prsof@cin.ufpe.br)
--					  Viviane Cristina Oliveira Aureliano (vcoa@cin.ufpe.br)
-- Description		:
--------------------------------------------------------------------------------

--Short name: breg
ENTITY Banco_reg IS
		PORT(
			Clk			: IN	bit;						-- Clock do banco de registradores
			Reset		: IN	bit;						-- Reinicializa o conteudo dos registradores
			RegWrite	: IN	bit;						-- Indica se a operação é de escrita ou leitura
			ReadReg1	: IN	bit_vector (4 downto 0);	-- Indica o registrador #1 a ser lido
			ReadReg2	: IN	bit_vector (4 downto 0);	-- Indica o registrador #2 a ser lido
			WriteReg	: IN	bit_vector (4 downto 0);	-- Indica o registrador a ser escrito
			WriteData 	: IN	bit_vector (31 downto 0);	-- Indica o dado a ser escrito
			ReadData1	: OUT	bit_vector (31 downto 0);	-- Mostra a informaçao presente no registrador #1
			ReadData2	: OUT	bit_vector (31 downto 0)	-- Mostra a informação presente no registrador #2
			);
END Banco_reg ;

-- Arquitetura que define comportamento do Banco de Registradores
-- Simulation
ARCHITECTURE behavioral_arch OF Banco_reg IS

	SIGNAL Reg0		: bit_vector (31 downto 0);		-- Conjunto 
	SIGNAL Reg1		: bit_vector (31 downto 0);		-- das informações
	SIGNAL Reg2		: bit_vector (31 downto 0);		-- pertencentes
	SIGNAL Reg3		: bit_vector (31 downto 0);		-- aos registradores.
	SIGNAL Reg4		: bit_vector (31 downto 0);		-- Esta CPU
	SIGNAL Reg5		: bit_vector (31 downto 0);		-- possui
	SIGNAL Reg6		: bit_vector (31 downto 0);		-- 32 registradores
	SIGNAL Reg7		: bit_vector (31 downto 0);		-- de uso
	SIGNAL Reg8		: bit_vector (31 downto 0);		-- comum.
	SIGNAL Reg9 	: bit_vector (31 downto 0);
	SIGNAL Reg10	: bit_vector (31 downto 0);
	SIGNAL Reg11	: bit_vector (31 downto 0);
	SIGNAL Reg12	: bit_vector (31 downto 0);
	SIGNAL Reg13	: bit_vector (31 downto 0);
	SIGNAL Reg14	: bit_vector (31 downto 0);
	SIGNAL Reg15	: bit_vector (31 downto 0);	
	SIGNAL Reg16	: bit_vector (31 downto 0);
	SIGNAL Reg17	: bit_vector (31 downto 0);
	SIGNAL Reg18	: bit_vector (31 downto 0);
	SIGNAL Reg19	: bit_vector (31 downto 0);
	SIGNAL Reg20	: bit_vector (31 downto 0);
	SIGNAL Reg21	: bit_vector (31 downto 0);
	SIGNAL Reg22	: bit_vector (31 downto 0);
	SIGNAL Reg23	: bit_vector (31 downto 0);
	SIGNAL Reg24	: bit_vector (31 downto 0);
	SIGNAL Reg25	: bit_vector (31 downto 0);
	SIGNAL Reg26	: bit_vector (31 downto 0);
	SIGNAL Reg27	: bit_vector (31 downto 0);
	SIGNAL Reg28	: bit_vector (31 downto 0);
	SIGNAL Reg29	: bit_vector (31 downto 0);
	SIGNAL Reg30	: bit_vector (31 downto 0);
	SIGNAL Reg31	: bit_vector (31 downto 0);	
	BEGIN
	
	-- selecao do primeiro registrador
	WITH ReadReg1 SELECT
		ReadData1 <= Reg0  WHEN "00000",	-- acesso às informações do registrador correspondente
                     Reg1  WHEN "00001",
                     Reg2  WHEN "00010",
                	 Reg3  WHEN "00011",
	                 Reg4  WHEN "00100",
    	             Reg5  WHEN "00101",
        	         Reg6  WHEN "00110",
            	     Reg7  WHEN "00111",
                	 Reg8  WHEN "01000",
	                 Reg9  WHEN "01001",
    	             Reg10 WHEN "01010",
        	         Reg11 WHEN "01011",
            	     Reg12 WHEN "01100",
                	 Reg13 WHEN "01101",
	                 Reg14 WHEN "01110",
    	             Reg15 WHEN "01111",
                     Reg16 WHEN "10000",
                     Reg17 WHEN "10001",
                     Reg18 WHEN "10010",
                	 Reg19 WHEN "10011",
	                 Reg20 WHEN "10100",
    	             Reg21 WHEN "10101",
        	         Reg22 WHEN "10110",
            	     Reg23 WHEN "10111",
                	 Reg24 WHEN "11000",
	                 Reg25 WHEN "11001",
    	             Reg26 WHEN "11010",
        	         Reg27 WHEN "11011",
            	     Reg28 WHEN "11100",
                	 Reg29 WHEN "11101",
	                 Reg30 WHEN "11110",
    	             Reg31 WHEN "11111";

	-- selecao do segundo registrador 
	WITH ReadReg2 SELECT
		ReadData2 <= Reg0  WHEN "00000",	-- acesso às informações do registrador correspondente
                     Reg1  WHEN "00001",
                     Reg2  WHEN "00010",
                	 Reg3  WHEN "00011",
	                 Reg4  WHEN "00100",
    	             Reg5  WHEN "00101",
        	         Reg6  WHEN "00110",
            	     Reg7  WHEN "00111",
                	 Reg8  WHEN "01000",
	                 Reg9  WHEN "01001",
    	             Reg10 WHEN "01010",
        	         Reg11 WHEN "01011",
            	     Reg12 WHEN "01100",
                	 Reg13 WHEN "01101",
	                 Reg14 WHEN "01110",
    	             Reg15 WHEN "01111",
                     Reg16 WHEN "10000",
                     Reg17 WHEN "10001",
                     Reg18 WHEN "10010",
                	 Reg19 WHEN "10011",
	                 Reg20 WHEN "10100",
    	             Reg21 WHEN "10101",
        	         Reg22 WHEN "10110",
            	     Reg23 WHEN "10111",
                	 Reg24 WHEN "11000",
	                 Reg25 WHEN "11001",
    	             Reg26 WHEN "11010",
        	         Reg27 WHEN "11011",
            	     Reg28 WHEN "11100",
                	 Reg29 WHEN "11101",
	                 Reg30 WHEN "11110",
    	             Reg31 WHEN "11111";

	--  Clocked Process
	process (Clk,Reset)
		begin
			
------------------------------------------- Reset inicializa o conjunto de registradores
			if(Reset = '1') then
				Reg0  <= "00000000000000000000000000000000";
				Reg1  <= "00000000000000000000000000000000";
				Reg2  <= "00000000000000000000000000000000";
				Reg3  <= "00000000000000000000000000000000";
				Reg4  <= "00000000000000000000000000000000";
				Reg5  <= "00000000000000000000000000000000";
				Reg6  <= "00000000000000000000000000000000";
				Reg7  <= "00000000000000000000000000000000";
				Reg8  <= "00000000000000000000000000000000";
				Reg9  <= "00000000000000000000000000000000";
				Reg10 <= "00000000000000000000000000000000";
				Reg11 <= "00000000000000000000000000000000";
				Reg12 <= "00000000000000000000000000000000";
				Reg13 <= "00000000000000000000000000000000";
				Reg14 <= "00000000000000000000000000000000";
				Reg15 <= "00000000000000000000000000000000";
				Reg16 <= "00000000000000000000000000000000";
				Reg17 <= "00000000000000000000000000000000";
				Reg18 <= "00000000000000000000000000000000";
				Reg19 <= "00000000000000000000000000000000";
				Reg20 <= "00000000000000000000000000000000";
				Reg21 <= "00000000000000000000000000000000";
				Reg22 <= "00000000000000000000000000000000";
				Reg23 <= "00000000000000000000000000000000";
				Reg24 <= "00000000000000000000000000000000";
				Reg25 <= "00000000000000000000000000000000";
				Reg26 <= "00000000000000000000000000000000";
				Reg27 <= "00000000000000000000000000000000";
				Reg28 <= "00000000000000000000000000000000";
				Reg29 <= "00000000000000000000000000000000";
				Reg30 <= "00000000000000000000000000000000";
				Reg31 <= "00000000000000000000000000000000";
			
------------------------------------------ Início do processo relacionado ao clock 
			elsif (Clk = '1' and clk'event) then
				if(RegWrite = '1') then		
					case WriteReg is
						when "00000" =>	Reg0  <= WriteData;
						when "00001" =>	Reg1  <= WriteData;
						when "00010" =>	Reg2  <= WriteData;
						when "00011" =>	Reg3  <= WriteData;
						when "00100" =>	Reg4  <= WriteData;
						when "00101" =>	Reg5  <= WriteData;
						when "00110" =>	Reg6  <= WriteData;
						when "00111" =>	Reg7  <= WriteData;
						when "01000" =>	Reg8  <= WriteData;
						when "01001" =>	Reg9  <= WriteData;
						when "01010" =>	Reg10 <= WriteData;
						when "01011" =>	Reg11 <= WriteData;
						when "01100" =>	Reg12 <= WriteData;
						when "01101" =>	Reg13 <= WriteData;
						when "01110" =>	Reg14 <= WriteData;
						when "01111" =>	Reg15 <= WriteData;
						when "10000" =>	Reg16 <= WriteData;
						when "10001" =>	Reg17 <= WriteData;
						when "10010" =>	Reg18 <= WriteData;
						when "10011" =>	Reg19 <= WriteData;
						when "10100" =>	Reg20 <= WriteData;
						when "10101" =>	Reg21 <= WriteData;
						when "10110" =>	Reg22 <= WriteData;
						when "10111" =>	Reg23 <= WriteData;
						when "11000" =>	Reg24 <= WriteData;
						when "11001" =>	Reg25 <= WriteData;
						when "11010" =>	Reg26 <= WriteData;
						when "11011" =>	Reg27 <= WriteData;
						when "11100" =>	Reg28 <= WriteData;
						when "11101" =>	Reg29 <= WriteData;
						when "11110" =>	Reg30 <= WriteData;
						when "11111" =>	Reg31 <= WriteData;
					end case;
				end if;
			end if;
------------------------------------------ Fim do processo relacionado ao clock 
	end process;
------------------------------------------ Fim da Arquitetura 
END behavioral_arch;


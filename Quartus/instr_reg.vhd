--------------------------------------------------------------------------------
-- Title		: Registrador de Intru��es
-- Project		: CPU multi-ciclo
--------------------------------------------------------------------------------
-- File			: instr_reg.vhd
-- Author		: Marcus Vinicius Lima e Machado (mvlm@cin.ufpe.br)
--				  Paulo Roberto Santana Oliveira Filho (prsof@cin.ufpe.br)
--				  Viviane Cristina Oliveira Aureliano (vcoa@cin.ufpe.br)
-- Organization : Universidade Federal de Pernambuco
-- Created		: 29/07/2002
-- Last update	: 21/11/2002
-- Plataform	: Flex10K
-- Simulators	: Altera Max+plus II
-- Synthesizers	: 
-- Targets		: 
-- Dependency	: 
--------------------------------------------------------------------------------
-- Description	: Entidade que registra a instru��o a ser executada, modulando 
-- corretamente a sa�da de acordo com o layout padr�o das intru��es do Mips.
--------------------------------------------------------------------------------
-- Copyright (c) notice
--		Universidade Federal de Pernambuco (UFPE).
--		CIn - Centro de Informatica.
--		Developed by computer science undergraduate students.
--		This code may be used for educational and non-educational purposes as 
--		long as its copyright notice remains unchanged. 
--------------------------------------------------------------------------------
-- Revisions		: 
-- Revision Number	: 
-- Version			: 
-- Date				: 
-- Modifier			: 
-- Description		:
--------------------------------------------------------------------------------

-- Short name: ir
entity Instr_reg is
	port( 
		Clk			: in bit;	-- Clock do sistema
		Reset		: in bit;	-- Reset
		Load_ir		: in bit;	-- Bit para ativar carga do registrador de intru��es
		Entrada		: in bit_vector (31 downto 0);	-- Intru��o a ser carregada
		Instr31_26	: out bit_vector (5 downto 0);	-- Bits 31 a 26 da instru��o
		Instr25_21	: out bit_vector (4 downto 0);	-- Bits 25 a 21 da instru��o
		Instr20_16	: out bit_vector (4 downto 0);	-- Bits 20 a 16 da instru��o
		Instr15_0	: out bit_vector (15 downto 0)	-- Bits 15 a 0 da instru��o
	);
end Instr_reg;

-- Arquitetura que define o comportamento interno do Registrador de Intru��es
-- Simulation
architecture behavioral_arch of Instr_reg is

	 signal saida : bit_vector (31 downto 0); -- Sinal interno que guarda a intru��o a ser modulada

	begin
	
	-- Clocked process
	process (clk, reset)

		begin
			
			if(reset = '1') then
				saida  <= "00000000000000000000000000000000";
			elsif (clk = '1' and clk'event) then
				if (load_ir = '1')	then			
					saida (31 downto 0) <= entrada; -- Carrega instru��o
				end if;
			end if;
	
	end process;

	Instr31_26 <= saida (31 downto 26); -- Modula instru��o (31 a 26)  
	Instr25_21 <= saida (25 downto 21); -- Modula instru��o (25 a 21)  
	Instr20_16 <= saida (20 downto 16); -- Modula instru��o (20 a 16)  
	Instr15_0 <= saida (15 downto 0);	-- Modula instru��o (15 a 0)  

end behavioral_arch; 

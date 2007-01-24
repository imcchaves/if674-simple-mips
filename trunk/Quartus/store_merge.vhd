library IEEE;
use IEEE.std_logic_1164.all;

entity store_merge is
	port(
		storeType	:	in	std_logic_vector(1 downto 0);
		data		:	in	std_logic_vector(31 downto 0);
		merge_in	:	in	std_logic_vector(31 downto 0);
		saida		:	out	std_logic_vector(31 downto 0)
		);
end store_merge;

architecture ar of store_merge is	
begin
		
	process(storeType, data, merge_in)		
	begin
	
	if(storeType = "00") then
		saida <= data;
	elsif (storeType = "01") then
		saida(31 downto 16) <= merge_in(31 downto 16);
		saida(15 downto 0) <= data(15 downto 0);
	else
		saida(31 downto 8) <= merge_in(31 downto 8);
		saida(7 downto 0) <= data(7 downto 0);
	end if;	
	end process;
	
end ar;
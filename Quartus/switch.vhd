library IEEE;
use IEEE.std_logic_1164.all;
USE ieee.std_logic_arith.all;

entity switch is 
 Port (
         input0: in std_logic_vector (31 downto 0);
         input1: in bit;
         output: out std_logic_vector (31 downto 0);
         unsigned_instruction: in bit
      );
end switch;
architecture switch_2 of switch is
begin 
  process(unsigned_instruction, input0, input1)
   begin
     if( unsigned_instruction = '0') then
       output <= input0;
     else 
        if ( input1 = '1' )then
             output <= "00000000000000000000000000000001"; 
         else
             output <= "00000000000000000000000000000000";
        end if; 
     end if;      
  end process;
end switch_2;  

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
-- new pc mux

entity MuxPCSource is 
PORT (	
			PCSource :in std_logic_vector (1 downto 0); --select line from control unit
			ALUres:in std_logic_vector (31 downto 0);-- #0 in mux contains PC+4 cycle 1
			ALUOut:in std_logic_vector (31 downto 0);--#1 in mux for branc op- contains the new address -cycle 3
			jumpAdrs :in std_logic_vector (31 downto 0);--#2 in mux for jump op- contains the jump address- cycle 3
			pc_in : out std_logic_vector (31 downto 0)			
			);
END MuxPCSource ;
architecture flow of MuxPCSource is 
begin
pc_in <= ALUres when PCSource = "00"       
	   else ALUOut when PCSource = "01"
		else jumpAdrs when PCSource = "10";      
end flow;




 
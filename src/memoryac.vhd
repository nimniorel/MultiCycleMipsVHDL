library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
--instruction or data address to be read/write from mem
entity memoryac is port(
IorD :in std_logic; -- instruction or data mux selection bit
pc_out:in std_logic_vector (31 downto 0);-- mux in 0
ALUOut_in :in std_logic_vector (31 downto 0);-- mux in 1
address_in : out std_logic_vector (31 downto 0)-- the memory address to be used during write/read in memory
);
end memoryac;

architecture flow of memoryac is 
begin
address_in<= pc_out when IorD='0' else ALUOut_in ; -- instrucion/data address

end flow;

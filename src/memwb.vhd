library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
-- alu res or mdr to be written to bor
entity memwb is port(
MemtoReg :in std_logic; -- alu or mem to bor mux selection bit, 0 for R type and 1 for LW
MDR_out:in std_logic_vector (31 downto 0);-- mux in 1
ALUOut_in :in std_logic_vector (31 downto 0);-- mux in 0
write_data_out : out std_logic_vector (31 downto 0)-- the data to be used during write back to bor
);
end memwb;

architecture flow of memwb is 
begin
write_data_out<= ALUOut_in when MemtoReg='0' else MDR_out ; --alu out/mdr bor input mux

end flow;
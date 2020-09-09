library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity decode is port(
clk : in std_logic;
reset: in std_logic;
Reg_write: in std_logic;
Reg_dst: in std_logic;
IR_in:in std_logic_vector(31 downto 0);
write_data_in:in std_logic_vector(31 downto 0);-- the write back data to the bor, to be muxed by mem writeback unit
pc_out:in std_logic_vector(31 downto 0);-- used to calculate the jump address
Reg_A:out std_logic_vector(31 downto 0);
Reg_B:out std_logic_vector(31 downto 0);
opcode:out std_logic_vector(5 downto 0);
immediateSE:out std_logic_vector(31 downto 0);--immediate after sign extension to be muxed in ALUsrc (2) for SW and LW to calc mem address
immediateSE_shift:out std_logic_vector(31 downto 0);--immediate after sign extension and shift left 2 - for branch op to calc address
jumpAdrs:out std_logic_vector(31 downto 0)--jump address
);
end decode;

architecture flow of decode is 
type reg_file is array (natural range <>) of std_logic_vector(31 downto 0);
-- example of block of registres BOR t of decode unit)
signal bor : reg_file(0 to 31):=(
X"00000000",
X"00000001",
X"00000002", -- bor initial values
X"00000003",
X"00000004",
X"00000005",
X"00000006",
X"00000007",
X"00000008",
X"00000009",
X"0000000A",
X"0000000B",
X"0000000C",
X"0000000D",
X"0000000E",
X"0000000F",
X"00000010",
X"00000011",
X"00000012",
X"00000013",
X"00000014",
X"00000015",
X"00000016",
X"00000017",
X"00000018",
X"00000019",
X"0000001A",
X"0000001B",
X"0000001C",
X"0000001D",
X"0000001E",
X"0000001F"
 );

signal Reg_rs,Reg_rt,Reg_rd : std_logic_vector (4 downto 0); --read register 1 and 2 addresses
signal immediateSE_sig : std_logic_vector (31 downto 0);
signal Reg_Asig,Reg_Bsig: std_logic_vector (31 downto 0);
signal write_register:std_logic_vector (4 downto 0);-- register dest

begin

opcode<=IR_in(31 downto 26);-- opcode extraction
Reg_rs<=IR_in(25 downto 21);--read register 1
Reg_rt<=IR_in(20 downto 16);--read register 2
Reg_rd<=IR_in(15 downto 11);-- extract rd reg
immediateSE_sig<=X"0000" & IR_in(15 downto 0) when IR_in(15) = '0' --sign extend dependes on the highest bit
					else X"FFFF" & IR_in(15 downto 0);
immediateSE<=immediateSE_sig; -- to be muxed in ALUsrc (2) for SW and LW to calc mem address
immediateSE_shift<=immediateSE_sig(29 downto 0) &"00"; -- shift left 2
write_register <= IR_in(15 downto 11)when Reg_dst = '1' -- reg dest mux
						else IR_in(20 downto 16); 					
jumpAdrs<=pc_out(31 downto 28) & IR_in(25 downto 0) & "00";	  
process(clk,reset)
begin
if(reset='1') then
Reg_Asig<=(others => '0');
Reg_Bsig<=(others => '0');
elsif rising_edge(clk) then
Reg_Asig<=bor(conv_integer(Reg_rs));--reg a= bor(rs)
Reg_Bsig<=bor(conv_integer(Reg_rt));--reg b= bor(rt)
		if Reg_write = '1' then -- write back to bor -LW and R type write back
		bor(CONV_INTEGER(write_register)) <= write_data_in; -- bor[write refister]=data in, will be muxed by the write back unit
		end if;
end if;
end process;
Reg_A<=Reg_Asig;
Reg_B<=Reg_Bsig;
end flow;				  
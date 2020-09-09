library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity fetch is port(
clk : in std_logic;
reset: in std_logic;
pc_in: in std_logic_vector(31 downto 0);
address_in:in std_logic_vector(31 downto 0);
Reg_B:in std_logic_vector(31 downto 0);
pc_writecond: in std_logic;
pc_write: in std_logic;
zero:in std_logic;
Memread:in std_logic;
Memwrite:in std_logic; 
IR_write:in std_logic;
MDRout : out std_logic_vector (31 downto 0);
pc_out:out std_logic_vector(31 downto 0);
IR_out:out std_logic_vector(31 downto 0)
);
end fetch;
architecture flow of fetch is 
type reg_file is array (natural range <>) of std_logic_vector(31 downto 0);
-- mem unit array)
signal mem : reg_file(0 to 15) :=(
X"8c070014", -- lw $7, 0x14($0) bor(7)=mem(0+20/4=5) => write data = 0X1 st-4
X"AC0A0020", -- sw $10 0x20 r0  mem(0+32/4=8)=bor(10) => reg b= 0XA st-2 !
X"01074820", -- add $9, $8, $7 bor(9)=bor(8)+bor(7)=9 => write data = 0X9 st-7 
X"10000002", -- beq $0, $0, 2 (branch forward 2 words) if 0=0 pc=(pc+4)+(2*4) -pcin=0x18- st1
X"1000FFFC", -- beq $0, $0, -4 (branch back 4 words)
X"00000001", --------------------Data-----------------
X"08000009", --j 10		/jump to instruction 10 jumpadres=0x24=>36/4=9
X"00000003", --
X"00000004", 
X"00822022",  ---we jump to this address! sub $4, $4, $2	$4=4-2=2 write data=0x2 st-7
X"00632024", --and $4, $3, $3		$4 = X3 write data=0x3 st-7
X"020F8825", --or $ 17 $16 $15 $17= X1F
X"03BEF82A",-- slt $31 $29 $30 $31=X1 
X"00000000",
X"00000000",
X"00000000"
 );
signal pc_en : std_logic;
signal pc_outs:std_logic_vector(31 downto 0);-- signal of pc for instruction memmory
signal IR_outs:std_logic_vector(31 downto 0);
signal MDRout_sig:std_logic_vector(31 downto 0);
begin
pc_en<= (pc_write OR (pc_writecond AND zero)); -- pc wrie enable cond logic
process (clk,reset)
begin
if(reset='1') then
pc_outs<=(others=>'0');
IR_outs<=(others=>'0');
MDRout_sig<=(others=>'0');
elsif(rising_edge(clk)) then
	if (pc_en='1') then
	pc_outs<=pc_in;
	end if;
	if(Memread='1' AND IR_write='1') then -- load instruction
	IR_outs<=mem(conv_integer(address_in(5 downto 2))); --IR=mem[pc]
	end if;
	--- remove 2 lower bits becuase we work with words, mem depth of 16 to be represented with 4 bits
	if(Memread='1') then -- load word from mem
	MDRout_sig <= mem(conv_integer(address_in(5 downto 2))); --MDR=mem[aluout]
	end if;
	if(Memwrite='1') then -- store word to mem
	mem(conv_integer(address_in(5 downto 2)))<=Reg_B; -- mem[aluout]=reg b
	end if;	
end if;
end process;
	pc_out<=pc_outs;
	IR_out<=IR_outs;
	MDRout<=MDRout_sig;
	end flow;
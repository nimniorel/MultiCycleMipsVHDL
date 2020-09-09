library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
entity top is port(
clk : in std_logic;
reset: in std_logic;
pc_in_flag:out std_logic_vector(31 downto 0);
address_in_flag:out std_logic_vector(31 downto 0);
Reg_B_flag:out std_logic_vector(31 downto 0);
zero_flag:out std_logic; 
MDR_out_flag :out  std_logic_vector (31 downto 0);
pc_out_flag:out std_logic_vector(31 downto 0);
IR_flag:out std_logic_vector(31 downto 0);
---------------decode
write_data_flag:out std_logic_vector(31 downto 0);
Reg_A_flag:out std_logic_vector(31 downto 0);
opcode_flag:out std_logic_vector(5 downto 0);
immediateSE_flag:out std_logic_vector(31 downto 0);
immediateSE_shift_flag:out std_logic_vector(31 downto 0);
jumpAdrs_flag:out std_logic_vector(31 downto 0);
------------execute
ALUres_flag:out std_logic_vector(31 downto 0);
ALUOut_flag:out std_logic_vector(31 downto 0);
check_state_flag : out  std_logic_vector (3 downto 0)
--- control lines
--pc_writecond_flag: out std_logic;
--pc_write_flag: out std_logic;
--Memread_flag:out std_logic;
--Memwrite_flag:out std_logic; 
--IR_write_flag:out std_logic;
--Reg_write_flag: out std_logic;
--Reg_dst_flag: out std_logic;
--ALUOp_flag: out std_logic_vector(1 downto 0);
--ALU_srcB_flag: out std_logic_vector(1 downto 0);
--ALU_srcA_flag: out std_logic;
--IorD_flag :out std_logic;
--MemtoReg_flag :out std_logic;
--PCSource_flag:out   std_logic_vector (1 downto 0) -- top level mux
);
end top;

architecture flow of top is 
component fetch port(
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
  end component;
component decode port(
  clk : in std_logic;
  reset: in std_logic;
  Reg_write: in std_logic;
  Reg_dst: in std_logic;
  IR_in:in std_logic_vector(31 downto 0);
  write_data_in:in std_logic_vector(31 downto 0);
  pc_out:in std_logic_vector(31 downto 0);
  Reg_A:out std_logic_vector(31 downto 0);
  Reg_B:out std_logic_vector(31 downto 0);
  opcode:out std_logic_vector(5 downto 0);
  immediateSE:out std_logic_vector(31 downto 0);
  immediateSE_shift:out std_logic_vector(31 downto 0);
  jumpAdrs:out std_logic_vector(31 downto 0)
  );
  end component;
component execute port(
  clk : in std_logic;
  reset: in std_logic;
  ALUOp: in std_logic_vector(1 downto 0);
  ALU_srcB: in std_logic_vector(1 downto 0);
  ALU_srcA: in std_logic;
  IR_in:in std_logic_vector(31 downto 0);
  pc_out:in std_logic_vector(31 downto 0);
  Reg_A:in std_logic_vector(31 downto 0);
  Reg_B:in std_logic_vector(31 downto 0);
  immediateSE:in std_logic_vector(31 downto 0);
  immediateSE_shift:in std_logic_vector(31 downto 0);
  ALUres:out std_logic_vector(31 downto 0);
  zero : out std_logic;
  ALUOut:out std_logic_vector(31 downto 0)
  );
  end component;
component memoryac port(
  IorD :in std_logic;
  pc_out:in std_logic_vector (31 downto 0);
  ALUOut_in :in std_logic_vector (31 downto 0);
  address_in : out std_logic_vector (31 downto 0)
  );
  end component;
component memwb port(
  MemtoReg :in std_logic;
  MDR_out:in std_logic_vector (31 downto 0);
  ALUOut_in :in std_logic_vector (31 downto 0);
  write_data_out : out std_logic_vector (31 downto 0)
  );
  end component;
component controlunit port(
  clk :in std_logic;					
  reset :in std_logic;
  Op :in std_logic_vector(5 downto 0);
  RegDst 		: out  std_logic;
  MemToReg 	: out  std_logic;
  RegWrite 	: out  std_logic;
  MemRead		: out  std_logic;
  MemWrite 	: out  std_logic;
  PCWriteCond	: out  std_logic;
  PCWrite		: out  std_logic;
  IorD			: out  std_logic;
  IRWrite		: out  std_logic;
  ALUSrcA 		: out  std_logic;
  ALUop 		: out  std_logic_vector (1 downto 0);
  PCSource		: out  std_logic_vector (1 downto 0);
  ALUSrcB		: out  std_logic_vector (1 downto 0);
  check_state : out  std_logic_vector (3 downto 0)
  );
  end component;
component MuxPCSource port(
  PCSource :in std_logic_vector (1 downto 0);
  ALUres:in std_logic_vector (31 downto 0);
  ALUOut:in std_logic_vector (31 downto 0);
  jumpAdrs :in std_logic_vector (31 downto 0);
  pc_in : out std_logic_vector (31 downto 0)	
  );
  end component;

------signals
signal pc_in: std_logic_vector(31 downto 0);
signal address_in: std_logic_vector(31 downto 0);
signal Reg_B: std_logic_vector(31 downto 0);
signal pc_writecond:std_logic;
signal pc_write: std_logic;
signal zero: std_logic;
signal Memread: std_logic;
signal Memwrite: std_logic; 
signal IR_write: std_logic;
signal MDR_out :  std_logic_vector (31 downto 0);
signal pc_out: std_logic_vector(31 downto 0);
signal IR: std_logic_vector(31 downto 0);
---------------decode
signal Reg_write: std_logic;
signal Reg_dst: std_logic;
signal write_data: std_logic_vector(31 downto 0);
signal Reg_A: std_logic_vector(31 downto 0);
signal opcode: std_logic_vector(5 downto 0);
signal immediateSE: std_logic_vector(31 downto 0);
signal immediateSE_shift: std_logic_vector(31 downto 0);
signal jumpAdrs: std_logic_vector(31 downto 0);
------------execute
signal ALUOp:  std_logic_vector(1 downto 0);
signal ALU_srcB:  std_logic_vector(1 downto 0);
signal ALU_srcA:  std_logic;
signal ALUres: std_logic_vector(31 downto 0);
signal ALUOut: std_logic_vector(31 downto 0);
------------------mem access
signal IorD : std_logic;
------ write back
signal MemtoReg : std_logic;
signal PCSource		:   std_logic_vector (1 downto 0); -- top level mux
signal check_state :   std_logic_vector (3 downto 0);
begin
-----------------block connection
u1: fetch port map
(
	clk=>clk,
	reset=>reset,
	pc_in=>pc_in,
	address_in=>address_in,
	Reg_B=>Reg_B,
	pc_writecond=>pc_writecond,
	pc_write=>pc_write,
	zero=>zero,
	Memread=>Memread,
   Memwrite=>Memwrite,
	IR_write=>IR_write,
	MDRout=>MDR_out,
	pc_out=>pc_out,
	IR_out=>IR
);
u2: decode port map
(	clk=>clk,
	reset=>reset,--
	Reg_write=>Reg_write,
	Reg_dst=>Reg_dst,
	IR_in=>IR,
	write_data_in=>write_data,
	pc_out=>pc_out,
   Reg_A=>Reg_A,
	Reg_B=>Reg_B,
	opcode=>opcode,
	immediateSE=>immediateSE,
	immediateSE_shift=>immediateSE_shift,
	jumpAdrs=>jumpAdrs
);
u3: execute port map
(	clk=>clk,
	reset=>reset,
	ALUOp=>ALUOp,
	ALU_srcB	=>ALU_srcB,
	ALU_srcA	=>ALU_srcA,
	IR_in=>IR,
	pc_out=>pc_out,
	Reg_A=>Reg_A,
	Reg_B=>Reg_B,
	immediateSE=>immediateSE,
	immediateSE_shift=>immediateSE_shift,
	ALUres=>ALUres,
	zero=>zero,
	ALUOut=>ALUOut
);
u4: memoryac port map
(		IorD=>IorD,
		pc_out=>pc_out,
		ALUOut_in=>ALUOut,
		address_in=>address_in
);

u5: memwb port map
(	MemtoReg=>MemtoReg,
	MDR_out=>MDR_out,
	ALUOut_in=>ALUOut,
	write_data_out=>write_data
);
u6: controlunit port map
(			clk=>clk,
			reset=>reset,
			Op=>opcode,
			RegDst=>Reg_dst,
			MemToReg=>MemToReg,
			RegWrite=>Reg_write,
			MemRead=>MemRead,
			MemWrite=>MemWrite,
			PCWriteCond=>pc_writecond,
			PCWrite=>pc_write,
			IorD=>IorD,
			IRWrite=>IR_write,
			ALUSrcA=>ALU_srcA,
			ALUSrcB=>ALU_srcB,
			ALUOp=>ALUop,
			PCSource=>PCSource,
			check_state=>check_state
);			
u7:MuxPCSource port map
(
	PCSource=>PCSource,
	ALUres=>ALUres,
	ALUOut=>ALUOut,
	jumpAdrs=>jumpAdrs,
	pc_in=>pc_in
);
---------------------out port to be used in the test bench -----
pc_in_flag<=pc_in;
address_in_flag<=address_in;
Reg_B_flag<=Reg_B;
zero_flag <=zero;
MDR_out_flag <=MDR_out;
pc_out_flag<=pc_out;
IR_flag<=IR;
write_data_flag<=write_data;
Reg_A_flag<=Reg_A;
opcode_flag<=opcode;
immediateSE_flag<=immediateSE;
immediateSE_shift_flag<=immediateSE_shift;
jumpAdrs_flag<=jumpAdrs;
ALUres_flag<=ALUres;
ALUOut_flag<=ALUOut;
check_state_flag <=check_state;

--pc_writecond_flag<=pc_writecond;
--pc_write_flag<=pc_write;
--Memread_flag<=Memread;
--Memwrite_flag<=Memwrite; 
--IR_write_flag<=IR_write;
--Reg_write_flag<=Reg_write;
--Reg_dst_flag<=Reg_dst;
--ALUOp_flag<=ALUOp;
--ALU_srcB_flag<=ALU_srcB;
--ALU_srcA_flag<=ALU_srcA;
--IorD_flag <=IorD;
--MemtoReg_flag<=MemtoReg;
--PCSource_flag<=PCSource;


end flow;
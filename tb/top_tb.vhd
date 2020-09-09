library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity top_tb is
end;

architecture bench of top_tb is

  component top port(
  clk : in std_logic;
  reset: in std_logic;
  pc_in_flag:out std_logic_vector(31 downto 0);
  address_in_flag:out std_logic_vector(31 downto 0);
  Reg_B_flag:out std_logic_vector(31 downto 0);
  zero_flag:out std_logic; 
  MDR_out_flag :out  std_logic_vector (31 downto 0);
  pc_out_flag:out std_logic_vector(31 downto 0);
  IR_flag:out std_logic_vector(31 downto 0);
  write_data_flag:out std_logic_vector(31 downto 0);
  Reg_A_flag:out std_logic_vector(31 downto 0);
  opcode_flag:out std_logic_vector(5 downto 0);
  immediateSE_flag:out std_logic_vector(31 downto 0);
  immediateSE_shift_flag:out std_logic_vector(31 downto 0);
  jumpAdrs_flag:out std_logic_vector(31 downto 0);
  ALUres_flag:out std_logic_vector(31 downto 0);
  ALUOut_flag:out std_logic_vector(31 downto 0);
  check_state_flag : out  std_logic_vector (3 downto 0)
  
--  pc_writecond_flag: out std_logic;
--  pc_write_flag: out std_logic;
--  Memread_flag:out std_logic;
--  Memwrite_flag:out std_logic; 
--    IR_write_flag:out std_logic;
--    Reg_write_flag: out std_logic;
--    Reg_dst_flag: out std_logic;
--    ALUOp_flag: out std_logic_vector(1 downto 0);
--    ALU_srcB_flag: out std_logic_vector(1 downto 0);
--    ALU_srcA_flag: out std_logic;
--     IorD_flag :out std_logic;
--  	 MemtoReg_flag :out std_logic;
--  	 PCSource_flag		:out   std_logic_vector (1 downto 0)
  );
  end component;

  signal clk: std_logic;
  signal reset: std_logic;
  signal pc_in_flag: std_logic_vector(31 downto 0);
  signal address_in_flag: std_logic_vector(31 downto 0);
  signal Reg_B_flag: std_logic_vector(31 downto 0);
  signal zero_flag: std_logic;
  signal MDR_out_flag: std_logic_vector (31 downto 0);
  signal pc_out_flag: std_logic_vector(31 downto 0);
  signal IR_flag: std_logic_vector(31 downto 0);
  signal write_data_flag: std_logic_vector(31 downto 0);
  signal Reg_A_flag: std_logic_vector(31 downto 0);
  signal opcode_flag: std_logic_vector(5 downto 0);
  signal immediateSE_flag: std_logic_vector(31 downto 0);
  signal immediateSE_shift_flag: std_logic_vector(31 downto 0);
  signal jumpAdrs_flag: std_logic_vector(31 downto 0);
  signal ALUres_flag: std_logic_vector(31 downto 0);
  signal ALUOut_flag: std_logic_vector(31 downto 0);
  signal check_state_flag: std_logic_vector (3 downto 0);
  
--  
--  signal pc_writecond_flag: std_logic;
--  signal pc_write_flag: std_logic;
--  signal Memread_flag: std_logic;
--  signal Memwrite_flag: std_logic;
--  signal IR_write_flag: std_logic;
--  signal Reg_write_flag: std_logic;
--  signal Reg_dst_flag: std_logic;
--  signal ALUOp_flag: std_logic_vector(1 downto 0);
--  signal ALU_srcB_flag: std_logic_vector(1 downto 0);
--  signal ALU_srcA_flag: std_logic;
--  signal IorD_flag: std_logic;
--  signal MemtoReg_flag: std_logic;
--  signal PCSource_flag: std_logic_vector (1 downto 0) ;
	
	constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;
begin

  uut: top port map ( clk                    => clk,
                      reset                  => reset,
                      pc_in_flag             => pc_in_flag,
                      address_in_flag        => address_in_flag,
                      Reg_B_flag             => Reg_B_flag,
                      zero_flag              => zero_flag,
                      MDR_out_flag           => MDR_out_flag,
                      pc_out_flag            => pc_out_flag,
                      IR_flag                => IR_flag,
                      write_data_flag        => write_data_flag,
                      Reg_A_flag             => Reg_A_flag,
                      opcode_flag            => opcode_flag,
                      immediateSE_flag       => immediateSE_flag,
                      immediateSE_shift_flag => immediateSE_shift_flag,
                      jumpAdrs_flag          => jumpAdrs_flag,
                      ALUres_flag            => ALUres_flag,
                      ALUOut_flag            => ALUOut_flag,
                      check_state_flag       => check_state_flag
                      
							-- pc_writecond_flag      => pc_writecond_flag,
                     -- pc_write_flag          => pc_write_flag,
                     --Memread_flag           => Memread_flag,
--                      Memwrite_flag          => Memwrite_flag,
--                      IR_write_flag          => IR_write_flag,
--                      Reg_write_flag         => Reg_write_flag,
--                      Reg_dst_flag           => Reg_dst_flag,
--                      ALUOp_flag             => ALUOp_flag,
--                      ALU_srcB_flag          => ALU_srcB_flag,
--                      ALU_srcA_flag          => ALU_srcA_flag,
--                      IorD_flag              => IorD_flag,
--                      MemtoReg_flag          => MemtoReg_flag,
--                      PCSource_flag          => PCSource_flag 
);

  stimulus: process
  begin
  
    reset<='1';
	 wait for 5 ns;
	 reset<='0';
	 wait for 800 ns;
	 stop_the_clock <= true;
	 wait;


    -- Put test bench stimulus code here

    
  end process;
  clocking: process
  begin
    while not stop_the_clock loop
      CLK <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process clocking;


end;
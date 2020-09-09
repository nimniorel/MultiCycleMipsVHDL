library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity controlunit_tb is
end;

architecture bench of controlunit_tb is

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

  signal clk: std_logic;
  signal reset: std_logic;
  signal Op: std_logic_vector(5 downto 0):="000000";
  signal RegDst: std_logic;
  signal MemToReg: std_logic;
  signal RegWrite: std_logic;
  signal MemRead: std_logic;
  signal MemWrite: std_logic;
  signal PCWriteCond: std_logic;
  signal PCWrite: std_logic;
  signal IorD: std_logic;
  signal IRWrite: std_logic;
  signal ALUSrcA: std_logic;
  signal ALUop: std_logic_vector (1 downto 0);
  signal PCSource: std_logic_vector (1 downto 0);
  signal ALUSrcB: std_logic_vector (1 downto 0);
  signal check_state: std_logic_vector (3 downto 0) ;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: controlunit port map ( clk         => clk,
                              reset       => reset,
                              Op          => Op,
                              RegDst      => RegDst,
                              MemToReg    => MemToReg,
                              RegWrite    => RegWrite,
                              MemRead     => MemRead,
                              MemWrite    => MemWrite,
                              PCWriteCond => PCWriteCond,
                              PCWrite     => PCWrite,
                              IorD        => IorD,
                              IRWrite     => IRWrite,
                              ALUSrcA     => ALUSrcA,
                              ALUop       => ALUop,
                              PCSource    => PCSource,
                              ALUSrcB     => ALUSrcB,
                              check_state => check_state );

  stimulus: process
  begin
  
    -- Put initialisation code here
		reset<='1';
		wait for 5 ns;
		reset<='0';
		wait for 10 ns;
		Op<="000100";-- beq op code
		wait for 30 ns;-- beq takes 3 cycles
		op<="000010"; -- jump op code
		wait for 30 ns;-- jump takes 3 cycles
		op<="000000"; -- r type op code
		wait for 40 ns;-- r type takes 4 cycles
		op<="101011"; -- store word op code
		wait for 40 ns;-- store word takes 4 cycles
		op<="100011"; -- load word op code
		wait for 50 ns;-- load word takes 4 cycles
    -- Put test bench stimulus code here
	
    stop_the_clock <= true;
    wait;
  end process;

  clocking: process
  begin
    while not stop_the_clock loop
      clk <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;

end;
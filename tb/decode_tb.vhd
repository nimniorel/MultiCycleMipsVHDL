library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity decode_tb is
end;

architecture bench of decode_tb is

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

  signal clk: std_logic;
  signal reset: std_logic;
  signal Reg_write: std_logic:='0';
  signal Reg_dst: std_logic:='0';               --op   --rs  --rt  --rd  --shmt --fnc  
  signal IR_in: std_logic_vector(31 downto 0):="00000000011001010001100000100000";
  signal write_data_in: std_logic_vector(31 downto 0):=X"00000000";
  signal pc_out: std_logic_vector(31 downto 0):=X"30000000";
  signal Reg_A: std_logic_vector(31 downto 0);
  signal Reg_B: std_logic_vector(31 downto 0);
  signal opcode: std_logic_vector(5 downto 0);
  signal immediateSE: std_logic_vector(31 downto 0);
  signal immediateSE_shift: std_logic_vector(31 downto 0);
  signal jumpAdrs: std_logic_vector(31 downto 0) ;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: decode port map ( clk               => clk,
                         reset             => reset,
                         Reg_write         => Reg_write,
                         Reg_dst           => Reg_dst,
                         IR_in             => IR_in,
                         write_data_in     => write_data_in,
                         pc_out            => pc_out,
                         Reg_A             => Reg_A,
                         Reg_B             => Reg_B,
                         opcode            => opcode,
                         immediateSE       => immediateSE,
                         immediateSE_shift => immediateSE_shift,
                         jumpAdrs          => jumpAdrs );

  stimulus: process
  begin
		reset<='1';
		wait for 5 ns;
		reset <= '0';
		--first operation
		--regA =bor(rs=3)=X00000003
		--regB = bor(rt=5)=X00000005
		--op=00000
		--immediateSE=X"00001820"
		--immediateSshift=X"00006080"
		--jumpaddress=X"31946080"
		wait for 10 ns;
		write_data_in<=X"00008800";
		Reg_write<='1';
		--bor(rt=5)=write_data_in=X"00008800"
		wait for 10 ns;
		Reg_write<='0';
		-- regB=bor(rt=5)=X"00008800"
		wait for 10 ns;
    -- Put initialisation code here


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
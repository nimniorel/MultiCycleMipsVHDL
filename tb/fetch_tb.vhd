library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity fetch_tb is
end;

architecture bench of fetch_tb is

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

  signal clk: std_logic;
  signal reset: std_logic;
  signal pc_in: std_logic_vector(31 downto 0):=X"00000008";
  signal address_in: std_logic_vector(31 downto 0):=X"00000000";
  signal Reg_B: std_logic_vector(31 downto 0):=X"00005555";
  signal pc_writecond: std_logic:='0';
  signal pc_write: std_logic:='0';
  signal zero: std_logic:='0';
  signal Memread: std_logic:='0';
  signal Memwrite: std_logic:='0';
  signal IR_write: std_logic:='0';
  signal MDRout: std_logic_vector (31 downto 0);
  signal pc_out: std_logic_vector(31 downto 0);
  signal IR_out: std_logic_vector(31 downto 0) ;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: fetch port map ( clk          => clk,
                        reset        => reset,
                        pc_in        => pc_in,
                        address_in   => address_in,
                        Reg_B        => Reg_B,
                        pc_writecond => pc_writecond,
                        pc_write     => pc_write,
                        zero         => zero,
                        Memread      => Memread,
                        Memwrite     => Memwrite,
                        IR_write     => IR_write,
                        MDRout       => MDRout,
                        pc_out       => pc_out,
                        IR_out       => IR_out );

  stimulus: process
  begin
  
    -- Put initialisation code here
		reset<='1';
		wait for 5 ns;
		reset<='0';
		wait for 10 ns;-- PCout=old pc =X00000000
		pc_write<='1';
		wait for 10 ns;-- PCout=PCin new pc=X"00000008"
		pc_write<='0';-- stop new pc 
		Memread<='1';
		IR_write<='1'; -- read instruction from mem, address_in will give the first mem alement
							--IR=mem[0]=X"8c070004"
		wait for 10 ns;
		address_in<="00000000000000000000000000101000";-- will give element 10 in mem
		IR_write<='0'; -- read data from mem
		--MDR=mem[10]=X"0000000A"
		wait for 10 ns;
		Memread<='0';
		Memwrite<='1';--write data to the mem
		--mem[10]=regB=X"00005555" --store
		wait for 10 ns;
		Memread<='1';--enable read
		Memwrite<='0';--disable write data to the mem
		--MDR=mem[10]=X"00005555"
		wait for 10 ns;

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
  
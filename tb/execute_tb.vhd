library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity execute_tb is
end;

architecture bench of execute_tb is

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

  signal clk: std_logic;
  signal reset: std_logic;
  signal ALUOp: std_logic_vector(1 downto 0):="00";
  signal ALU_srcB: std_logic_vector(1 downto 0):="00";
  signal ALU_srcA: std_logic:='0'; --src A selec bit
  signal IR_in: std_logic_vector(31 downto 0):=X"00000000";
  signal pc_out: std_logic_vector(31 downto 0):=X"000000AA";-- srcA 0
  signal Reg_A: std_logic_vector(31 downto 0):=X"000000BB";-- srcA 1
  signal Reg_B: std_logic_vector(31 downto 0):=X"000000CC";-- srcB 0
  signal immediateSE: std_logic_vector(31 downto 0):=X"000000DD";--srcB 2
  signal immediateSE_shift: std_logic_vector(31 downto 0):=X"0000DD00";
  signal ALUres: std_logic_vector(31 downto 0);
  signal zero: std_logic;
  signal ALUOut: std_logic_vector(31 downto 0);

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: execute port map ( clk               => clk,
                          reset             => reset,
                          ALUOp             => ALUOp,
                          ALU_srcB          => ALU_srcB,
                          ALU_srcA          => ALU_srcA,
                          IR_in             => IR_in,
                          pc_out            => pc_out,
                          Reg_A             => Reg_A,
                          Reg_B             => Reg_B,
                          immediateSE       => immediateSE,
                          immediateSE_shift => immediateSE_shift,
                          ALUres            => ALUres,
                          zero              => zero,
                          ALUOut            => ALUOut );

  stimulus: process
  begin
  
    -- check the input mux
	 -- current operation in alu is add 
		-- fist op is alu=pc_out+regB= X176
		wait for 5 ns;
       ALU_srcB <= "01"; -- alu=pc_out+4=XAE
		 wait for 10 ns;
		 ALU_srcB <= "10"; -- alu=immidiateSE+pc_out=X187
		 wait for 10 ns;
		 ALU_srcB <= "11"; -- alu=immidiateSESL+pc_out=XDDAA
		 wait for 10 ns;
		 ALU_srcA <= '1'; -- alu=regA+immidiateSESL=XDDBB
		 wait for 10 ns;
		  ALU_srcB <= "10"; --alu=regA+ immidiateSE=X198
		 wait for 10 ns;
		 ALU_srcB <= "01"; --alu=regA+4=XBF
		 wait for 10 ns;
		 ALU_srcB <= "00"; --alu=regA+regB=X187
		 
		 wait for 10 ns; -- setting the muxes steady and changing the alu operation
		 ALUOp<="10"; --
		 IR_in<=X"00000002";--geting the control of the alu to perform sub operation
		 --alu=regA-regB=Xffffffef
		 wait for 10 ns;
		 IR_in<=X"00000004";--geting the control of the alu to perform AND operation
		 --alu=regA AND regB=X88
		 wait for 10 ns;
		 IR_in<=X"0000000C";--geting the control of the alu to perform OR operation
		 --alu=regA OR regB=Xff
		 wait for 10 ns;
		 IR_in<=X"0000000B";--geting the control of the alu to perform SLT operation
		 -- alu=X1 becuse a<b
		 wait for 10 ns;
		 Reg_B<=X"000000BB";
		 wait for 10 ns;
			-- zero=1

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

end architecture bench;
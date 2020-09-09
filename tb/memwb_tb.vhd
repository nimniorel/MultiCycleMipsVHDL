library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity memwb_tb is
end;

architecture bench of memwb_tb is

  component memwb port(
  MemtoReg :in std_logic;
  MDR_out:in std_logic_vector (31 downto 0);
  ALUOut_in :in std_logic_vector (31 downto 0);
  write_data_out : out std_logic_vector (31 downto 0)
  );
  end component;

  signal MemtoReg: std_logic:='0';
  signal MDR_out: std_logic_vector (31 downto 0):=X"00000000";
  signal ALUOut_in: std_logic_vector (31 downto 0):=X"00000000";
  signal write_data_out: std_logic_vector (31 downto 0) ;

begin

  uut: memwb port map ( MemtoReg       => MemtoReg, --select bit
                        MDR_out        => MDR_out, -- mux in 1
                        ALUOut_in      => ALUOut_in, --mux in 0
                        write_data_out => write_data_out ); -- mux out

  stimulus: process
  begin
  
    -- Put initialisation code here
	wait for 10 ns;
       MDR_out <= X"00000011";
       wait for 10 ns;
       MemtoReg <= '1';
       wait for 10 ns;
       MemtoReg <= '0';     -- added
       wait for 10 ns; -- added
       ALUOut_in <= X"00000022";
       wait for 10 ns; -- added
       wait;
  -- Put test bench stimulus code here

  end process stimulus;


end architecture bench;
library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity memoryac_tb is
end;

architecture bench of memoryac_tb is

  component memoryac port(
  IorD :in std_logic;
  pc_out:in std_logic_vector (31 downto 0);
  ALUOut_in :in std_logic_vector (31 downto 0);
  address_in : out std_logic_vector (31 downto 0)
  );
  end component;

  signal IorD: std_logic:='0';
  signal pc_out: std_logic_vector (31 downto 0):=X"00000000";
  signal ALUOut_in: std_logic_vector (31 downto 0):=X"00000000";
  signal address_in: std_logic_vector (31 downto 0) :=X"00000000";

begin

  uut: memoryac port map ( IorD       => IorD,--select bit
                           pc_out     => pc_out,-- mux in 0
                           ALUOut_in  => ALUOut_in,--mux in 1
                           address_in => address_in );-- mux out

  stimulus: process
  begin
  
   wait for 10 ns;
       pc_out <= X"00000A11";
       wait for 20 ns;
       IorD <= '1';     -- added
       wait for 10 ns; -- added
       ALUOut_in <= X"0000CC22";
       wait for 20 ns; -- added
       wait;

  end process stimulus;


end architecture bench;
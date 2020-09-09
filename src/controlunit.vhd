library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity controlunit is port(
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
check_state : out  std_logic_vector (3 downto 0) -- state number for the testbench
);
end controlunit;

architecture flow of controlunit is 
-- state var
type state is (instruction_fetch, instruction_decode, memory_adrs_comp, execution, branch_complete --FSM
, jump_complete, memory_ac_lw, memory_ac_sw,r_type_complete,mem_read_complete);
signal CS, NS : state;
begin
--- two process mealy FSM
process (clk,reset)
begin
if(reset='1') then 
CS<=instruction_fetch;
elsif (rising_edge(clk)) then
CS<=NS;
end if;
end process;
process (CS,Op)
begin
case CS is
	when instruction_fetch=> -- state 0
	  PCWrite <= '1';
	  PCWriteCond <= '0';
	  IorD <= '0';
	  MemRead <= '1';
	  MemWrite <= '0';
	  IRWrite <= '1';
	  MemtoReg <='0';
	  PCSource <="00";
	  ALUOp <="00";
	  ALUSrcB <= "01";
	  ALUSrcA <='0';
	  RegWrite <='0';
	  RegDst <= '0';
	  check_state<=X"0";
		NS<=instruction_decode;
	when instruction_decode=> -- state 1
		PCWrite <= '0';
      PCWriteCond <= '0';
      IorD <= '0';
      MemRead <= '0';
      MemWrite <= '0';
      IRWrite <= '0';
      MemtoReg <='0';
	   PCSource <="00";
      ALUOp <="00";
      ALUSrcB <= "11";
      ALUSrcA <='0';
      RegWrite <='0';
      RegDst <= '0';
		check_state<=X"1";
		case Op is 
		when "100011"=> --lw
		NS<=memory_adrs_comp;
		when "101011"=> --sw
		NS<=memory_adrs_comp;
		when "000000"=>-- r type
		NS<=execution;
		when "000100"=>-- branch
		NS<=branch_complete;
		when "000010"=>-- jump
		NS<=jump_complete;
		when others=> NS<=instruction_fetch;	
		end case;
	when memory_adrs_comp=> -- state 2
		PCWrite <= '0';
      PCWriteCond <= '0';
      IorD <= '0';
      MemRead <= '0';
      MemWrite <= '0';
		IRWrite <= '0';
      MemtoReg <='0';
      PCSource <="00";
      ALUOp <="00";
      ALUSrcB <= "10";
      ALUSrcA <='1';
      RegWrite <='0';
      RegDst <= '0';
		check_state<=X"2";
		case Op is 
		when "100011"=> --lw
		NS<=memory_ac_lw;
		when "101011"=> --sw
		NS<=memory_ac_sw;
		when others=> NS<=instruction_fetch;
		end case;
	when execution=> -- state 6
		PCWrite <= '0';
      PCWriteCond <= '0';
      IorD <= '0';
      MemRead <= '0';
      MemWrite <= '0';
      IRWrite <= '0';
      MemtoReg <='0';
      PCSource <="00";
      ALUOp <="10";
      ALUSrcB <= "00";
      ALUSrcA <='1';
      RegWrite <='0';
      RegDst <= '0';
		check_state<=X"6";
		NS<=r_type_complete;
	when branch_complete=> -- state 8
		PCWrite <= '0';
      PCWriteCond <= '1';
      IorD <= '0';
      MemRead <= '0';
      MemWrite <= '0';
      IRWrite <= '0';
      MemtoReg <='0';
      PCSource <="01";
      ALUOp <="01";
      ALUSrcB <= "00";
      ALUSrcA <='1';
      RegWrite <='0';
      RegDst <= '0';
		check_state<=X"8";
		NS<=instruction_fetch;
	when jump_complete=>-- state 9
		PCWrite <= '1';
      PCWriteCond <= '0';
      IorD <= '0';
      MemRead <= '0';
      MemWrite <= '0';
      IRWrite <= '0';
      MemtoReg <='0';
      PCSource <="10";
      ALUOp <="00";
      ALUSrcB <= "00";
      ALUSrcA <='0';
      RegWrite <='0';
		RegDst <= '0';
		check_state<=X"9";
		NS<=instruction_fetch;
	when memory_ac_lw=>-- state 3
		PCWrite <= '0';
      PCWriteCond <= '0';
      IorD <= '1';
      MemRead <= '1';
      MemWrite <= '0';
      IRWrite <= '0';
      MemtoReg <='0';
      PCSource <="00";
      ALUOp <="00";
      ALUSrcB <= "00";
      ALUSrcA <='0';
      RegWrite <='0';
      RegDst <= '0';
		check_state<=X"3";
		NS<=mem_read_complete;
	when memory_ac_sw=> --state 5
		PCWrite <= '0';
      PCWriteCond <= '0';
      IorD <= '1';
      MemRead <= '0';
      MemWrite <= '1';
      IRWrite <= '0';
      MemtoReg <='0';
      PCSource <="00";
      ALUOp <="00";
      ALUSrcB <= "00";
      ALUSrcA <='0';
      RegWrite <='0';
      RegDst <= '0';
		check_state<=X"5";
		NS<=instruction_fetch;
		when r_type_complete=> -- state 7
		PCWrite <= '0';
      PCWriteCond <= '0';
      IorD <= '0';
      MemRead <= '0';
      MemWrite <= '0';
      IRWrite <= '0';
      MemtoReg <='0';
      PCSource <="00";
      ALUOp <="00";
      ALUSrcB <= "00";
      ALUSrcA <='0';
      RegWrite <='1';
      RegDst <= '1';
		check_state<=X"7";
		NS<=instruction_fetch;
		when mem_read_complete=> -- lw write back state 4
		PCWrite <= '0';
      PCWriteCond <= '0';
      IorD <= '0';
      MemRead <= '0';
      MemWrite <= '0';
      IRWrite <= '0';
      MemtoReg <='1';
      PCSource <="00";
      ALUOp <="00";
      ALUSrcB <= "00";
      ALUSrcA <='0';
      RegWrite <='1';
      RegDst <= '0';
		check_state<=X"4";
		NS<=instruction_fetch;
	when others=> NS<=instruction_fetch;	
	end case;

end process;

end flow;
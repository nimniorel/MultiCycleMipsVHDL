library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity execute is port(
clk : in std_logic;
reset: in std_logic;
ALUOp: in std_logic_vector(1 downto 0);-- contorol line from control unit for alu control 
ALU_srcB: in std_logic_vector(1 downto 0);-- control line from control unit for ALUsrcB mux
ALU_srcA: in std_logic;-- control line from control unit for ALUsrcA mux
IR_in:in std_logic_vector(31 downto 0);-- to be used for ALU control
pc_out:in std_logic_vector(31 downto 0);-- current pc #0 in ALUsrcA mux
Reg_A:in std_logic_vector(31 downto 0);-- # 1 in ALUsrcA mux
Reg_B:in std_logic_vector(31 downto 0);--# 0 in ALUsrcB mux
immediateSE:in std_logic_vector(31 downto 0);--immediate after sign extension # 2 in ALUsrcB mux
immediateSE_shift:in std_logic_vector(31 downto 0);--immediate after sign extension and shift left 2 # 3 in ALUsrcB mux
ALUres:out std_logic_vector(31 downto 0); -- alu res to be used in pc in mux
zero : out std_logic; -- indicates if the alu res is zero, to be used in pc en for branches
ALUOut:out std_logic_vector(31 downto 0)-- Alu res reg to be used for mem write back or bor write back
);
end execute;

architecture flow of execute is 
signal ALUout_sig :std_logic_vector(31 downto 0);
signal ALUres_sig :std_logic_vector(31 downto 0);
signal ALUin1_sig :std_logic_vector(31 downto 0);
signal ALUin2_sig :std_logic_vector(31 downto 0);
signal ALUcntl_sig :std_logic_vector(2 downto 0);
begin
ALUin1_sig <= Reg_A when ALU_srcA = '1' --alusrcA in  mux
							else pc_out ;
       
ALUin2_sig <= Reg_B when ALU_srcB = "00" -- alusrcB in 2 mux
		   else X"00000004" when ALU_srcB = "01" -- pc +4 op
			else immediateSE when ALU_srcB = "10"
			else immediateSE_shift when ALU_srcB = "11";
	-- alu control unit		
ALUcntl_sig(0) <= (IR_in(0) OR IR_in(3)) AND ALUOp(1); 
ALUcntl_sig(1) <= (NOT IR_in(2)) OR (NOT ALUOp(1)); 
ALUcntl_sig(2) <= (IR_in(1) AND ALUOp(1)) OR ALUOp(0);
zero <= '1' when (ALUres_sig= X"00000000") 
            else '0';
process (ALUcntl_sig,ALUin1_sig,ALUin2_sig) 
begin 
  case ALUcntl_sig is 
   when "010"  => ALUres_sig  <= ALUin1_sig + ALUin2_sig; -- add/addi instruction
	when "110"  => ALUres_sig  <= ALUin1_sig+(NOT(ALUin2_sig)+1); -- sub/subi instruction
   when "000"  => ALUres_sig  <= (ALUin1_sig AND ALUin2_sig);  -- and instruction
	when "001"  => ALUres_sig  <= ALUin1_sig OR ALUin2_sig; --or instruction
   when "111"  => if (ALUin1_sig < ALUin2_sig) then ALUres_sig <=x"00000001"; -- slt instruction if in1<in2 => out=00000001
					  else ALUres_sig <=x"00000000";
					  end if;
  when others => ALUres_sig  <= X"00000000";
  end case; 
end process;
process(clk,reset) -- implement the alu_out reg
begin
if(reset='1') then
ALUout_sig <=x"00000000";
elsif rising_edge(clk) then
ALUout_sig<=ALUres_sig;
end if;
end process;
ALUOut<=ALUout_sig;
ALUres<=ALUres_sig;


end flow;	
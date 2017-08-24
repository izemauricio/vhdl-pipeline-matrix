-- Mauricio Ize @ 2016
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity MATRIZ is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
			  result : out STD_LOGIC_VECTOR(9 DOWNTO 0);
           done : out  STD_LOGIC);
end MATRIZ;

architecture Behavioral of MATRIZ is

	-- PIPELINE HARDWARE
	COMPONENT MUL4
	  PORT (
		 -- clk : IN STD_LOGIC;
		 a : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 b : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 p : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	  );
	END COMPONENT;

	COMPONENT SUM8
	  PORT (
		 a : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 b : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 s : OUT STD_LOGIC_VECTOR(8 DOWNTO 0)
	  );
	END COMPONENT;

	COMPONENT SUM9
	  PORT (
		 a : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
		 b : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
		 s : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
	  );
	END COMPONENT;
	
	-- MATRIZ A
	-- linha 0
	SIGNAL A00 : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0001"; -- 1
	SIGNAL A01 : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0010"; -- 2
	SIGNAL A02 : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0011"; -- 3
	SIGNAL A03 : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0100"; -- 4
	
	-- linha 1
	SIGNAL A10 : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0101"; -- 5
	SIGNAL A11 : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0110"; -- 6
	SIGNAL A12 : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0111"; -- 7
	SIGNAL A13 : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1000"; -- 8
	
	-- linha 2
	SIGNAL A20 : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1001"; -- 9
	SIGNAL A21 : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1010"; -- 10
	SIGNAL A22 : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1011"; -- 11
	SIGNAL A23 : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1100"; -- 12
	
	-- linha 3
	SIGNAL A30 : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1101"; -- 13
	SIGNAL A31 : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1110"; -- 14
	SIGNAL A32 : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1111"; -- 15
	SIGNAL A33 : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000"; -- 00
	
	-- MATRIZ B
	-- linha 0
	SIGNAL B00 : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0001"; -- 1
	SIGNAL B01 : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0010"; -- 2
	SIGNAL B02 : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0011"; -- 3
	SIGNAL B03 : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0100"; -- 4
	
	-- linha 1
	SIGNAL B10 : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0101"; -- 5
	SIGNAL B11 : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0110"; -- 6
	SIGNAL B12 : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0111"; -- 7
	SIGNAL B13 : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1000"; -- 8
	
	-- linha 2
	SIGNAL B20 : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1001"; -- 9
	SIGNAL B21 : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1010"; -- 10
	SIGNAL B22 : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1011"; -- 11
	SIGNAL B23 : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1100"; -- 12
	
	-- linha 3
	SIGNAL B30 : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1101"; -- 13
	SIGNAL B31 : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1110"; -- 14
	SIGNAL B32 : STD_LOGIC_VECTOR(3 DOWNTO 0) := "1111"; -- 15
	SIGNAL B33 : STD_LOGIC_VECTOR(3 DOWNTO 0) := "0000"; -- 00
	
	-- MUX'S
	SIGNAL MUX0 : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL MUX1 : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL MUX2 : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL MUX3 : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL MUX4 : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL MUX5 : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL MUX6 : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL MUX7 : STD_LOGIC_VECTOR(3 DOWNTO 0);
	
	SIGNAL SEL_MUX0 : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
	SIGNAL SEL_MUX1 : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
	SIGNAL SEL_MUX2 : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
	SIGNAL SEL_MUX3 : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
	SIGNAL SEL_MUX4 : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
	SIGNAL SEL_MUX5 : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
	SIGNAL SEL_MUX6 : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
	SIGNAL SEL_MUX7 : STD_LOGIC_VECTOR(1 DOWNTO 0) := "00";
	
	-- PIPELINE STAGE-1 REGISTERS
	SIGNAL MUL0_RESULT : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL MUL1_RESULT : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL MUL2_RESULT : STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL MUL3_RESULT : STD_LOGIC_VECTOR(7 DOWNTO 0);
	
	SIGNAL REG0_STAGE1 : STD_LOGIC_VECTOR(7 DOWNTO 0) := "00000000";
	SIGNAL REG1_STAGE1 : STD_LOGIC_VECTOR(7 DOWNTO 0) := "00000000";
	SIGNAL REG2_STAGE1 : STD_LOGIC_VECTOR(7 DOWNTO 0) := "00000000";
	SIGNAL REG3_STAGE1 : STD_LOGIC_VECTOR(7 DOWNTO 0) := "00000000";
	
	SIGNAL LOAD_STAGE1 : STD_LOGIC;
	
	-- PIPELINE STAGE-2 REGISTERS
	SIGNAL SUM0_RESULT : STD_LOGIC_VECTOR(8 DOWNTO 0);
	SIGNAL SUM1_RESULT : STD_LOGIC_VECTOR(8 DOWNTO 0);
	
	SIGNAL REG0_STAGE2 : STD_LOGIC_VECTOR(8 DOWNTO 0) := "000000000";
	SIGNAL REG1_STAGE2 : STD_LOGIC_VECTOR(8 DOWNTO 0) := "000000000";
	
	SIGNAL LOAD_STAGE2 : STD_LOGIC;
	
	-- PIPELINE STAGE-3 REGISTERS
	SIGNAL SUMR_RESULT : STD_LOGIC_VECTOR(9 DOWNTO 0);
	
	SIGNAL REGR_STAGE3 : STD_LOGIC_VECTOR(9 DOWNTO 0) := "0000000000";
	
	SIGNAL LOAD_STAGE3 : STD_LOGIC;
	
	-- STATE MACHINE
	type FSM_STATES is (S0, S1, s2, s3, s4 ,s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20);
	signal FSM_ATUAL, FSM_NEXT: FSM_STATES;

begin

	-- para resetar os valores
	process(clk, rst)
	begin
		if (clk'event and clk = '1') then
			if (rst = '1') then
				A00 <= "0001"; -- 1
				A01 <= "0010"; -- 2
				A02 <= "0011"; -- 3
				A03 <= "0100"; -- 4
				A10 <= "0101"; -- 5
				A11 <= "0110"; -- 6
				A12 <= "0111"; -- 7
				A13 <= "1000"; -- 8
				A20 <= "1001"; -- 9
				A21 <= "1010"; -- 10
				A22 <= "1011"; -- 11
				A23 <= "1100"; -- 12
				A30 <= "1101"; -- 13
				A31 <= "1110"; -- 14
				A32 <= "1111"; -- 15
				A33 <= "0000"; -- 00
				
				B00 <= "1111"; -- 1
				B01 <= "1110"; -- 2
				B02 <= "1101"; -- 3
				B03 <= "1100"; -- 4
				
				B10 <= "1011"; -- 5
				B11 <= "1010"; -- 6
				B12 <= "1001"; -- 7
				B13 <= "1000"; -- 8
				
				B20 <= "0111"; -- 9
				B21 <= "0110"; -- 10
				B22 <= "0101"; -- 11
				B23 <= "0100"; -- 12
				
				B30 <= "0011"; -- 13
				B31 <= "0010"; -- 14
				B32 <= "0001"; -- 15
				B33 <= "0000"; -- 00
			end if;
		end if;
	end process;

	MUL0_HW : MUL4
	PORT MAP (
	-- clk => clk,
	a => MUX0,
	b => MUX1,
	p => MUL0_RESULT
	);

	MUL1_HW : MUL4
	PORT MAP (
	-- clk => clk,
	a => MUX2,
	b => MUX3,
	p => MUL1_RESULT
	);

	MUL2_HW : MUL4
	PORT MAP (
	-- clk => clk,
	a => MUX4,
	b => MUX5,
	p => MUL2_RESULT
	);

	MUL3_HW : MUL4
	PORT MAP (
	-- clk => clk,
	a => MUX6,
	b => MUX7,
	p => MUL3_RESULT
	);

	SUM0_HW : SUM8
	PORT MAP (
	a => REG0_STAGE1,
	b => REG1_STAGE1,
	s => SUM0_RESULT
	);

	SUM1_HW : SUM8
	PORT MAP (
	a => REG2_STAGE1,
	b => REG3_STAGE1,
	s => SUM1_RESULT
	);

	SUMR_HW : SUM9
	PORT MAP (
	a => REG0_STAGE2,
	b => REG1_STAGE2,
	s => SUMR_RESULT
	);
	  
	-- MUX0
	process(SEL_MUX0, A00, A01, A02, A03)
	begin
		if (SEL_MUX0 = "00") then
			MUX0 <= A00;	
		elsif (SEL_MUX0 = "01") then
			MUX0 <= A10;	
		elsif (SEL_MUX0 = "10") then
			MUX0 <= A20;	
		elsif (SEL_MUX0 = "11") then
			MUX0 <= A30;
		end if;
	end process;
	
	-- MUX1
	process(SEL_MUX1, B00, B01, B02, B03)
	begin
		if (SEL_MUX1 = "00") then
			MUX1 <= B00;	
		elsif (SEL_MUX1 = "01") then
			MUX1 <= B01;	
		elsif (SEL_MUX1 = "10") then
			MUX1 <= B02;	
		elsif (SEL_MUX1 = "11") then
			MUX1 <= B03;
		end if;
	end process;
	
	-- MUX2
	process(SEL_MUX2, A01, A11, A21, A31)
	begin
		if (SEL_MUX2 = "00") then
			MUX2 <= A01;	
		elsif (SEL_MUX2 = "01") then
			MUX2 <= A11;	
		elsif (SEL_MUX2 = "10") then
			MUX2 <= A21;	
		elsif (SEL_MUX2 = "11") then
			MUX2 <= A31;
		end if;
	end process;
	
	-- MUX3
	process(SEL_MUX3, B10, B11, B12, B13)
	begin
		if (SEL_MUX3 = "00") then
			MUX3 <= B10;	
		elsif (SEL_MUX3 = "01") then
			MUX3 <= B11;	
		elsif (SEL_MUX3 = "10") then
			MUX3 <= B12;	
		elsif (SEL_MUX3 = "11") then
			MUX3 <= B13;
		end if;
	end process;
	
	-- MUX4
	process(SEL_MUX4, A02, A12, A22, A32)
	begin
		if (SEL_MUX4 = "00") then
			MUX4 <= A02;	
		elsif (SEL_MUX4 = "01") then
			MUX4 <= A12;	
		elsif (SEL_MUX4 = "10") then
			MUX4 <= A22;	
		elsif (SEL_MUX4 = "11") then
			MUX4 <= A32;
		end if;
	end process;
	
	-- MUX5
	process(SEL_MUX5, B20, B21, B22, B23)
	begin
		if (SEL_MUX5 = "00") then
			MUX5 <= B20;	
		elsif (SEL_MUX5 = "01") then
			MUX5 <= B21;	
		elsif (SEL_MUX5 = "10") then
			MUX5 <= B22;	
		elsif (SEL_MUX5 = "11") then
			MUX5 <= B23;
		end if;
	end process;
	
	-- MUX6
	process(SEL_MUX6, A03, A13, A23, A33)
	begin
		if (SEL_MUX6 = "00") then
			MUX6 <= A03;	
		elsif (SEL_MUX6 = "01") then
			MUX6 <= A13;	
		elsif (SEL_MUX6 = "10") then
			MUX6 <= A23;	
		elsif (SEL_MUX6 = "11") then
			MUX6 <= A33;
		end if;
	end process;
	
	-- MUX7
	process(SEL_MUX7, B30, B31, B32, B33)
	begin
		if (SEL_MUX7 = "00") then
			MUX7 <= B30;	
		elsif (SEL_MUX7 = "01") then
			MUX7 <= B31;	
		elsif (SEL_MUX7 = "10") then
			MUX7 <= B32;	
		elsif (SEL_MUX7 = "11") then
			MUX7 <= B33;
		end if;
	end process;

	-- REGISTER 0 STAGE 1
	process(clk, rst)
	begin
		if (clk'event and clk = '1') then
			if (rst = '1') then
				REG0_STAGE1 <= "00000000";
			else
				if (LOAD_STAGE1 = '1') then
					REG0_STAGE1 <= MUL0_RESULT;
				end if;
			end if;
		end if;
	end process;
	
	-- REGISTER 1 STAGE 1
	process(clk, rst)
	begin
		if (clk'event and clk = '1') then
			if (rst = '1') then
				REG1_STAGE1 <= "00000000";
			else
				if (LOAD_STAGE1 = '1') then
					REG1_STAGE1 <= MUL1_RESULT;
				end if;
			end if;
		end if;
	end process;
	
	-- REGISTER 2 STAGE 1
	process(clk, rst)
	begin
		if (clk'event and clk = '1') then
			if (rst = '1') then
				REG2_STAGE1 <= "00000000";
			else
				if (LOAD_STAGE1 = '1') then
					REG2_STAGE1 <= MUL2_RESULT;
				end if;
			end if;
		end if;
	end process;
	
	-- REGISTER 3 STAGE 1
	process(clk, rst)
	begin
		if (clk'event and clk = '1') then
			if (rst = '1') then
				REG3_STAGE1 <= "00000000";
			else
				if (LOAD_STAGE1 = '1') then
					REG3_STAGE1 <= MUL3_RESULT;
				end if;
			end if;
		end if;
	end process;
	
	-- REGISTER 0 STAGE 2
	process(clk, rst)
	begin
		if (clk'event and clk = '1') then
			if (rst = '1') then
				REG0_STAGE2 <= "000000000";
			else
				if (LOAD_STAGE2 = '1') then
					REG0_STAGE2 <= SUM0_RESULT;
				end if;
			end if;
		end if;
	end process;
	
	-- REGISTER 1 STAGE 2
	process(clk, rst)
	begin
		if (clk'event and clk = '1') then
			if (rst = '1') then
				REG1_STAGE2 <= "000000000";
			else
				if (LOAD_STAGE2 = '1') then
					REG1_STAGE2 <= SUM1_RESULT;
				end if;
			end if;
		end if;
	end process;
	
	-- REGISTER R STAGE 3
	process(clk, rst)
	begin
		if (clk'event and clk = '1') then
			if (rst = '1') then
				REGR_STAGE3 <= "0000000000";
			else
				if (LOAD_STAGE3 = '1') then
					REGR_STAGE3 <= SUMR_RESULT;
				end if;
			end if;
		end if;
	end process;
	
	-- STATE MACHINE
	process (clk, rst)
	begin
		if (rst = '1') then
			FSM_ATUAL <= s0;
		elsif (rising_edge(clk)) then
			FSM_ATUAL <= FSM_NEXT;
		end if;
	end process;
	
	process (FSM_ATUAL)
	begin
		done <= '0';
		
		LOAD_STAGE1 <= '1';
		LOAD_STAGE2 <= '1';
		LOAD_STAGE3 <= '1';
	
		case FSM_ATUAL is
			
			when s0 =>
				FSM_NEXT <= s1;
				
				LOAD_STAGE1 <= '0';
				LOAD_STAGE2 <= '0';
				LOAD_STAGE3 <= '0';
				
				SEL_MUX0 <= "00";
				SEL_MUX1 <= "00";
				SEL_MUX2 <= "00";
				SEL_MUX3 <= "00";
				SEL_MUX4 <= "00";
				SEL_MUX5 <= "00";
				SEL_MUX6 <= "00";
				SEL_MUX7 <= "00";
				
				--result <= "0000000000";
			
			-- linha 0 x coluna 0, 1, 2 e 3
			when s1 =>
				FSM_NEXT <= s2;
				
				SEL_MUX0 <= "00";
				SEL_MUX2 <= "00";
				SEL_MUX4 <= "00";
				SEL_MUX6 <= "00";
				
				SEL_MUX1 <= "00";
				SEL_MUX3 <= "00";				
				SEL_MUX5 <= "00";
				SEL_MUX7 <= "00";
				
				--result <= "0000000001";
				
			when s2 =>
				FSM_NEXT <= s3;
				
				SEL_MUX0 <= "00";
				SEL_MUX2 <= "00";
				SEL_MUX4 <= "00";
				SEL_MUX6 <= "00";
				
				SEL_MUX1 <= "01";
				SEL_MUX3 <= "01";
				SEL_MUX5 <= "01";
				SEL_MUX7 <= "01";
				
				--result <= "0000000010";
				
			when s3 =>
				FSM_NEXT <= s4;
				
				SEL_MUX0 <= "00";
				SEL_MUX2 <= "00";
				SEL_MUX4 <= "00";
				SEL_MUX6 <= "00";
				
				SEL_MUX1 <= "10";
				SEL_MUX3 <= "10";
				SEL_MUX5 <= "10";
				SEL_MUX7 <= "10";
				
				--result <= "0000000011";
				
			when s4 =>
				FSM_NEXT <= s5;
				
				SEL_MUX0 <= "00";
				SEL_MUX2 <= "00";
				SEL_MUX4 <= "00";
				SEL_MUX6 <= "00";
				
				SEL_MUX1 <= "11";
				SEL_MUX3 <= "11";
				SEL_MUX5 <= "11";
				SEL_MUX7 <= "11";
				
				--result <= "0000000100";
				
			-- linha 1 x coluna 0, 1, 2 e 3
			when s5 =>
				FSM_NEXT <= s6;
				
				SEL_MUX0 <= "01";
				SEL_MUX2 <= "01";
				SEL_MUX4 <= "01";
				SEL_MUX6 <= "01";
				
				SEL_MUX1 <= "00";
				SEL_MUX3 <= "00";				
				SEL_MUX5 <= "00";
				SEL_MUX7 <= "00";
				
				--result <= "0000000101";
				
			when s6 =>
				FSM_NEXT <= s7;
				
				SEL_MUX0 <= "01";
				SEL_MUX2 <= "01";
				SEL_MUX4 <= "01";
				SEL_MUX6 <= "01";
				
				SEL_MUX1 <= "01";
				SEL_MUX3 <= "01";
				SEL_MUX5 <= "01";
				SEL_MUX7 <= "01";
				
				--result <= "0000000110";
				
			when s7 =>
				FSM_NEXT <= s8;
				
				SEL_MUX0 <= "01";
				SEL_MUX2 <= "01";
				SEL_MUX4 <= "01";
				SEL_MUX6 <= "01";
				
				SEL_MUX1 <= "10";
				SEL_MUX3 <= "10";
				SEL_MUX5 <= "10";
				SEL_MUX7 <= "10";
				
				--result <= "0000000111";
				
			when s8 =>
				FSM_NEXT <= s9;
				
				SEL_MUX0 <= "01";
				SEL_MUX2 <= "01";
				SEL_MUX4 <= "01";
				SEL_MUX6 <= "01";
				
				SEL_MUX1 <= "11";
				SEL_MUX3 <= "11";
				SEL_MUX5 <= "11";
				SEL_MUX7 <= "11";
				
				--result <= "0000001000";
				
				
			-- linha 2 x coluna 0, 1, 2 e 3
			when s9 =>
				FSM_NEXT <= s10;
				
				SEL_MUX0 <= "10";
				SEL_MUX2 <= "10";
				SEL_MUX4 <= "10";
				SEL_MUX6 <= "10";
				
				SEL_MUX1 <= "00";
				SEL_MUX3 <= "00";				
				SEL_MUX5 <= "00";
				SEL_MUX7 <= "00";
				
				--result <= "0000001001";
				
			when s10 =>
				FSM_NEXT <= s11;
				
				SEL_MUX0 <= "10";
				SEL_MUX2 <= "10";
				SEL_MUX4 <= "10";
				SEL_MUX6 <= "10";
				
				SEL_MUX1 <= "01";
				SEL_MUX3 <= "01";
				SEL_MUX5 <= "01";
				SEL_MUX7 <= "01";
				
				--result <= "0000001010";
				
			when s11 =>
				FSM_NEXT <= s12;
				
				SEL_MUX0 <= "10";
				SEL_MUX2 <= "10";
				SEL_MUX4 <= "10";
				SEL_MUX6 <= "10";
				
				SEL_MUX1 <= "10";
				SEL_MUX3 <= "10";
				SEL_MUX5 <= "10";
				SEL_MUX7 <= "10";
				
				--result <= "0000001011";
				
			when s12 =>
				FSM_NEXT <= s13;
				
				SEL_MUX0 <= "10";
				SEL_MUX2 <= "10";
				SEL_MUX4 <= "10";
				SEL_MUX6 <= "10";
				
				SEL_MUX1 <= "11";
				SEL_MUX3 <= "11";
				SEL_MUX5 <= "11";
				SEL_MUX7 <= "11";
				
				--result <= "0000001100";
				
			-- linha 3 x coluna 0, 1, 2 e 3
			when s13 =>
				FSM_NEXT <= s14;
				
				SEL_MUX0 <= "11";
				SEL_MUX2 <= "11";
				SEL_MUX4 <= "11";
				SEL_MUX6 <= "11";
				
				SEL_MUX1 <= "00";
				SEL_MUX3 <= "00";				
				SEL_MUX5 <= "00";
				SEL_MUX7 <= "00";
				
				--result <= "0000001101";
				
			when s14 =>
				FSM_NEXT <= s15;
				
				SEL_MUX0 <= "11";
				SEL_MUX2 <= "11";
				SEL_MUX4 <= "11";
				SEL_MUX6 <= "11";
				
				SEL_MUX1 <= "01";
				SEL_MUX3 <= "01";
				SEL_MUX5 <= "01";
				SEL_MUX7 <= "01";
				
				--result <= "0000001110";
				
			when s15 =>
				FSM_NEXT <= s16;
				
				SEL_MUX0 <= "11";
				SEL_MUX2 <= "11";
				SEL_MUX4 <= "11";
				SEL_MUX6 <= "11";
				
				SEL_MUX1 <= "10";
				SEL_MUX3 <= "10";
				SEL_MUX5 <= "10";
				SEL_MUX7 <= "10";
				
				--result <= "0000001111";
				
			when s16 =>
				FSM_NEXT <= s17;
				
				SEL_MUX0 <= "11";
				SEL_MUX2 <= "11";
				SEL_MUX4 <= "11";
				SEL_MUX6 <= "11";
				
				SEL_MUX1 <= "11";
				SEL_MUX3 <= "11";
				SEL_MUX5 <= "11";
				SEL_MUX7 <= "11";
				
				--result <= "0000010000";
				
			when s17 =>
				FSM_NEXT <= s18;
				
				--result <= "0000010001";
			
			when s18 =>
				FSM_NEXT <= s19;
				
				--result <= "0000010010";
				
			when s19 =>
				FSM_NEXT <= s20;
				
				--result <= "0000010011";
				
			when s20 =>
				FSM_NEXT <= s20;
				done <= '1';
				
				--result <= "0000010100";
				
		end case;
	end process;
  
	result <= REGR_STAGE3;

end Behavioral;
--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:14:14 07/02/2016
-- Design Name:   
-- Module Name:   C:/Users/mauricio/Desktop/VHDL PROJECTS/MATRIZ-v7/TB_MATRIZ.vhd
-- Project Name:  MATRIZ-v7
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: MATRIZ
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY TB_MATRIZ IS
END TB_MATRIZ;
 
ARCHITECTURE behavior OF TB_MATRIZ IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT MATRIZ
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         result : OUT  std_logic_vector(9 downto 0);
         done : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';

 	--Outputs
   signal result : std_logic_vector(9 downto 0);
   signal done : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: MATRIZ PORT MAP (
          clk => clk,
          rst => rst,
          result => result,
          done => done
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		rst <= '1';
      wait for 100 ns;	
		
		rst <= '0';
		wait for 1000 ns;	

      -- wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;

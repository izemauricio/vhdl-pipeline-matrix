LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
  
ENTITY TB_PLACA IS
END TB_PLACA;
 
ARCHITECTURE behavior OF TB_PLACA IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT PLACA
    PORT(
         clock : IN  std_logic;
         display : OUT  std_logic_vector(7 downto 0);
         anode : OUT  std_logic_vector(3 downto 0);
         led : OUT  std_logic_vector(7 downto 0);
         button : IN  std_logic_vector(3 downto 0);
         switch : IN  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clock : std_logic := '0';
   signal button : std_logic_vector(3 downto 0) := (others => '0');
   signal switch : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal display : std_logic_vector(7 downto 0);
   signal anode : std_logic_vector(3 downto 0);
   signal led : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: PLACA PORT MAP (
          clock => clock,
          display => display,
          anode => anode,
          led => led,
          button => button,
          switch => switch
        );

   -- Clock process definitions
   clock_process :process
   begin
		clock <= '0';
		wait for clock_period/2;
		clock <= '1';
		wait for clock_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		button(0) <= '1';
		button(1) <= '1';
			wait for 60 ns;	
			button(1) <= '0';
			wait for 60 ns;	
			button(1) <= '1';
			wait for 60 ns;	
			button(1) <= '0';
			wait for 60 ns;	
      wait for 100 ns;	
		
		button(0) <= '0';
		wait for 10 ns;	
		
		for i in 0 to 40 loop
			button(1) <= '1';
			wait for 60 ns;	
			button(1) <= '0';
			wait for 60 ns;	
		END LOOP;
			
		
      -- wait for clock_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;

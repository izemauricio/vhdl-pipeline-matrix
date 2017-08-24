-- Mauricio Ize @ 2016
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity PLACA is
	Port (
		clock : in  STD_LOGIC;
		
		display : out  STD_LOGIC_VECTOR (7 downto 0); -- 11111111 = PGFEDCBA
		anode : out  STD_LOGIC_VECTOR (3 downto 0); -- 1111 = f12 j12 m13 k14
		led : out  STD_LOGIC_VECTOR (7 downto 0); -- 11111111 = g1 p4 n4 n5 p6 p7 m11 m5
		button : in  STD_LOGIC_VECTOR (3 downto 0);
		switch : in  STD_LOGIC_VECTOR (7 downto 0) -- 11111111 = n3 e2 f3 g3 b4 k3 l3 p11
	);
end PLACA;

architecture Behavioral of PLACA is

	component MATRIZ is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
			  result : out STD_LOGIC_VECTOR(9 DOWNTO 0);
           done : out  STD_LOGIC);
	end component;
	
	signal theResult : STD_LOGIC_VECTOR (9 downto 0);
	
	-- para guardar o dado no formato binario
	signal theByte : STD_LOGIC_VECTOR (9 downto 0);
	
	-- para guardar o numero no formato bcd
	signal mybcd : STD_LOGIC_VECTOR (15 downto 0);
	signal myuni : STD_LOGIC_VECTOR (3 downto 0);
	signal mydec : STD_LOGIC_VECTOR (3 downto 0);
	signal mycen : STD_LOGIC_VECTOR (3 downto 0);
	signal mymil : STD_LOGIC_VECTOR (3 downto 0);
	
	-- para guardar o numero no formato 7 segmento
	signal display1 :   STD_LOGIC_VECTOR (7 downto 0);
	signal display2 :   STD_LOGIC_VECTOR (7 downto 0);
	signal display3 :   STD_LOGIC_VECTOR (7 downto 0);
	signal display4 :   STD_LOGIC_VECTOR (7 downto 0);

	-- fsm para controlar o display
	signal counter : STD_LOGIC_VECTOR (31 downto 0);
	type FSM_STATES is (t0,t1,t2, t3);
	signal ATUAL_S2, NEXT_S2: FSM_STATES;
	
	-- fsm para controloar thebyte
	type FSM_STATES3 is (s0, s1, s2, s3);
	signal ATUAL_S3, NEXT_S3: FSM_STATES3;

	-- clock2
	signal clock2 : STD_LOGIC;
	signal lastClock2    : std_logic := '0';
	
	-- debounce o botao
	SIGNAL dbouce_input : STD_LOGIC;
	SIGNAL dbounce_shift : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL dbounce_output : STD_LOGIC;
	
	
	-- reset
	signal reset : STD_LOGIC;
	
begin

	-- input: switches and buttons
	-- conecta interface de entrada aos sinais para serem processados
	reset <= button(0);
	dbouce_input <= button(1);
	
	-- output: leds and displays
	-- conecta interface de saida aos sinais resultantes
	led(0) <= reset;
	led(1) <= dbouce_input;
	led(3) <= clock2;
	led(7 downto 4) <= "0000";
	-- theByte <= byte a ser transformado para bcd e exibido no display
	
	theByte <= theResult;
	--theByte <= "1111111111";
	
	-- componente utilizado na placa
	matriz_hw : MATRIZ
	PORT MAP (
		clk => clock2,
		rst => reset,
		result => theResult,
		done => led(2)
	);
	
	-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	-- faz debounce do botao
	process 
	begin
	  wait until (clock'event) and (clock = '1');
			
			dbounce_shift(2 downto 0) <= dbounce_shift(3 downto 1);
			dbounce_shift(3) <= not dbouce_input;
			
			if dbounce_shift(3 downto 0) = "0000" then			
			  dbounce_output <= '1';			  
			else
			  dbounce_output <= '0';
			end if;
			
	end process;
	
	-- gera 1 clock2 rise para cada aperto do botao
	process(clock, reset)
	begin
		if clock'event and clock='1' then
		
			if(dbounce_output = '1' and lastClock2 = '0') then 
				clock2 <= dbounce_output;
			else
				clock2 <= '0';
			end if;
			
			lastClock2 <= dbounce_output;
			
		end if;
	end process;
	
	-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	-- converte o theByte para 3x bcd
	process(theByte)
	
		variable i : integer:=0;
		
		variable temp : std_logic_vector(9 downto 0) := theByte;
		
		variable bcd : std_logic_vector(15 downto 0) := (others => '0');

	begin

		temp := theByte;
		
		bcd := B"0000000000000000";

		for i in 0 to 9 loop
		
			-- shit bcd
			bcd(15 downto 1) := bcd(14 downto 0);
			bcd(0) := temp(9);

			-- shit temp
			temp(9 downto 1) := temp(8 downto 0);
			temp(0) := '0';


			-- add 3 se coluna > 4
			if(i < 9 and bcd(3 downto 0) > "0100") then
				bcd(3 downto 0) := bcd(3 downto 0) + "0011";
			end if;	

			-- add 3 se coluna > 4
			if(i < 9 and bcd(7 downto 4) > "0100") then
				bcd(7 downto 4) := bcd(7 downto 4) + "0011";
			end if;

			-- add 3 se coluna > 4
			if(i < 9 and bcd(11 downto 8) > "0100") then
				bcd(11 downto 8) := bcd(11 downto 8) + "0011";
			end if;
			
			-- add 3 se coluna > 4
			if(i < 9 and bcd(15 downto 12) > "0100") then
				bcd(15 downto 12) := bcd(15 downto 12) + "0011";
			end if;

		end loop;

		--cen <= bcd(11 downto 8);
		--dez <= bcd(7  downto 4);
		--uni <= bcd(3  downto 0);	
		-- saida <= "00" & bcd(11 downto 0);
		
		mybcd <= bcd;
		mymil <= bcd(15 downto 12);
		mycen <= bcd(11 downto 8);
		mydec <= bcd(7  downto 4);
		myuni <= bcd(3  downto 0);
		
	end process;

	-- converte os 3 signals bcd para 3 signals de 7 segmentos para os 3 displays da placa
	process(myuni, mydec, mycen, mymil)
	begin
	
		case myuni is
			when "0000"=> display1 <="11000000";  -- '0'
			when "0001"=> display1 <="11111001";  -- '1' 
			when "0010"=> display1 <="10100100";  -- '2' 
			when "0011"=> display1 <="10110000";  -- '3' 
			when "0100"=> display1 <="10011001";  -- '4' 
			when "0101"=> display1 <="10010010";  -- '5' 
			when "0110"=> display1 <="10000010";  -- '6' 
			when "0111"=> display1 <="11111000";  -- '7' 
			when "1000"=> display1 <="10000000";  -- '8'
			when "1001"=> display1 <="10010000";  -- '9' 
			when others=> display1 <="01111111";
		end case;
	
		case mydec is
			when "0000"=> display2 <="11000000";  -- '0'
			when "0001"=> display2 <="11111001";  -- '1' 
			when "0010"=> display2 <="10100100";  -- '2' 
			when "0011"=> display2 <="10110000";  -- '3' 
			when "0100"=> display2 <="10011001";  -- '4' 
			when "0101"=> display2 <="10010010";  -- '5' 
			when "0110"=> display2 <="10000010";  -- '6' 
			when "0111"=> display2 <="11111000";  -- '7' 
			when "1000"=> display2 <="10000000";  -- '8'
			when "1001"=> display2 <="10010000";  -- '9' 
			when others=> display2 <="01111111";
		end case;
	
		case mycen is
			when "0000"=> display3 <="11000000";  -- '0'
			when "0001"=> display3 <="11111001";  -- '1' 
			when "0010"=> display3 <="10100100";  -- '2' 
			when "0011"=> display3 <="10110000";  -- '3' 
			when "0100"=> display3 <="10011001";  -- '4' 
			when "0101"=> display3 <="10010010";  -- '5' 
			when "0110"=> display3 <="10000010";  -- '6' 
			when "0111"=> display3 <="11111000";  -- '7' 
			when "1000"=> display3 <="10000000";  -- '8'
			when "1001"=> display3 <="10010000";  -- '9' 
			when others=> display3 <="01111111";
		end case;
		
		case mymil is
			when "0000"=> display4 <="11000000";  -- '0'
			when "0001"=> display4 <="11111001";  -- '1' 
			when "0010"=> display4 <="10100100";  -- '2' 
			when "0011"=> display4 <="10110000";  -- '3' 
			when "0100"=> display4 <="10011001";  -- '4' 
			when "0101"=> display4 <="10010010";  -- '5' 
			when "0110"=> display4 <="10000010";  -- '6' 
			when "0111"=> display4 <="11111000";  -- '7' 
			when "1000"=> display4 <="10000000";  -- '8'
			when "1001"=> display4 <="10010000";  -- '9' 
			when others=> display4 <="01111111";
		end case;
	
	end process;

	-- fsm para exibir os 3 displays
	process (clock, reset)
	begin
		
		if (reset='1') then
			ATUAL_S2 <= t0;
			counter <= (others => '0');
		else
			if(clock'event and clock='1') then
				
				if(counter = "10001011011100110101") then -- divide a frequencia de 50,000,000 Hz para 60 Hz
					ATUAL_S2 <= NEXT_S2;
					counter <= (others => '0');
				else
					counter <= counter + 1;
				end if;
				
			end if;
		end if;
		
	end process;
			
	process (ATUAL_S2)
	begin
		case ATUAL_S2 is
		
			when t0 =>
				NEXT_S2 <= t1;
				display <= display1;
				anode <= "1110";
			
			when t1 =>
				NEXT_S2 <= t2;
				display <= display2;
				anode <= "1101";
			
			when t2 =>
				NEXT_S2 <= t3;
				display <= display3;
				anode <= "1011";	
				
			when t3 =>
				NEXT_S2 <= t0;
				display <= display4;
				anode <= "0111";
				
		end case;
	end process;
	
	-- %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	-- fsm para incrementar o theByte
	-- fsm para exibir os 3 displays
	process (clock2, reset)
	begin
		
		if reset='1' then
			ATUAL_S3 <= s0;
		else
			if clock2'event and clock2='1' then
				ATUAL_S3 <= NEXT_S3;
			end if;
		end if;
		
	end process;
			
	process (ATUAL_S3)
	begin
		
		case ATUAL_S3 is
		
			when s0 =>
				NEXT_S3 <= s1;
				--theByte <= "01111111";
				
			when s1 =>
				NEXT_S3 <= s2;
				--theByte <= "00001111";
			
			when s2 =>
				NEXT_S3 <= s3;
				--theByte <= "00000011";
				
			when s3 =>
				NEXT_S3 <= s0;
				--theByte <= "11111111";
				
		end case;
		
	end process;

end Behavioral;
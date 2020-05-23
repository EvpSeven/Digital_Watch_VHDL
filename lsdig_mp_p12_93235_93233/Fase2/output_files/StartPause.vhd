--Start/Stop

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity StartPause is
	port(clk : in std_logic;
		  dataIn : in std_logic;
		  dataOut : out std_logic);
end StartPause;

architecture Behavioral of StartPause is
	signal s_dataOUt : std_logic:='0'; -- Sinal de dados de saída
	signal s_signal : std_logic; -- Sinal de dados de entrada
	begin
		process(clk)
		begin
		s_signal <= dataIn;
		if(rising_edge(clk)) then
			if(s_dataOut <='0') then
			s_dataOut <= not s_signal; 
			else 
			s_dataOut <= s_signal;	
			end if;
		end if;	
	end process;
	dataOut <= s_dataOut;
end Behavioral;
	
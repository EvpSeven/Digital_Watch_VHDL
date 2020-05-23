--Módulo do Contador de 4 bits

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity DeCounter4Bits is
	generic(MAX		: integer := 9);
	port(reset		: in  std_logic;
		  clk			: in  std_logic;
		  enClk	: in  std_logic;
		  enable	: in  std_logic;
		  valOut		: out std_logic_vector(3 downto 0); --valor de saida
		  RCO	: out std_logic --ativa o RCO no fim da contagem
		  );
end DeCounter4Bits;

architecture RTL of DeCounter4Bits is

	signal s_count : natural := MAX;
	signal s_enable: std_logic;
	
	
begin
	process(clk)
	begin	
		if (rising_edge(clk)) then			if (reset = '1') then
				s_count <= MAX; --valor max do signal renova a contagem
				
			elsif ((enClk = '1') and (enable = '1') ) then
				if (s_count = 0) then
					s_count <= MAX;
				else
					s_count <= s_count - 1;
				end if;
			
			end if;
		end if;	
	end process;
	RCO <= '1' when s_count = 0 and enClk = '1' else '0';
	valOut <= std_logic_vector(to_unsigned(s_count, 4));
end RTL;
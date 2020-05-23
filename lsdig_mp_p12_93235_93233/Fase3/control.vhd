--Control unity

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity control is
	port(start : in std_logic;
		 clk : in std_logic;
		 start_out : out std_logic;
		 reset_out: out std_logic;
		 reset_in: in std_logic;
		 enable_reg: in std_logic;
		 termCont: in std_logic
		 );

end control;

architecture behav of control is
signal s_startout: std_logic:='0';

begin
start_out<=s_startout;
reset_out<=reset_in;
	process(clk)
	begin
		if(rising_edge(clk)) then
			if(reset_in='1') then
				s_startout <= '0';
			else 
			if (start = '1') then
				s_startout <= '1';
			end if;
				if (termCont = '1') then
					s_startout <= '0';
				end if;
			end if;
			if(enable_reg='1') then
				s_startout <= '1';
			end if;
		end if;
	end process;
end behav;
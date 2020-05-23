--HEX BLOCK

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity Hex_Block is
	port(	clk : in std_logic;
	enable : in std_logic;
	dataIn0 : in std_logic_vector(3 downto 0);
	dataOut0 : out std_logic_vector(3 downto 0);
	dataIn1 : in std_logic_vector(3 downto 0);
	dataOut1 : out std_logic_vector(3 downto 0);
	dataIn2 : in std_logic_vector(3 downto 0);
	dataOut2 : out std_logic_vector(3 downto 0);
	dataIn3 : in std_logic_vector(3 downto 0);
	dataOut3 : out std_logic_vector(3 downto 0)
	);
end Hex_Block;
architecture Behav of Hex_Block is
begin
	process(clk)
	begin
		if (rising_edge(clk)) then
		if (enable = '1') then
		dataOut0 <= dataIn0;
		dataOut1 <= dataIn1;
		dataOut2 <= dataIn2;
		dataOut3 <= dataIn3;
		end if;
		end if;
	end process;
end Behav;
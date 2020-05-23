library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity Demo_Final is
		
		port(	CLOCK_50	: in  std_logic;	
				SW			: in  std_logic_vector(17 downto 0);
				KEY		: in  std_logic_vector(3 downto 0); 
				HEX2		: out std_logic_vector(6 downto 0);
				HEX3		: out std_logic_vector(6 downto 0);
				HEX4		: out std_logic_vector(6 downto 0);
				HEX5		: out std_logic_vector(6 downto 0);
				LEDG     : out std_logic_vector(8 downto 0);
				LEDR		: out std_logic_vector(17 downto 0)
			  );

end Demo_Final;
architecture shell of Demo_Final is

	--sinal do clock
	signal s_clk4Hz : std_logic;

	
	signal s_reset : std_logic;
	
	--Terminal count flags of each counter
	signal s_sUnitsTerm, s_sTensTerm	: std_logic_vector(3 downto 0);
	signal s_mUnitsTerm, s_mTensTerm	: std_logic_vector(3 downto 0);

	--signalRCO
	signal s_rco0: std_logic;
	signal s_rco1: std_logic;
	signal s_rco2: std_logic;
	signal s_rco3: std_logic;
	

	--Inicio da contagem
	signal s_start:std_logic;
	
	
	--sianl de acabagem da contagem
	signal s_finish: std_logic;
	signal s_termina: std_logic;
	
	signal en_clk:std_logic;
	
	signal s_enable_count:std_logic;
	
	signal s_startout:std_logic;
	
	signal s_termCont:std_logic;
	
	
	
begin

	s_start <= not KEY(2); --ativa a contagem
	
	clk : entity work.en_gen(beh)
					--generic map(k => 5E6)
							port map(clkIn	=> CLOCK_50,
										en		=> en_clk
										);
										
	c: entity work.control(behav)
			port map(start => s_start,
						clk => CLOCK_50,
						start_out => s_startout,
						reset_out => s_reset,
						reset_in=>not KEY(3),
						termCont => s_termCont
						);
										
	
	d0 : entity work.DeCounter4Bits(RTL)
			generic map(MAX	=> 9)
			port map(  
						reset	=>	s_reset,
					   clk =>	CLOCK_50,		
						enable	=> s_startout,
						enClk => en_clk,
						valOut =>  s_sUnitsTerm,	
						RCO => 	s_rco0
						);
	
	d1 : entity work.DeCounter4Bits(RTL)
			generic map(MAX	=> 9)
			port map(  
						reset	=>s_reset,
					   clk =>CLOCK_50,		
						enable	=>s_startout,
						enClk =>s_rco0,	
						valOut =>s_mUnitsTerm,	
						RCO =>	s_rco1
						);
	
	
	d2 : entity work.DeCounter4Bits(RTL)
			generic map(MAX	=> 9)
			port map(  
						reset	=>	s_reset,
					   clk =>	CLOCK_50,	
						enable	=>s_startout,
						enClk =>s_rco1,	
						valOut =>s_sTensTerm	,	
						RCO =>	s_rco2
						);
	
	d3 : entity work.DeCounter4Bits(RTL)
			generic map(MAX	=> 5)
			port map(  
						reset	=>	s_reset,
					   clk =>	CLOCK_50,		
						enable	=> s_startout,
						enClk => s_rco2,	
						valOut =>	s_mTensTerm,	
						RCO =>	s_rco3
						);
						
	

	
	
	LEDG(8) <= s_termCont; --Acende um LED quando a contagem chega a 00:00;
	
	
	s_termCont <= '1' when (s_sUnitsTerm = "0000" and s_sTensTerm = "0000" and s_mUnitsTerm = "0000" and s_mTensTerm="0000") else
					'0'; -- Sinal de paragem
	
						
	--Bloco do display de 7 Segmentos dos segundos (HEX2)
	s_units_decod : entity work.Bin7SegDecoder(Behavioral)
							port map(enable	=> '1',
										binInput	=> s_sUnitsTerm,
										decOut_n	=> HEX2);


	--Bloco do display de 7 Segmentos dos segundos (HEX3)
	s_tens_decod : entity work.Bin7SegDecoder(Behavioral)
							port map(enable	=> '1',
										binInput	=> s_mUnitsTerm,
										decOut_n	=> HEX3);
							
	--Bloco do display de 7 Segmentos dos minutos (HEX4)	
	m_units_decod : entity work.Bin7SegDecoder(Behavioral)
							port map(enable	=> '1',
										binInput	=> s_sTensTerm,
										decOut_n	=> HEX4);
						
	--Bloco do display de 7 Segmentos dos minutos (HEX5)
	m_tens_decod : entity work.Bin7SegDecoder(Behavioral)
							port map(enable	=> '1',
										binInput	=> s_mTensTerm,
										decOut_n	=> HEX5);
										
				
										
end shell;

	
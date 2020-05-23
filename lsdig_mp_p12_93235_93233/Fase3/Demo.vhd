library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity Demo is
		
		port(	CLOCK_50	: in  std_logic;	
				SW			: in  std_logic_vector(17 downto 0);
				KEY			: in  std_logic_vector(3 downto 0);
				HEX2		: out std_logic_vector(6 downto 0);
				HEX3		: out std_logic_vector(6 downto 0);
				HEX4		: out std_logic_vector(6 downto 0);
				HEX5		: out std_logic_vector(6 downto 0);
				LEDG		: out std_logic_vector(8 downto 0)
			  );

end Demo;
architecture shell of Demo is

	--sinal do clock
	signal s_clk4Hz : std_logic;

	
	signal s_reset : std_logic;
	
	-- Terminal count flags of each counter
	signal s_sUnitsTerm, s_sTensTerm	: std_logic_vector(3 downto 0);
	signal s_mUnitsTerm, s_mTensTerm	: std_logic_vector(3 downto 0);

	--signalRCO
	signal s_rco0: std_logic;
	signal s_rco1: std_logic;
	signal s_rco2: std_logic;
	signal s_rco3: std_logic;
	
	--En para o primeiro deCount
	signal s_firstEN: std_logic;
	
	--Inicio da contagem
	signal s_start:std_logic;
	

begin

	s_firstEN <= SW(0);
	s_reset <= SW(1);
	s_start <= SW(17);
	
	clk_div_4hz : entity work.ClkDividerN(RTL)
							generic map(k			=>12500000 )
							port map(clkIn			=> CLOCK_50,
										clkOut		=> s_clk4Hz);
										
	
	
	
	d0 : entity work.DeCounter4Bits(RTL)
			generic map(MAX	=> 9)
			port map(  
						reset	=>	s_reset,
					   clk =>	s_clk4Hz,		
						start	=> s_start,
						enable =>	s_firstEN,
						valOut =>  s_sUnitsTerm,	
						RCO => 	s_rco0,
						stopCount => '0'
						);
	
	d1 : entity work.DeCounter4Bits(RTL)
			generic map(MAX	=> 9)
			port map(  
						reset	=>s_reset,
					   clk =>s_clk4Hz,		
						start	=>s_firstEN,
						enable =>s_rco0,	
						valOut =>s_mUnitsTerm,	
						RCO =>	s_rco1,
						stopCount => '0'
						);
	
	d2 : entity work.DeCounter4Bits(RTL)
			generic map(MAX	=> 9)
			port map(  
						reset	=>	s_reset,
					   clk =>	s_clk4Hz,	
						start	=>s_firstEN,
						enable =>s_rco1,	
						valOut =>s_sTensTerm	,	
						RCO =>	s_rco2,
						stopCount => '0'
						);
	
	d3 : entity work.DeCounter4Bits(RTL)
			generic map(MAX	=> 5)
			port map(  
						reset	=>	s_reset,
					   clk =>	s_clk4Hz,		
						start	=>s_firstEN,
						enable => s_rco2,	
						valOut =>	s_mTensTerm,	
						RCO =>	s_rco3,
						stopCount => '0'
						);
						
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

	
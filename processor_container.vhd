library ieee;
use ieee.std_logic_1164.all;

entity processor_container is
	port(
		CLOCK_50	: in std_logic;
		GPIO : in std_logic_vector(4 downto 0)
	);
	
end entity;

architecture arch of processor_container is

COMPONENT processor
	PORT (
	clk : IN STD_LOGIC;
	reset : IN STD_LOGIC
	);
END COMPONENT;


BEGIN
	i1 : processor
	PORT MAP (
-- list connections between master ports and signals
		clk => CLOCK_50,
		reset => GPIO(0)
	);
	
end architecture;
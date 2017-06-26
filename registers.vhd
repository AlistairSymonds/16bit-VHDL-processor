library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registers is
	port(
	clk, reset : in std_logic;
		
		write_enable : in std_logic;
		write_addr, read1_addr, read2_addr : in std_logic_vector(3 downto 0);
		write_val : in std_logic_vector(15 downto 0);
		read1, read2 : out std_logic_vector(15 downto 0);
		
		sec_write_enable : in std_logic;
		sec_write_addr, sec_read1_addr, sec_read2_addr : in std_logic_vector(3 downto 0);
		sec_write_val : in std_logic_vector(15 downto 0);
		sec_read1, sec_read2 : out std_logic_vector(15 downto 0)
	);
end entity;

architecture arch of registers is
type regs_type is array (0 to 15) of std_logic_vector(15 downto 0);
signal regs_array : regs_type;

begin
process(clk, reset)
	begin
	if(reset = '1') then
		for i in 0 to 15 loop
			regs_array(i) <= (others => '0');
		end loop;
	elsif(rising_edge(clk)) then
		
		if(write_enable = '1') then
			regs_array(to_integer(unsigned(write_addr))) <= write_val;
		end if;
		
		if(sec_write_enable = '1') then
			regs_array(to_integer(unsigned(sec_write_addr))) <= sec_write_val;
		end if;
		
	end if;
end process;

read1 <= regs_array(to_integer(unsigned(read1_addr)));
read2 <= regs_array(to_integer(unsigned(read2_addr)));

sec_read1 <= regs_array(to_integer(unsigned(sec_read1_addr)));
sec_read2 <= regs_array(to_integer(unsigned(sec_read2_addr)));
end architecture;
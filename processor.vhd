library ieee;
use ieee.std_logic_1164.all;

package processor_info is
	constant size : integer := 8;
end processor_info;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.processor_info.all;

entity processor is
	port(
		clk, reset : in std_logic
	);
end entity;

architecture arch of processor is

	

	component super_control is
		port(
			instruction, future_instruction : in  std_logic_vector(22 downto 0);
			clk, reset : in std_logic;
			pc_val_port : out unsigned(size-1 downto 0)
		);	
	end component;
	
	signal instr_val, instr_future_val : std_logic_vector(31 downto 0);
	signal pc_val : unsigned(size-1 downto 0) := (others => '0'); 
	
	component prog_ram is
	generic (N : integer);
	port(write_enable, clk : in std_logic;
		addr, i_addr : in std_logic_vector(N-1 downto 0);
		write_val : in std_logic_vector(31 downto 0);
		read_val, i_val, i_val_future : out std_logic_vector(31 downto 0)
	);
	end component;
	
	--connecting stuff together
	begin
	
	p_ram : prog_ram
	generic map (N => size)
	port map( 
		write_enable => '0',
		clk => clk,
		i_addr => std_logic_vector(pc_val),
		i_val => instr_val,
		i_val_future => instr_future_val,
		write_val => (others => '0'),
		addr => (others => '0')
		
	);
	
	core : super_control
	port map(
		instruction => instr_val(22 downto 0),
		future_instruction => instr_future_val(22 downto 0),
		clk => clk,
		reset => reset,
		pc_val_port => pc_val
	);

	
	
	
end architecture;
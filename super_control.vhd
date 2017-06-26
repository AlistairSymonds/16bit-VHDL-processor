library ieee;
use ieee.std_logic_1164.all;	
use ieee.numeric_std.all;
use work.processor_info.all;

entity super_control is
	port(
		instruction, future_instruction : in  std_logic_vector(22 downto 0);
		clk, reset : in std_logic;
		pc_val_port : out unsigned(size-1 downto 0)
	);	
end entity;



architecture arch of super_control is

--utility declarations

type pipeline_conns is record
		instruction : std_logic_vector(22 downto 0);
		reg_write_enable :  std_logic;
		reg_read1_addr, reg_read2_addr, reg_write_addr : std_logic_vector(3 downto 0);
		reg_read1_val, reg_read2_val : std_logic_vector(15 downto 0);
		reg_write_val : std_logic_vector(15 downto 0);
end record;
	
type pipe_conn_arr is array (0 to 1) of pipeline_conns;
signal p_conn_bundle : pipe_conn_arr;



-- component declarations

component operator
	port(
		instruction : in std_logic_vector(22 downto 0);
		reg_read1_addr, reg_read2_addr, reg_write_addr : out std_logic_vector(3 downto 0);
		reg_read1_val, reg_read2_val : in std_logic_vector(15 downto 0);
		reg_write_val : out std_logic_vector(15 downto 0)
	);
end component;

component registers
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
end component;

component instruction_checker
	port(
		i, i_future : in std_logic_vector(22 downto 0);
		safe_flag : out std_logic
	);
end component;

signal pc_val : unsigned(size-1 downto 0) := (others => '0');
signal pc_inc_amount : unsigned(1 downto 0); 
signal i_reg, i_future_reg : std_logic_vector(22 downto 0);

signal main_write_val : std_logic_vector(15 downto 0);
signal sec_write_enable, safe_flag, pc_inc_pulse : std_logic;
signal state : unsigned(2 downto 0);


--ARCH MAIN

begin


set_state : process(clk, reset)
begin
	if reset = '1' then
		state <= "111";
	elsif (rising_edge(clk)) then
		if state = "111" or state = "010" then
			state <= "000";
			i_reg <= instruction;
			i_future_reg <= future_instruction;
		else 
			state <= state + 1;
		end if;
	end if;
end process;



process_state : process(state)
begin
	pc_inc_pulse <= '0';
	p_conn_bundle(0).reg_write_enable <= '0';
	p_conn_bundle(1).reg_write_enable <= '0';
	case state is
		when "000" => 
	
		when "001" =>
			
			
			if(i_reg(22 downto 20) = "101") then
				p_conn_bundle(0).reg_write_enable <= '0';
				p_conn_bundle(1).reg_write_enable <= '0';
			else 
				p_conn_bundle(0).reg_write_enable <= '1';
				p_conn_bundle(1).reg_write_enable <= '1';
			end if;
		when "010" =>
			pc_inc_pulse <= '1';
		when others =>
			
	end case;
end process;

-- Program Counter

pc_val_port <= pc_val;
pc_inc_proc : process(reset, pc_inc_pulse, safe_flag)
begin
	if reset = '1' then
		pc_val <= (others => '0');
	elsif rising_edge(pc_inc_pulse) then
	
		if safe_flag= '0' then
			pc_val <= pc_val + 1;
		elsif(safe_flag = '1') then
			pc_val <= pc_val + 2;
		end if;
		
		if(i_reg(22 downto 20) = "101") then
			pc_val <= unsigned(p_conn_bundle(0).reg_read1_val(7 downto 0));
		
		elsif (safe_flag = '1' and i_future_reg(22 downto 20) = "101") then
			pc_val <= unsigned(p_conn_bundle(1).reg_write_val(7 downto 0));
		end if;
		
	end if;
end process;



	
--Instruction Checker	

checker : instruction_checker
	port map(
		i => i_reg,
		i_future => i_future_reg,
		safe_flag => safe_flag
	);

	
--LDPC code
process(i_reg, p_conn_bundle(0).reg_write_val, pc_val)
begin
	main_write_val <= p_conn_bundle(0).reg_write_val;
	if i_reg(22 downto 20) = "100" then --LDPC
		main_write_val(7 downto 0) <= (std_logic_vector(pc_val));
		main_write_val(15 downto 8) <= (others => '0');
		
	end if;
end process;	
	
--Register <-> Operator connections


p_conn_bundle(0).instruction <= i_reg;
OP1 : operator
	port map(
		instruction => p_conn_bundle(0).instruction,
		reg_read1_addr => p_conn_bundle(0).reg_read1_addr,
		reg_read2_addr => p_conn_bundle(0).reg_read2_addr,
		reg_write_addr => p_conn_bundle(0).reg_write_addr,
		reg_read1_val => p_conn_bundle(0).reg_read1_val,
		reg_read2_val => p_conn_bundle(0).reg_read2_val,
		reg_write_val => p_conn_bundle(0).reg_write_val
	);
	
p_conn_bundle(1).instruction <= i_future_reg;	
OP2 : operator 
	port map(
		instruction => p_conn_bundle(1).instruction,
		reg_read1_addr => p_conn_bundle(1).reg_read1_addr,
		reg_read2_addr => p_conn_bundle(1).reg_read2_addr,
		reg_write_addr => p_conn_bundle(1).reg_write_addr,
		reg_read1_val => p_conn_bundle(1).reg_read1_val,
		reg_read2_val => p_conn_bundle(1).reg_read2_val,
		reg_write_val => p_conn_bundle(1).reg_write_val
	);
	

sec_write_enable <= safe_flag and p_conn_bundle(1).reg_write_enable;

register_file : registers
	port map(
		clk => clk,
		reset => reset,
		
		write_enable => p_conn_bundle(0).reg_write_enable,
		write_addr => p_conn_bundle(0).reg_write_addr,
		read1_addr => p_conn_bundle(0).reg_read1_addr,
		read2_addr => p_conn_bundle(0).reg_read2_addr,
		write_val => main_write_val,
		read1 => p_conn_bundle(0).reg_read1_val,
		read2 => p_conn_bundle(0).reg_read2_val,
		
		sec_write_enable => sec_write_enable,
		sec_write_addr => p_conn_bundle(1).reg_write_addr,
		sec_read1_addr => p_conn_bundle(1).reg_read1_addr,
		sec_read2_addr => p_conn_bundle(1).reg_read2_addr,
		sec_write_val => p_conn_bundle(1).reg_write_val,
		sec_read1 => p_conn_bundle(1).reg_read1_val,
		sec_read2 => p_conn_bundle(1).reg_read2_val

	);
	
end architecture;
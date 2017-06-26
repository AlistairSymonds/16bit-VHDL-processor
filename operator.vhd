library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.processor_info.all;

entity operator is
	port(
		instruction : in std_logic_vector(22 downto 0);
		
		reg_read1_addr, reg_read2_addr, reg_write_addr : out std_logic_vector(3 downto 0);
		reg_read1_val, reg_read2_val : in std_logic_vector(15 downto 0);
		reg_write_val : out std_logic_vector(15 downto 0)
	);
end entity;

architecture arch of operator is

alias op : std_logic_vector(2 downto 0) is instruction(22 downto 20);
alias Rx : std_logic_vector(3 downto 0) is instruction(19 downto 16);
alias Ry : std_logic_vector(3 downto 0) is instruction(15 downto 12); 

-- begin ALU related declarations

signal alu_a, alu_b, alu_o : signed(15 downto 0);
signal alu_opcode : std_LOGIC_VECTOR(1 downto 0);
signal alu_overflow : std_logic;
signal output_val : std_logic_vector(15 downto 0);
signal xor_output : std_logic_vector(15 downto 0);

component alu
	port(
		opcode : in std_logic_vector(1 downto 0);
		a, b : in signed(15 downto 0);
		o : out signed(15 downto 0);
		overflow : out std_logic
	);
end component;
-- end alu related declarations

begin
	al_the_alu : alu 
	port map(
		a => alu_a,
		b => alu_b,
		o => alu_o,
		opcode => alu_opcode,
		overflow => alu_overflow
	);
	
	reg_read1_addr <= Rx;
	reg_read2_addr <= Ry;
	reg_write_addr <= Rx;
	reg_write_val <= output_val;
	
	
	do_op : process(instruction, reg_read1_val, reg_read2_val)
	begin
		alu_a <= signed(reg_read1_val);
		alu_b <= signed(reg_read2_val);
		xor_output <= (others => '0');
		alu_opcode <= "00";
		
		case op is
			when "000" => --load immediate
				alu_a <= signed(instruction(15 downto 0));
				alu_b <=	(others => '0');
				
			when "001" => --mov
				alu_b <=	(others => '0');
				alu_a <= signed(reg_read2_val);
			when "010" => --add
				--nothing, default assignments is add
			when "011" => --xor
				xor_output <= reg_read1_val xor reg_read2_val;
			when "100" =>
				alu_b <= (others => '0');
				
			when others => 
		end case;
	end process;
	
	get_outputs : process(alu_o)
	begin
		case op is
			when "011" => 
				output_val <= xor_output;
			when others =>
				output_val <= std_logic_vector(alu_o);
		end case;
	end process;
	
	
end architecture;
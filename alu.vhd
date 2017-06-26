LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;  
use ieee.numeric_std.all; 

--ALL COMBINATIONAL

entity alu is
	port(
		opcode : in std_logic_vector(1 downto 0);
		a, b : in signed(15 downto 0);
		o : out signed(15 downto 0);
		overflow : out std_logic
	);
end entity;

architecture arch of alu is
signal o_int: signed(15 downto 0);
signal O_int_msb : std_logic;



begin
	o <= o_int; --outside of process, happens instantly
	
	process(a,b,opcode)
	variable same_sign : boolean;
	variable output_diff : boolean;
	variable o_var : signed(15 downto 0);
	begin		
		--a & b aren't modified in the process and as such can be assigned once at the beginning
		same_sign := a(a'length-1) = (b(b'length-1));
		--assume ALU is innocent of overflow crimes
		overflow <= '0';
		
		case(opcode) is
			when "00" =>
				o_var := a+b;
				-- however output_diff has to happen after o_var is determined
				--otherwise it still is defined from o_var in previous cycle
				output_diff := a(a'length-1) /= o_var(o_var'length-1);	
				if(same_sign and output_diff)then
					overflow <= '1';
				end if;
				
			when "01" =>
				o_var := a-b;
				output_diff := a(a'length-1) /= o_var(o_var'length-1);
				if(not same_sign and output_diff) then
					overflow <= '1';
				end if;
				
			when others =>
				--do nothing
		end case;
		o_int <= o_var;
	end process;
end architecture;
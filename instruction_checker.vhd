library ieee;
use ieee.std_logic_1164.all;

--ALL COMBINATIONAL

entity instruction_checker is
	port(
		i, i_future : in std_logic_vector(22 downto 0);
		safe_flag : out std_logic
	);
end entity;

architecture arch of instruction_checker is
begin

	check_proc : process(i, i_future)
	begin
		safe_flag <= '1'; -- assume safe, try to prove it isn't
		
		--check if both instructions have the same destination
		if(i(19 downto 16) =i_future(19 downto 16)) then
			safe_flag <= '0';
		end if;
		
		--LDI instruction, less stringent checking required as it can't depend on 
		-- previous instruction's output
		if(not (i_future(22 downto 20) = "000")) then 
			--are either of the registers needed for future modified by current?
			if(i_future(19 downto 16) = i(19 downto 16) or
				i_future(15 downto 12) = i(19 downto 16)) then
				safe_flag <= '0';
			end if;
		end if;
		
		if(i(22 downto 20) = "101" or 
			i(22 downto 20) = "100" or 
			i_future(22 downto 20) = "100" or
			i_future(22 downto 20) = "101") then
			
			safe_flag <= '0';
		end if;
	end process;

end architecture;
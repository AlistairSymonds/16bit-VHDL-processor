library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity prog_ram is
generic (N : integer);
port(write_enable, clk : in std_logic;
		addr, i_addr : in std_logic_vector(N-1 downto 0);
		write_val : in std_logic_vector(31 downto 0);
		read_val, i_val, i_val_future : out std_logic_vector(31 downto 0)
	);
end entity;

architecture arch of prog_ram is
type cell_type is array (0 to (2**N-1)) of std_logic_vector(31 downto 0);
signal cell_array : cell_type :=((others=> (others=>'0')));



begin

--instruction execution sets, if unsafe an instruction cannot
--be completed with 

--instruction pairs 0 to 5 are all safe
cell_array(0) <= (b"000000000" & "000" & x"1" & x"0001");--safe, LDI 1 -> R1
cell_array(1) <= (b"000000000" & "000" & x"2" & x"0002" );--safe LDI 2 -> R2

cell_array(2) <= (b"000000000" & "000" & x"3" & x"0003");--safe, LDI 3 -> R3
cell_array(3) <= (b"000000000" & "000" & x"4" & x"0004");--safe, LDI 4 -> R4

cell_array(4) <= (b"000000000" & "010" & x"1" & x"2" & x"000" );--safe, R1+R2->R1
cell_array(5) <= (b"000000000" & "010" & x"3" & x"4" & x"000" );--safe, R3+R4->R3

cell_array(6) <= (b"000000000" & "000" & x"F" & x"FFFF"); --safe

cell_array(7) <= (b"000000000" & "001" & x"E" & x"F" & x"000"); --has to be executed after previous as it depends on RxF

cell_array(8) <= (b"000000000" & "000" & x"B" & x"0018" ); --LDI 24 into RxA for branching

cell_array(9) <= (b"000000000" & "100" & x"0" & x"0000" ); --store ret adress in R0 (LDPC into Rx0)



cell_array(10) <= (b"000000000" & "101" & x"B" & x"0000");--jump to address in RB (24)

cell_array(11) <= (b"000000000" & "000" & x"4" & x"0000");
cell_array(12) <= (b"000000000" & "101" & x"4" & x"0000");--jump to adress in r4 (ie, start over)


cell_array(24) <=(b"000000000" & "000" & x"8" & x"FFFF");
cell_array(25) <=(b"000000000" & "000" & x"9" & x"AAAA");

cell_array(26) <= (b"000000000" & "011" & x"8" & x"9" & x"000");-- R8 xor R9
cell_array(27) <= (b"000000000" & "000" & x"1" & x"0001");-- load 2 into r1

cell_array(28) <= (b"000000000" & "010" & x"0" & x"2" & x"000"); --ret adress = ret adress +2;

cell_array(29) <= (b"000000000" & "101" & x"0" & x"0000");--jump back to R0's value


--code for if the RAM wasn't ROM

--process(clk)
--	begin
--	if(rising_edge(clk)) then
--		if(write_enable = '1') then
--			cell_array(to_integer(unsigned(addr))) <= write_val;
--		end if;
--	end if;
--end process;

read_val <= cell_array(to_integer(unsigned(addr)));
i_val <= cell_array(to_integer(unsigned(i_addr)));
i_val_future <= cell_array(to_integer(unsigned(i_addr)+1));
end architecture;
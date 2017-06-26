-- Copyright (C) 2016  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel MegaCore Function License Agreement, or other 
-- applicable license agreement, including, without limitation, 
-- that your use is for the sole purpose of programming logic 
-- devices manufactured by Intel and sold by Intel or its 
-- authorized distributors.  Please refer to the applicable 
-- agreement for further details.

-- ***************************************************************************
-- This file contains a Vhdl test bench template that is freely editable to   
-- suit user's needs .Comments are provided in each section to help the user  
-- fill out necessary details.                                                
-- ***************************************************************************
-- Generated on "06/06/2017 23:14:29"
                                                            
-- Vhdl Test Bench template for design  :  processor
-- 
-- Simulation tool : ModelSim-Altera (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY processor_vhd_tst IS
END processor_vhd_tst;
ARCHITECTURE processor_arch OF processor_vhd_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL clk : STD_LOGIC := '0';
SIGNAL reset : STD_LOGIC;
signal cnt: integer:= 0;
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
	clk => clk,
	reset => reset
	);
   
	-- Create a clk
	clk_proc: process 
	begin         
		wait for 50 ns;
		clk <= not(clk);
	end process;         

	stim_proc2: process(clk) 
	begin
		if rising_edge(clk) then
			cnt <= cnt+1;
		end if;
	end process;
	
	process (cnt)
	begin  
		case cnt is 
			when 0 to 5 =>
				reset <= '1';
			when 100 to 102 =>
				reset <= '1';	
			
			when others =>
				reset <= '0';
		end case;
	end process;
                                                      
                                        
             
                                          
END processor_arch;

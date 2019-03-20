library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LSU is
	port(
			clk			: in std_logic;
			reset		: in std_logic;
			
			addr_out	: out std_logic_vector(31 downto 0);
			rdata_in	: in std_logic_vector(31 downto 0);
			wdata_out	: out std_logic_vector(31 downto 0);

			alu_result_in: in std_logic_vector(31 downto 0);
			register_data_in: in std_logic_vector(31 downto 0);
			rdata_out	: out std_logic_vector(31 downto 0);
			mem_hit_out : out std_logic;

			load_en_in	: in std_logic;
			store_en_in	: in std_logic
		);

end entity;

architecture arch of LSU is
begin


	wdata_out <= register_data_in;
	rdata_out <= rdata_in;
	addr_out <= alu_result_in;
	mem_hit_out <= '1';

end arch;

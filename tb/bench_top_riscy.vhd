library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity bench_top_riscy is
end entity;

library lib_VHDL;
use lib_VHDL.defines.all;

architecture arch of bench_top_riscy is

	signal clk				: std_logic := '0';
	signal reset			: std_logic := '1';
	signal rom_read_addr	: std_logic_vector(31 downto 0) := (others => '0');
	signal rom_read_ovalid	: std_logic;
	signal rom_read_ivalid	: std_logic;
	signal rom_read_data	: std_logic_vector(31 downto 0) := (others => '0');
	signal mem_addr			: std_logic_vector(31 downto 0) := (others => '0');
	signal mem_read_data	: std_logic_vector(31 downto 0) := (others => '0');
	signal mem_write_data	: std_logic_vector(31 downto 0) := (others => '0');
	signal mem_write_en		: std_logic := '0';
	signal mem_read_en		: std_logic := '0';

begin

	DUT : entity lib_VHDL.top_riscy
		port map(
					clk					=> clk,
					reset				=> reset,
					rom_read_addr_out	=> rom_read_addr,
					rom_read_valid_out	=> rom_read_ovalid,
					rom_read_valid_in	=> rom_read_ivalid,
					rom_read_data_in	=> rom_read_data,
					mem_addr_out		=> mem_addr,
					mem_read_data_in	=> mem_read_data,
					mem_write_data_out	=> mem_write_data,
					mem_read_en_out		=> mem_read_en,
					mem_write_en_out	=> mem_write_en
				);
	
	RAM : entity lib_vhdl.ram
		port map(
			clk				=> clk,
			reset			=> reset,
			addr_in			=> mem_addr,
			data_in			=> mem_write_data,
			data_out		=> mem_read_data,
			write_en_in		=> mem_write_en,
			read_en_in		=> mem_read_en
				);

	ROM : entity lib_vhdl.rom
		port map(
			clk				=> clk,
			reset			=> reset,
			addr_in			=> rom_read_addr,
			valid_in		=> rom_read_ovalid,
			valid_out		=> rom_read_ivalid,
			data_out		=> rom_read_data
				);

	clk <= not(clk) after 10 ns;
	reset <= '1','0' after 30 ns;
	
end arch;

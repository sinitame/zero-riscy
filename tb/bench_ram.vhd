library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library lib_VHDL;
use lib_VHDL.defines.all;

entity bench_ram is
end entity;

architecture arch of bench_ram is

	signal clk		: std_logic := '0';
	signal reset	: std_logic := '0';
	signal addr		: std_logic_vector(31 downto 0) := (others => '0');
	signal rdata	: std_logic_vector(31 downto 0) := (others => '0');
	signal wdata	: std_logic_vector(31 downto 0) := (others => '0');
	signal read_en	: std_logic := '0';
	signal write_en	: std_logic := '0';

begin

	DUT : entity lib_VHDL.RAM
		port map(
			addr_in			=> addr,
			data_in			=> wdata,
			data_out		=> rdata,
			write_en_in		=> write_en,
			read_en_in		=> read_en,
			reset			=> reset,
			clk				=> clk
		);

	clk <= not(clk) after 10 ns;
	reset <= '1','0' after 30 ns;
	
	simulation : process
	begin
		-- TEST READ
		wait until rising_edge(clk);
			addr <= std_logic_vector(to_unsigned(4,32));
			read_en <= '1';
			write_en <= '0';
		-- Test WRITE
		wait until rising_edge(clk);
			addr <= std_logic_vector(to_unsigned(4,32));
			wdata <= std_logic_vector(to_unsigned(10,32));
			write_en <= '1';
			read_en <= '0';
		-- TEST READ
		wait until rising_edge(clk);
			addr <= std_logic_vector(to_unsigned(4,32));
			read_en <= '1';
			write_en <= '0';
	end process simulation;

end arch;

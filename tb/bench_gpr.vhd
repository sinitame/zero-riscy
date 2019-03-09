library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity bench_gpr is
end entity;

library lib_VHDL;
use lib_VHDL.defines.all;

architecture arch of bench_gpr is

	signal clk				: std_logic						:= '0';
	signal rst				: std_logic						:= '0';
	signal raddr_a			: std_logic_vector(4 downto 0)	:= (others => '0');
	signal raddr_b			: std_logic_vector(4 downto 0)	:= (others => '0');
	signal rdata_a			: std_logic_vector(31 downto 0);
	signal rdata_b			: std_logic_vector(31 downto 0);
	signal waddr			: std_logic_vector(4 downto 0)	:= (others => '0');
	signal wdata			: std_logic_vector(31 downto 0)	:= (others => '0');
	signal write_en			: std_logic						:= '0';

begin

	DUT : entity lib_VHDL.GPR
		port map(
				reset				=> rst,
				clk					=> clk,
				raddr_a_in			=> raddr_a,
				raddr_b_in			=> raddr_b,
				waddr_in			=> waddr,
				rdata_a_out			=> rdata_a,
				rdata_b_out			=> rdata_b,
				wdata_in			=> wdata,
				write_en_in			=> write_en
		);


	clk <= not(clk) after 10 ns;
	rst <= '1','0' after 30 ns;

	simulation : process
	begin
		wait for 30 ns;
		wait until rising_edge(clk);
			raddr_a		<= "00001";
			raddr_b		<= "00010";
			waddr		<= "00011";
			wdata		<= std_logic_vector(to_unsigned(10, wdata'length));
			write_en	<= '1';

		wait until rising_edge(clk);
			raddr_a		<= "00011";
			raddr_b		<= "00010";
			waddr		<= "00001";
			wdata		<= std_logic_vector(to_unsigned(11, wdata'length));
			write_en	<= '1';

		wait until rising_edge(clk);
			raddr_a		<= "00011";
			raddr_b		<= "00001";
			waddr		<= "00001";
			wdata		<= std_logic_vector(to_unsigned(12, wdata'length));
			write_en	<= '0';

		wait for 10 ns;
	end process simulation;

end architecture;

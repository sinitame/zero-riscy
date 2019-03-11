library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity bench_decoder is
end entity;

library lib_VHDL;
use lib_VHDL.defines.all;

architecture arch of bench_decoder is

	signal clk				: std_logic						:= '0';
	signal rst				: std_logic						:= '0';
	signal instruction		: std_logic_vector(31 downto 0)	:= (others => '0');
	signal rA				: std_logic_vector(4 downto 0)	:= (others => '0');
	signal rB				: std_logic_vector(4 downto 0)	:= (others => '0');
	signal rC				: std_logic_vector(4 downto 0)	:= (others => '0');
	signal imm				: std_logic_vector(31 downto 0)	:= (others => '0');
	signal operator			: std_logic_vector(5 downto 0)	:= (others => '0');
	signal write_en			: std_logic						:= '0';
	signal imm_en			: std_logic						:= '0';

begin

	DUT : entity lib_VHDL.decoder
		port map(
				reset				=> rst,
				instruction_in		=> instruction,
				rA_out				=> rA,
				rB_out				=> rB,
				rC_out				=> rC,
				imm_out				=> imm,
				operator_out		=> operator,
				write_en_out		=> write_en,
				imm_en_out			=> imm_en
		);


	clk <= not(clk) after 10 ns;
	rst <= '1','0' after 30 ns;

	simulation : process
	begin
		wait until rising_edge(clk);
		-- Test ADD
			instruction <= "0000000"&"00001"&"00010"&"000"&"00011"&"0110011";

		wait until rising_edge(clk);
		-- Test SUB
			instruction <= "0100000"&"00001"&"00010"&"000"&"00011"&"0110011";

		wait until rising_edge(clk);
		-- Test ADDI
			instruction <= "000000000110"&"00001"&"000"&"00011"&"0010011";

		wait for 10 ns;
	end process simulation;

end architecture;

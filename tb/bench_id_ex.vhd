library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity bench_id_ex is
end entity;

library lib_VHDL;
use lib_VHDL.defines.all;

architecture arch of bench_id_ex is

	signal clk		: std_logic := '0';
	signal reset	: std_logic := '0';
	signal operator	: std_logic_vector(5 downto 0)	:= "000000";
	signal inst		: std_logic_vector(31 downto 0) := (others => '0');
	signal A		: std_logic_vector(31 downto 0) := (others => '0');
	signal B		: std_logic_vector(31 downto 0) := (others => '0');
	signal result	: std_logic_vector(31 downto 0) := (others => '0');
	signal comp_res	: std_logic := '0';

begin

	DUT1 : entity lib_VHDL.id_stage
		port map(
					clk				=> clk,
					reset			=> reset,
					instruction		=> inst,
					OpA_out			=> A,
					OpB_out			=> B,
					Op_out			=> operator,
					alu_result_in	=> result
				);

	DUT2 : entity lib_VHDL.ALU
		port map(
					operator_in				=> operator,
					operand_a_in			=> A,
					operand_b_in			=> B,
					result_out				=> result,
					comparison_result_out	=> comp_res
				);


	clk <= not(clk) after 10 ns;
	reset <= '1','0' after 30 ns;

	simulation : process
	begin
		wait for 30 ns;
		wait until rising_edge(clk);
		-- Test ADD
			inst <= "0000000"&"00001"&"00010"&"000"&"00011"&"0110011";

		wait until rising_edge(clk);
		-- Test SUB
			inst <= "0100000"&"00001"&"00010"&"000"&"00011"&"0110011";

		wait until rising_edge(clk);
		-- Test ADDI
			inst <= "000000000110"&"00001"&"000"&"00011"&"0010011";

		wait for 10 ns;
	end process simulation;

end architecture;

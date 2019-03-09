library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity bench_alu is
end entity;

library lib_VHDL;
use lib_VHDL.defines.all;

architecture arch of bench_alu is

	signal clk		: std_logic := '0';
	signal reset	: std_logic := '0';
	signal op		: std_logic_vector(5 downto 0)	:= "000000";
	signal A		: std_logic_vector(31 downto 0) := (others => '0');
	signal B		: std_logic_vector(31 downto 0) := (others => '0');
	signal res		: std_logic_vector(31 downto 0) := (others => '0');
	signal comp_res	: std_logic := '0';

begin

	DUT : entity lib_VHDL.ALU
		port map(
				operator_in				=> op,
				operand_a_in			=> A,
				operand_b_in			=> B,
				result_out				=> res,
				comparison_result_out	=> comp_res
		);


	clk <= not(clk) after 10 ns;
	reset <= '1','0' after 30 ns;

	simulation : process
	begin
		A <= "00000000000000000000000000000001";
		B <= "00000000000000000000000000000001";
		
		-- Test ADD
		wait until rising_edge(clk);
			op <= TEST_ADD;
		-- Test SUB
		wait until rising_edge(clk);
			op <= TEST_SUB;
		-- Test INC
		wait until rising_edge(clk);
			op <= TEST_INC;
		-- Test DEC
		wait until rising_edge(clk);
			op <= TEST_DEC;

		-- Test AND
		wait until rising_edge(clk);
			op <= TEST_AND;
		-- Test OR
		wait until rising_edge(clk);
			op <= TEST_OR;
		-- Test XOR
		wait until rising_edge(clk);
			op <= TEST_XOR;
		-- Test NOT
		wait until rising_edge(clk);
			op <= TEST_NOT;
		-- Test SHIFT LEFT
		wait until rising_edge(clk);
			op <= TEST_SHIFT;

		wait for 10 ns;
	end process simulation;

end architecture;

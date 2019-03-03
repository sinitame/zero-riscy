library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity bench_alu is
end entity;

architecture arch of bench_alu is

	signal clk		: std_logic := '0';
	signal reset	: std_logic := '0';
	signal op		: std_logic_vector(3 downto 0) := "0000";
	signal A		: std_logic_vector(31 downto 0) := (others => '0');
	signal B		: std_logic_vector(31 downto 0) := (others => '0');
	signal res		: std_logic_vector(31 downto 0) := (others => '0');

begin

	DUT : entity work.ALU
		port map(
				clk						=> clk,
				reset					=> reset,
				operator_in				=> op,
				operand_a_in			=> A,
				operand_b_in			=> B,
				result_out				=> res
		);


	clk <= not(clk) after 10 ns;
	reset <= '1','0' after 45 ns;

	simulation : process
	begin
		A <= "00000000000000000000000000000001";
		B <= "00000000000000000000000000000001";
		
		-- Test ADD
		wait until rising_edge(clk);
			op <= "0000";
		-- Test SUB
		wait until rising_edge(clk);
			op <= "0001";
		-- Test INC
		wait until rising_edge(clk);
			op <= "0010";
		-- Test DEC
		wait until rising_edge(clk);
			op <= "0011";

		-- Test AND
		wait until rising_edge(clk);
			op <= "0100";
		-- Test OR
		wait until rising_edge(clk);
			op <= "0101";
		-- Test XOR
		wait until rising_edge(clk);
			op <= "0110";
		-- Test NOT
		wait until rising_edge(clk);
			op <= "0111";

		wait for 10 ns;
	end process simulation;

end architecture;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity bench_controller is
end entity;

library lib_VHDL;
use lib_VHDL.defines.all;

architecture arch of bench_controller is

	signal clk				: std_logic := '0';
	signal reset			: std_logic := '0';
	signal opcode			: std_logic_vector(6 downto 0)	:= "0000000";
	signal jump_ex			: std_logic := '0';
	signal branch_ex		: std_logic := '0';
	signal branch_decision  : std_logic := '0';
	signal pc_boot			: std_logic := '0';
	signal next_pc			: std_logic := '0';
	signal mux_pc			: std_logic_vector(1 downto 0) := (others => '0');
	signal fetch_hit	    : std_logic := '0';
	signal mem_hit			: std_logic := '0';

begin

	DUT : entity lib_VHDL.controller
		port map(
			clk					=> clk,
			reset				=> reset,
			opcode_in			=> opcode,
			jump_ex_out			=> jump_ex,
			branch_ex_out		=> branch_ex,
			branch_decision_in	=> branch_decision,
			pc_boot_out			=> pc_boot,
			next_pc_out			=> next_pc,
			mux_pc_out			=> mux_pc,
			fetch_hit_in		=> fetch_hit,
			mem_hit_in			=> mem_hit
		);


	clk <= not(clk) after 10 ns;
	reset <= '1','0' after 30 ns;

	simulation : process
	begin
		wait for 30 ns;
		-- Test ONE cycle operation
		wait until rising_edge(clk);
			fetch_hit <= '1' ;
		wait until rising_edge(clk);
			opcode <= OPCODE_OP_REG;
			fetch_hit <= '0';

		-- Test LOAD/STORE hit
		wait until rising_edge(clk);
			fetch_hit <= '1' ;
		wait until rising_edge(clk);
			opcode <= OPCODE_STORE;
			mem_hit <= '1';
			fetch_hit <= '0';
		wait until rising_edge(clk);
			mem_hit <= '0';

		-- Test LOAD/STORE miss
		wait until rising_edge(clk);
			fetch_hit <= '1' ;
		wait until rising_edge(clk);
			opcode <= OPCODE_STORE;
			fetch_hit <= '0';
		wait for 40 ns;
		wait until rising_edge(clk);
			mem_hit <= '1';
		wait until rising_edge(clk);
			mem_hit <= '0';

		-- Test Jump
		wait until rising_edge(clk);
			fetch_hit <= '1' ;
		wait until rising_edge(clk);
			opcode <= OPCODE_JAL;
			fetch_hit <= '0';
		wait until rising_edge(clk);

		-- Test Branch succed
		wait until rising_edge(clk);
			fetch_hit <= '1' ;
		wait until rising_edge(clk);
			opcode <= OPCODE_BRANCH;
			branch_decision <= '1';
			fetch_hit <= '0';
		wait until rising_edge(clk);
			branch_decision <= '0';

		-- Test Branch not succeed
		wait until rising_edge(clk);
			fetch_hit <= '1' ;
		wait until rising_edge(clk);
			opcode <= OPCODE_BRANCH;
			branch_decision <= '0';
			fetch_hit <= '0';

		wait for 20 ns;
	end process simulation;

end architecture;

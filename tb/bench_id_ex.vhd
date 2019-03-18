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

	signal instruction	: std_logic_vector(31 downto 0) := (others => '0');
	signal pc		: std_logic_vector(31 downto 0) := (others => '0');
	signal next_pc	: std_logic := '0';
	signal mux_pc	: std_logic_vector(1 downto 0);
	signal pc_boot	: std_logic := '0';
	signal fetch_hit: std_logic := '0';

	signal operator	: std_logic_vector(5 downto 0)	:= "000000";
	signal A		: std_logic_vector(31 downto 0) := (others => '0');
	signal B		: std_logic_vector(31 downto 0) := (others => '0');
	signal result	: std_logic_vector(31 downto 0) := (others => '0');
	signal comp_res	: std_logic := '0';

	signal mem_data	: std_logic_vector(31 downto 0) := (others => '0');
	signal load_en	: std_logic := '0';
	signal store_en	: std_logic := '0';
	signal mem_hit	: std_logic := '0';
	signal wdata	: std_logic_vector(31 downto 0) := (others => '0');

begin

	DUT1 : entity lib_VHDL.id_stage
		port map(
					clk				=> clk,
					reset			=> reset,
					instruction		=> instruction,
					pc_in			=> pc,
					next_pc_out		=> next_pc,
					mux_pc_out		=> mux_pc,
					pc_boot_out		=> pc_boot,
					fetch_hit_in	=> fetch_hit,
					OpA_out			=> A,
					OpB_out			=> B,
					Op_out			=> operator,
					alu_result_in	=> result,
					branch_decision_in => comp_res,
					mem_data_in		=> mem_data,
					load_en_out		=> load_en,
					store_en_out	=> store_en,
					wdata_out		=> wdata,
					mem_hit_in		=> mem_hit
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
		wait for 20 ns;
	
		pc <= std_logic_vector(to_unsigned(15,32));
		fetch_hit <= '1';

		wait until rising_edge(clk);
		-- Test ADD (OP:ADD, RA:4, RB:2, RC:8)
			instruction <= "0000000"&"00100"&"00010"&"000"&"01000"&"0110011";

		wait until rising_edge(clk);
		-- Test SUB (OP:SUB, RA: 2, RB: 1, RC: 3)
			instruction <= "0100000"&"00001"&"00010"&"000"&"00011"&"0110011";

		wait until rising_edge(clk);
		-- Test ADDI (OP: ADD, RA: 1, IMM: 6, RC: 3)
			instruction <= "000000000110"&"00001"&"000"&"00011"&"0010011";

		wait until rising_edge(clk);
		-- Test JAL (RA: x, RB: x, RC:3, IMM: 7)
			instruction <= "00000000000000000111"&"00011"&"1101111";
		wait until rising_edge(clk);
	
		wait until rising_edge(clk);
		-- Test JALR (RA:4, RB:x, RC:3, IMM: 1)
			instruction <= "000000000001"&"00100"&"000"&"00011"&"1100111";
		wait until rising_edge(clk);

		wait until rising_edge(clk);
		-- Test Branch OK (RA: 6, RB: 8, RC: x, IMM =7 )
			instruction <= "0000000"&"00110"&"01000"&"000"&"00111"&"1100011";
		wait until rising_edge(clk);
		
		wait until rising_edge(clk);
		-- Test Branch not OK (RA: 4, RB:3, RC:x, IMM=7)
			instruction <= "0000000"&"00011"&"00100"&"000"&"00011"&"1100011";
		wait until rising_edge(clk);


		wait for 10 ns;
	end process simulation;

end architecture;

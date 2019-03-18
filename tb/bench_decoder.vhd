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
	signal mux_a			: std_logic_vector(1 downto 0)	:= (others => '0');
	signal mux_b			: std_logic_vector(1 downto 0)	:= (others => '0');
	signal jump_ex			: std_logic						:= '0';
	signal branch_ex		: std_logic						:= '0';

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
				mux_a_out			=> mux_a,
				mux_b_out			=> mux_b,
				jump_ex_in			=> jump_ex,
				branch_ex_in		=> branch_ex
		);


	clk <= not(clk) after 10 ns;
	rst <= '1','0' after 30 ns;

	simulation : process
	begin
		wait for 30 ns;
		wait until rising_edge(clk);
		-- Test ADD (OP:ADD, R1:
			jump_ex <= '0';
			branch_ex <= '0';
			instruction <= "0000000"&"00001"&"00010"&"000"&"00011"&"0110011";

		wait until rising_edge(clk);
		-- Test SUB
			jump_ex <= '0';
			branch_ex <= '0';
			instruction <= "0100000"&"00001"&"00010"&"000"&"00011"&"0110011";

		wait until rising_edge(clk);
		-- Test ADDI
			jump_ex <= '0';
			branch_ex <= '0';
			instruction <= "000000000110"&"00001"&"000"&"00011"&"0010011";

		wait until rising_edge(clk);
		-- Test JAL (RA: x, RB: x, RC:3, IMM: 7)
			jump_ex <= '0';
			branch_ex <= '0';
			instruction <= "00000000000000000111"&"00011"&"1101111";
		wait until rising_edge(clk);
			jump_ex <= '1';
	
		wait until rising_edge(clk);
		-- Test JALR (RA:4, RB:x, RC:3, IMM: 1)
			jump_ex <= '0';
			branch_ex <= '0';
			instruction <= "000000000001"&"00100"&"000"&"00011"&"1100111";
		wait until rising_edge(clk);
			jump_ex <= '1';

		wait until rising_edge(clk);
		-- Test Branch OK (RA: 1, RB:4, RC: x, IMM =3 )
			jump_ex <= '0';
			branch_ex <= '0';
			instruction <= "0000000"&"00001"&"00100"&"000"&"00011"&"1100011";
		wait until rising_edge(clk);
			branch_ex <= '1';
		
		wait until rising_edge(clk);
		-- Test Branch not OK (RA: 3, RB:4, RC:x, IMM=7)
			jump_ex <= '0';
			branch_ex <= '0';
			instruction <= "0000000"&"00011"&"00100"&"000"&"00111"&"1100011";
		wait until rising_edge(clk);
			branch_ex <= '0';


		wait for 10 ns;

	end process simulation;

end architecture;

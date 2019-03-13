library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity bench_id_ex_ls is
end entity;

library lib_VHDL;
use lib_VHDL.defines.all;

architecture arch of bench_id_ex_ls is
	signal clk		: std_logic := '0';
	signal reset	: std_logic := '0';
	signal operator	: std_logic_vector(5 downto 0)	:= "000000";
	signal inst		: std_logic_vector(31 downto 0) := (others => '0');
	signal A		: std_logic_vector(31 downto 0) := (others => '0');
	signal B		: std_logic_vector(31 downto 0) := (others => '0');
	signal result	: std_logic_vector(31 downto 0) := (others => '0');
	signal mem_data	: std_logic_vector(31 downto 0) := (others => '0');
	signal rdata	: std_logic_vector(31 downto 0) := (others => '0');
	signal wdata	: std_logic_vector(31 downto 0) := (others => '0');
	signal addr		: std_logic_vector(31 downto 0) := (others => '0');
	signal comp_res	: std_logic := '0';
	signal load_en	: std_logic := '0';
	signal store_en	: std_logic := '0';
begin

	ID_STAGE : entity lib_VHDL.id_stage
		port map(
			clk				=> clk,
			reset			=> reset,
			instruction		=> inst,
			OpA_out			=> A,
			OpB_out			=> B,
			Op_out			=> operator,
			alu_result_in	=> result,
			mem_data_in		=> mem_data,
			load_en_out		=> load_en,
			store_en_out	=> store_en
				);

	EX_STAGE : entity lib_VHDL.alu
		port map(
			operator_in				=> operator,
			operand_a_in			=> A,
			operand_b_in			=> B,
			result_out				=> result,
			comparison_result_out	=> comp_res
				);

	LOAD_STORE : entity lib_vhdl.lsu
		port map(
			clk				=> clk,
			reset			=> reset,
			addr_out		=> addr,
			rdata_in		=> rdata,
			wdata_out		=> wdata,
			alu_result_in	=> result,
			register_data_in=> B,
			rdata_out		=> mem_data,
			load_en_in		=> load_en,
			store_en_in		=> store_en
				);

	RAM : entity lib_vhdl.ram
		port map(
			addr_in			=> addr,
			data_in			=> wdata,
			data_out		=> rdata,
			write_en_in		=> store_en,
			read_en_in		=> load_en,
			reset			=> reset,
			clk				=> clk
				);
	
	clk <= not(clk) after 10 ns;
	reset <= '1','0' after 30 ns;

	simulation : process
	begin
		wait for 30 ns;
		wait until rising_edge(clk);
		-- Test ADD R2,R1 -> R7 (R7 = 1+2=3)
			inst <= "0000000"&"00001"&"00010"&"000"&"00111"&"0110011";

		wait until rising_edge(clk);
		-- Test SUB R2,R7 -> R3 (R3 = 2-3=-1)
			inst <= "0100000"&"00111"&"00010"&"000"&"00011"&"0110011";

		wait until rising_edge(clk);
		-- Test LOAD R2 <- RAM(R1+2) (R2 = RAM(2+1))
			inst <= "000000000010"&"00001"&"000"&"00010"&"0000011";

		wait until rising_edge(clk);
		-- Test STORE RAM(R4+3) <- R1 (RAM(7) = 1)
			inst <= "0000000"&"00001"&"00100"&"000"&"00011"&"0100011";
		
		wait for 10 ns;
	end process simulation;

	
end arch;

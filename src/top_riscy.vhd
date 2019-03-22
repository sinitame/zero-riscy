library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library lib_VHDL;
use lib_VHDL.defines.all;

entity top_riscy is
	port(
			clk					: in std_logic;
			reset				: in std_logic;

			rom_read_addr_out		: out std_logic_vector(31 downto 0);
			rom_read_valid_out		: out std_logic;
			rom_read_valid_in		: in std_logic;
			rom_read_data_in		: in std_logic_vector(31 downto 0);

			mem_addr_out			: out std_logic_vector(31 downto 0);
			mem_read_data_in		: in std_logic_vector(31 downto 0);
			mem_write_data_out		: out std_logic_vector(31 downto 0);
			mem_read_en_out			: out std_logic;
			mem_write_en_out		: out std_logic


		);
end top_riscy;

architecture arch of top_riscy is

	-- Signals to/from IF stage	
	signal instruction	: std_logic_vector(31 downto 0) := (others => '0');
	signal pc		: std_logic_vector(31 downto 0) := (others => '0');
	signal pc_en	: std_logic := '0';
	signal pc_mux	: std_logic_vector(1 downto 0);
	signal pc_boot	: std_logic := '0';
	signal fetch_hit: std_logic := '0';

	-- Signals from/to ALU
	signal operator	: std_logic_vector(5 downto 0)	:= "000000";
	signal A		: std_logic_vector(31 downto 0) := (others => '0');
	signal B		: std_logic_vector(31 downto 0) := (others => '0');
	signal result	: std_logic_vector(31 downto 0) := (others => '0');
	signal comp_res	: std_logic := '0';

	-- Signals from/to LSU
	signal mem_data	: std_logic_vector(31 downto 0) := (others => '0');
	signal load_en	: std_logic := '0';
	signal store_en	: std_logic := '0';
	signal mem_hit	: std_logic := '0';
	signal register_data: std_logic_vector(31 downto 0) := (others => '0');

begin

	IF_STAGE : entity lib_vhdl.if_stage
		port map(
			clk				=> clk,						--
			reset			=> reset,					--
			read_addr_out	=> rom_read_addr_out,		--
			read_valid_out	=> rom_read_valid_out,		--
			read_valid_in	=> rom_read_valid_in,		--
			read_data_in	=> rom_read_data_in,		--
			branch_target_in=> result,
			pc_mux_in		=> pc_mux,					--
			pc_en_in		=> pc_en,					--
			instruction_out	=> instruction,				--
			pc_out			=> pc,
			fetch_hit_out	=> fetch_hit				--
				);

	ID_STAGE : entity lib_VHDL.id_stage
		port map(
			clk				=> clk,						--
			reset			=> reset,					--
			instruction		=> instruction,				--
			OpA_out			=> A,						--
			OpB_out			=> B,						--
			Op_out			=> operator,				--
			next_pc_out		=> pc_en,
			mux_pc_out		=> pc_mux,
			pc_in			=> pc,
			fetch_hit_in	=> fetch_hit,
			mem_hit_in		=> mem_hit,
			alu_result_in	=> result,					--
			branch_decision_in => comp_res,				--
			mem_data_in		=> mem_data,				--
			wdata_out		=> register_data,			--
			load_en_out		=> load_en,					--
			store_en_out	=> store_en					--
				);

	EX_STAGE : entity lib_VHDL.alu
		port map(
			operator_in				=> operator,		--
			operand_a_in			=> A,				--
			operand_b_in			=> B,				--
			result_out				=> result,			--
			comparison_result_out	=> comp_res			--
				);

	LOAD_STORE : entity lib_vhdl.lsu
		port map(
			clk				=> clk,						--
			reset			=> reset,					--
			addr_out		=> mem_addr_out,
			rdata_in		=> mem_read_data_in,
			wdata_out		=> mem_write_data_out,
			alu_result_in	=> result,					--
			register_data_in=> register_data,			--
			rdata_out		=> mem_data,				--
			mem_hit_out		=> mem_hit,
			load_en_in		=> load_en,					--
			store_en_in		=> store_en					--
				);

	mem_write_en_out <= store_en;
	mem_read_en_out <= load_en;

end arch;

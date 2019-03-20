library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity bench_if_stage is
end entity;

library lib_VHDL;
use lib_VHDL.defines.all;

architecture arch of bench_if_stage is
	signal clk				: std_logic := '0';
	signal reset			: std_logic := '0';
	signal instruction		: std_logic_vector(31 downto 0) := (others => '0');
	signal branch_target	: std_logic_vector(31 downto 0) := (others => '0');
	signal raddr			: std_logic_vector(31 downto 0) := (others => '0');
	signal rdata			: std_logic_vector(31 downto 0) := (others => '0');
	signal pc_mux			: std_logic_vector(1 downto 0) := (others => '0');
	signal pc_en			: std_logic := '0';
	signal rvalid_addr		: std_logic := '0';
	signal rvalid_data		: std_logic := '0';
	signal fetch_hit		: std_logic := '0';
	signal rvalid			: std_logic := '0';
begin
	IF_STAGE : entity lib_vhdl.if_stage
		port map(
			clk				=> clk,
			reset			=> reset,
			read_addr_out	=> raddr,
			read_valid_out	=> rvalid_addr,
			read_valid_in	=> rvalid_data,
			read_data_in	=> rdata,
			branch_target_in=> branch_target,
			pc_mux_in		=> pc_mux,
			pc_en_in		=> pc_en,
			instruction_out	=> instruction,
			fetch_hit_out	=> fetch_hit
				);

	ROM : entity lib_vhdl.rom
		port map(
			clk				=> clk,
			reset			=> reset,
			addr_in			=> raddr,
			valid_in		=> rvalid_addr,
			valid_out		=> rvalid_data,
			data_out		=> rdata
				);
	
	clk <= not(clk) after 10 ns;
	reset <= '1','0' after 30 ns;

	simulation : process
	begin
		wait for 20 ns;
		wait until rising_edge(clk);
			pc_en <= '1';
			pc_mux <= PC_BOOT;

		wait until rising_edge(clk);
			pc_mux <= PC_INC;
		
		wait until rising_edge(clk);
			pc_mux <= PC_INC;

		wait until rising_edge(clk);
			branch_target <= std_logic_vector(to_unsigned(20, 32));
			pc_mux <= PC_JUMP;
		
		wait until rising_edge(clk);
			pc_mux <= PC_INC;
		
		wait until rising_edge(clk);
			pc_mux <= PC_BOOT;

		wait until rising_edge(clk);
			pc_en <= '0';
		wait for 20 ns;
	end process;


end arch;

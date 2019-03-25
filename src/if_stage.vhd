library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.defines.all;

entity if_stage is
	port(
			clk					: in std_logic;
			reset				: in std_logic;
			read_addr_out		: out std_logic_vector(31 downto 0);
			read_valid_out		: out std_logic;
			read_valid_in		: in std_logic;
			read_data_in		: in std_logic_vector(31 downto 0);

			branch_target_in	: in std_logic_vector(31 downto 0);
			pc_mux_in			: in std_logic_vector(1 downto 0);
			pc_en_in			: in std_logic;

			instruction_out		: out std_logic_vector(31 downto 0);
			pc_out				: out std_logic_vector(31 downto 0);
			fetch_hit_out		: out std_logic
		);
end if_stage;

architecture arch of if_stage is
	signal pc_address	: std_logic_vector(31 downto 0);
	signal pc_valid		: std_logic;
	signal instruction	: std_logic_vector(31 downto 0);

begin

	PC : entity work.pc
		port map(
			clk					=> clk,
			reset				=> reset,
			pc_out				=> pc_address,
			branch_target_in	=> branch_target_in,
			pc_mux_in			=> pc_mux_in,
			pc_en_in			=> pc_en_in,
			pc_valid_out		=> pc_valid
				);

	FETCH : entity work.fetch
		port map(
			read_addr_out	=> read_addr_out,
			read_valid_out	=> read_valid_out,
			read_valid_in	=> read_valid_in,
			read_data_in	=> read_data_in,
							
			data_out		=> instruction,
			fetch_hit_out	=> fetch_hit_out,
			addr_in			=> pc_address,
			pc_valid_in		=> pc_valid
				);
	

	if_to_id_register : process(clk, pc_valid)
	begin
		if rising_edge(clk) and pc_valid = '1'  then
			instruction_out <= instruction;
			pc_out			<= pc_address;
		end if;
	end process;
	

end arch;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library lib_VHDL;
use lib_VHDL.defines.all;

entity PC is
	port(
			clk					: in std_logic;
			reset				: in std_logic;
			pc_out				: out std_logic_vector(31 downto 0);
			branch_target_in	: in std_logic_vector(31 downto 0);
			pc_mux_in			: in std_logic_vector(1 downto 0);
			pc_en_in			: in std_logic;
			pc_valid_out		: out std_logic
		);
end PC;

architecture arch of PC is
	signal new_pc_addr	: std_logic_vector(31 downto 0) := (others => '0');
	signal pc_valid		: std_logic;
	signal pc_addr		: std_logic_vector(31 downto 0);
begin

	pc_mux : process(pc_mux_in, pc_addr)
	begin
		case pc_mux_in is
			when PC_INC => 
				new_pc_addr <= std_logic_vector(unsigned(pc_addr)+1);
			when PC_BOOT =>
				new_pc_addr <= (others => '0');
			when PC_JUMP =>
				new_pc_addr <= branch_target_in;
			when others =>
		end case;
	end process pc_mux;

	new_pc : process(clk, reset, pc_en_in,new_pc_addr)
	begin
		if reset = '1' then
			pc_addr <= (others => '0');
			pc_valid <= '0';
		elsif rising_edge(clk) and pc_en_in = '1' then
			pc_addr <= new_pc_addr;
			pc_valid <= '1';
		elsif rising_edge(clk) and pc_en_in = '0' then
			pc_valid <= '0';
		end if;
	end process;

	pc_valid_out <= pc_en_in;
	pc_out <= new_pc_addr;

	end arch;

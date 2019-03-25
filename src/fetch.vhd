library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.defines.all;

entity fetch is
	port(
			read_addr_out		: out std_logic_vector(31 downto 0);
			read_valid_in		: in std_logic;
			read_data_in		: in std_logic_vector(31 downto 0);
			read_valid_out		: out std_logic;

			data_out			: out std_logic_vector(31 downto 0);
			fetch_hit_out		: out std_logic;
			addr_in				: in std_logic_vector(31 downto 0);
			pc_valid_in			: in std_logic
		);
end fetch;

architecture arch of fetch is
begin


	read_addr_out <= addr_in;
	data_out <= read_data_in;
	fetch_hit_out <= read_valid_in;
	read_valid_out <= pc_valid_in;

end arch;

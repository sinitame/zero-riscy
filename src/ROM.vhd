library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ROM is
	port (
			 clk		: in  std_logic;
			 addr_in	: in  std_logic_vector(31 downto 0);
			 data_out	: out std_logic_vector(31 downto 0)
		 );
end entity ROM;

architecture arch of ROM is

	constant low_addr  : natural := 0;
	constant high_addr : natural := 2**7-1;

	type type_rom is array (low_addr to high_addr-1) of std_logic_vector(31 downto 0);
	constant mem_rom : type_rom := (
		0 => "0000000"&"00001"&"00010"&"000"&"00011"&"0110011",
		1 => "0100000"&"00001"&"00010"&"000"&"00011"&"0110011",
		2 => "000000000110"&"00001"&"000"&"00011"&"0010011",
		others => x"00000000"
	);

begin
	process(clk)
	begin
		if rising_edge(clk) then
			data_out <= mem_rom(to_integer(unsigned(addr_in)));
		end if;
	end process;


end architecture;

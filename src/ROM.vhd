library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ROM is
	port (
			clk		: in  std_logic;
			reset	: in std_logic;
			addr_in	: in  std_logic_vector(31 downto 0);
			valid_in: in std_logic;
			valid_out: out std_logic;
			data_out: out std_logic_vector(31 downto 0)
		 );
end entity ROM;

architecture arch of ROM is

	constant low_addr  : natural := 0;
	constant high_addr : natural := 2**7-1;

	constant inst1 : std_logic_vector(31 downto 0) := "0000000"&"00001"&"00010"&"000"&"00011"&"0110011";
	constant inst2 : std_logic_vector(31 downto 0) := "0100000"&"00001"&"00010"&"000"&"00010"&"0110011";
	constant inst3 : std_logic_vector(31 downto 0) := "000000000110"&"00001"&"000"&"00011"&"0010011";

	type type_rom is array (low_addr to high_addr-1) of std_logic_vector(31 downto 0);
	constant mem_rom : type_rom := (
	
	0 => inst1,
	1 => inst2,
	2 => inst3,
	others => (others => '0'));

begin
	process(clk)
	begin
		if reset = '1' then
			data_out <= (others => '0');
			valid_out <= '0';
		elsif rising_edge(clk) and valid_in = '1' then
			data_out <= mem_rom(to_integer(unsigned(addr_in)));
			valid_out <= '1';
		elsif rising_edge(clk) then
			valid_out <= '0';
		end if;

	end process;


end architecture;

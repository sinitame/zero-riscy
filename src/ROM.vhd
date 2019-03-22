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

	-- Test ADD (OP:ADD, RA:4, RB:2, RC:8)
	constant inst1 : std_logic_vector(31 downto 0) := "0000000"&"00100"&"00010"&"000"&"01000"&"0110011";

	-- Test SUB (OP:SUB, RA: 2, RB: 1, RC: 3)
	constant inst2 : std_logic_vector(31 downto 0) := "0100000"&"00001"&"00010"&"000"&"00011"&"0110011";

	-- Test ADDI (OP: ADD, RA: 1, IMM: 6, RC: 3)
	constant inst3 : std_logic_vector(31 downto 0) := "000000000110"&"00001"&"000"&"00011"&"0010011";

	-- Test JAL (RA: x, RB: x, RC:5, IMM: -1)
	--constant inst4 : std_logic_vector(31 downto 0) := "00000000000000000011"&"00011"&"1101111";

	-- Test JALR (RA:4, RB:x, RC:3, IMM: 3)
	--constant inst4 : std_logic_vector(31 downto 0) := "000000000011"&"00100"&"000"&"00011"&"1100111";

	-- Test Branch OK (RA: 6, RB: 8, RC: x, IMM =7 )
	--constant inst5 : std_logic_vector(31 downto 0) := "0000000"&"00110"&"01000"&"000"&"00111"&"1100011";
	
	-- Test Branch not OK (RA: 4, RB:3, RC:x, IMM=7)
	constant inst6 : std_logic_vector(31 downto 0) := "0000000"&"00011"&"00100"&"000"&"00011"&"1100011";


	type type_rom is array (low_addr to high_addr-1) of std_logic_vector(31 downto 0);
	constant mem_rom : type_rom := (
	
	0 => inst1,
	1 => inst2,
	2 => inst3,
	--3 => inst4,
	--4 => inst5,
	5 => inst6,
	--6 => inst7,
	others => (others => '0'));

begin
	data_reg : process(clk)
	begin
		if reset = '1' then
			data_out <= (others => '0');
		elsif rising_edge(clk) and valid_in = '1' then
			data_out <= mem_rom(to_integer(unsigned(addr_in)));
		end if;

	end process;

	process(valid_in)
	begin
		if valid_in = '1' then
			valid_out <= '1';
		else
			valid_out <= '0';
		end if;
	end process;


end architecture;

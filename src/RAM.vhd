library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RAM is
	port (
			 addr_in		: in  std_logic_vector (31 downto 0);
			 data_in		: in  std_logic_vector (31 downto 0);
			 data_out		: out std_logic_vector (31 downto 0);
			 write_en_in	: in  std_logic;
			 read_en_in		: in  std_logic;
			 reset			: in  std_logic;
			 clk			: in  std_logic
		 );
end entity RAM;

architecture arch of RAM is

	-- RAM 32 x 4 Bytes.
	constant low_address  : natural := 0;
	constant high_address : natural := 2**5-1;

	type type_mem is array (low_address to high_address) of std_logic_vector(31 downto 0);
	signal mem_ram : type_mem;

begin
	process(addr_in, read_en_in)
	begin
		if (read_en_in = '1') then
			data_out <= mem_ram(to_integer(unsigned(addr_in)));
		else
			data_out <= (others => '0');
		end if;
	end process;

	process(reset, addr_in, write_en_in,clk)
	begin
		if reset = '1' then
			for i in 0 to 31 loop
				mem_ram(i) <= std_logic_vector(to_signed(i,32));
			end loop;
		elsif rising_edge(clk) then
			if (write_en_in = '1') then
				mem_ram(to_integer(unsigned(addr_in))) <= data_in;
			end if;
		end if;
	end process;

end arch;


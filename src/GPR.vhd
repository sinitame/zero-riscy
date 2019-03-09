library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity GPR is
	generic(
			GPR_WIDTH	: natural := 5
		);
	port(
			clk			: in std_logic;
			reset		: in std_logic;

			
			raddr_a_in	: in std_logic_vector(GPR_WIDTH-1 downto 0);
			rdata_a_out	: out std_logic_vector(31 downto 0);

			raddr_b_in	: in std_logic_vector(GPR_WIDTH-1 downto 0);
			rdata_b_out	: out std_logic_vector(31 downto 0);

			waddr_in	: in std_logic_vector(GPR_WIDTH-1 downto 0);
			wdata_in	: in std_logic_vector(31 downto 0);
			write_en_in	: in std_logic
		 );

end GPR;

architecture arch of GPR is

	type   type_GPR is array (0 to 15) of std_logic_vector(31 downto 0);
	signal registers : type_GPR;


begin

	write_data : process(clk,reset)
	begin
		if reset = '1' then
			for i in 0 to 15 loop
				registers(i) <= std_logic_vector(to_unsigned(i,32));
			end loop;
		elsif rising_edge(clk) then
			if write_en_in = '1' then
				registers(to_integer(unsigned(waddr_in))) <= wdata_in;
			end if;
		end if;
	end process;

	rdata_a_out <= registers(to_integer(unsigned(raddr_a_in)));
	rdata_b_out <= registers(to_integer(unsigned(raddr_b_in)));

end arch;

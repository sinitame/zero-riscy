library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity ALU is
	generic(
			ALU_OP_WIDTH			: natural := 4
		);
	port(
			clk						: in std_logic;
			reset					: in std_logic;

			operator_in				: in std_logic_vector(ALU_OP_WIDTH-1 downto 0);
			operand_a_in			: in std_logic_vector(31 downto 0);
			operand_b_in			: in std_logic_vector(31 downto 0);

			adder_result_out		: out std_logic_vector(31 downto 0);
			add_result_ext_out		: out std_logic_vector(33 downto 0);

			result_out				: out std_logic_vector(31 downto 0);
			comparison_result_out	: out std_logic;
			is_equal_result_out		: out std_logic
		);
end ALU;

architecture arch of ALU is

	constant ADD	: std_logic_vector(ALU_OP_WIDTH-1 downto 0) := "0000";
	constant SUB	: std_logic_vector(ALU_OP_WIDTH-1 downto 0) := "0001";
	constant INC	: std_logic_vector(ALU_OP_WIDTH-1 downto 0) := "0010";
	constant DEC	: std_logic_vector(ALU_OP_WIDTH-1 downto 0) := "0011";
	signal static_op : std_logic_vector(3 downto 0);
	signal result	: signed(32 downto 0);

begin

	static_op <= operator_in;

	calculation: process(clk,operand_a_in,operand_b_in, static_op)
	begin
		if rising_edge(clk) then
			case static_op is
				--------------------------------------------------------------
				------------------ ARITHMETIC OPERATIONS ---------------------
				--------------------------------------------------------------
				when "0000" => result <= signed('0' & operand_a_in) + signed('0' & operand_b_in);
				when "0001" => result <= signed('0' & operand_a_in) - signed('0' & operand_b_in);
				when "0010" => result <= signed('0' & operand_a_in) + 1;
				when "0011" => result <= signed('0' & operand_a_in) - 1;
				
				--------------------------------------------------------------
				--------------------- LOGIC OPERATIONS -----------------------
				--------------------------------------------------------------


				--------------------------------------------------------------
				---------------------- SHIFT OPERATIONS ----------------------
				--------------------------------------------------------------
				
				when others => result <= "000000000000000000000000000000000";
			end case;
		end if;
	end process calculation;

	result_out <= std_logic_vector(result(31 downto 0));
end arch;


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

			multdiv_operand_a_in	: in std_logic_vector(32 downto 0);
			multdiv_operand_b_in	: in std_logic_vector(32 downto 0);

			adder_result_out		: out std_logic_vector(31 downto 0);
			add_result_ext_out		: out std_logic_vector(33 downto 0);
			
			result_out				: out std_logic_vector(31 downto 0);
			comparison_result_out	: out std_logic;
			is_equal_result_out		: out std_logic
		);
end ALU;

architecture arch of ALU is
begin

	--------------------------------------------------------------
	------------------- ARITHMETIC UNIT --------------------------
	--------------------------------------------------------------

	--------------------------------------------------------------
	--------------------- LOGIC UNIT -----------------------------
	--------------------------------------------------------------


	--------------------------------------------------------------
	---------------------- SHIFT UNIT ----------------------------
	--------------------------------------------------------------
end arch;


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library lib_VHDL;
use lib_VHDL.defines.all;

entity ALU is
	generic(
			ALU_OP_WIDTH			: natural := 6
		);
	port(
			operator_in				: in std_logic_vector(ALU_OP_WIDTH-1 downto 0);
			operand_a_in			: in std_logic_vector(31 downto 0);
			operand_b_in			: in std_logic_vector(31 downto 0);

			result_out				: out std_logic_vector(31 downto 0);
			comparison_result_out	: out std_logic
		);
end ALU;

architecture arch of ALU is

	signal static_op : std_logic_vector(6-1 downto 0);
	signal result	: signed(32 downto 0) := (others => '0');

begin

	static_op <= operator_in;

	calculation: process(operand_a_in,operand_b_in, static_op)
	begin
		case static_op is
			--------------------------------------------------------------
			------------------ ARITHMETIC OPERATIONS ---------------------
			--------------------------------------------------------------
			when ALU_ADD => result <= signed('0' & operand_a_in) + signed('0' & operand_b_in);
			when ALU_SUB => result <= signed('0' & operand_a_in) - signed('0' & operand_b_in);
			when TEST_INC => result <= signed('0' & operand_a_in) + 1;
			when TEST_DEC => result <= signed('0' & operand_a_in) - 1;
			
			--------------------------------------------------------------
			--------------------- LOGIC OPERATIONS -----------------------
			--------------------------------------------------------------

			when TEST_AND => result <= signed(('0' & operand_a_in) and ('0' & operand_b_in));  -- AND
			when TEST_OR => result <= signed(('0' & operand_a_in) or ('0' & operand_b_in));  -- OR
			when TEST_XOR => result <= signed(('0' & operand_a_in) xor ('0' & operand_b_in));  -- XOR
			when TEST_NOT => result <= signed(not ('0' & operand_a_in));  -- NOT

			--------------------------------------------------------------
			---------------------- SHIFT OPERATIONS ----------------------
			--------------------------------------------------------------
			when TEST_SHIFT => result <= signed(operand_a_in(31 downto 0) & '0');
			when others => result <= "000000000000000000000000000000000";
		end case;
	end process calculation;

	result_out <= std_logic_vector(result(31 downto 0));
end arch;


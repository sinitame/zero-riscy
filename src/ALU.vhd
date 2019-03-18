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
			when ALU_ADD => 
				result <= signed('0' & operand_a_in) + signed('0' & operand_b_in);
				comparison_result_out <= '0';
			when ALU_SUB => 
				result <= signed('0' & operand_a_in) - signed('0' & operand_b_in);
				comparison_result_out <= '0';

			--------------------------------------------------------------
			--------------------- LOGIC OPERATIONS -----------------------
			--------------------------------------------------------------

			when ALU_AND =>
				result <= signed(('0' & operand_a_in) and ('0' & operand_b_in));  -- AND
				comparison_result_out <= '0';
			when ALU_OR =>
				result <= signed(('0' & operand_a_in) or ('0' & operand_b_in));  -- OR
				comparison_result_out <= '0';
			when ALU_XOR =>
				result <= signed(('0' & operand_a_in) xor ('0' & operand_b_in));  -- XOR
				comparison_result_out <= '0';
			when ALU_SLTS =>
				if to_integer(signed(operand_a_in)) < to_integer(signed(operand_b_in)) then
					result <= to_signed(1,33);
				else
					result <= to_signed(0,33);
				end if;
				comparison_result_out <= '0';
			when ALU_SLTU =>
				if to_integer(unsigned(operand_a_in)) < to_integer(unsigned(operand_b_in)) then
					result <= to_signed(1,33);
				else
					result <= to_signed(0,33);
				end if;
				comparison_result_out <= '0';

			--------------------------------------------------------------
			------------------ COMPARISON OPERATIONS ---------------------
			--------------------------------------------------------------

			when  ALU_EQ  => 
				if to_integer(signed(operand_a_in)) = to_integer(signed(operand_b_in)) then
					comparison_result_out <= '1';
					result <= to_signed(1,33);
				else
					comparison_result_out <= '0';
					result <= to_signed(0,33);
				end if;
			when  ALU_NE  =>
				if not (to_integer(signed(operand_a_in)) = to_integer(signed(operand_b_in))) then
					comparison_result_out <= '1';
					result <= to_signed(1,33);
				else
					comparison_result_out <= '0';
					result <= to_signed(0,33);
				end if;
			when  ALU_LTS =>
				if to_integer(signed(operand_a_in)) < to_integer(signed(operand_b_in)) then
					comparison_result_out <= '1';
					result <= to_signed(1,33);
				else
					comparison_result_out <= '0';
					result <= to_signed(0,33);
				end if;
			when  ALU_GES =>
				if (to_integer(signed(operand_a_in)) > to_integer(signed(operand_b_in)))
				or (to_integer(signed(operand_a_in)) = to_integer(signed(operand_b_in))) then
					comparison_result_out <= '1';
					result <= to_signed(1,33);
				else
					comparison_result_out <= '0';
					result <= to_signed(0,33);
				end if;
			when  ALU_LTU =>
				if to_integer(unsigned(operand_a_in)) < to_integer(unsigned(operand_b_in)) then
					comparison_result_out <= '1';
					result <= to_signed(1,33);
				else
					comparison_result_out <= '0';
					result <= to_signed(0,33);
				end if;
			when  ALU_GEU =>
				if (to_integer(unsigned(operand_a_in)) > to_integer(unsigned(operand_b_in)))
				or (to_integer(unsigned(operand_a_in)) = to_integer(unsigned(operand_b_in))) then
					comparison_result_out <= '1';
					result <= to_signed(1,33);
				else
					comparison_result_out <= '0';
					result <= to_signed(0,33);
				end if;
			--------------------------------------------------------------
			---------------------- SHIFT OPERATIONS ----------------------
			--------------------------------------------------------------
			when ALU_SRL =>
				result <= signed(shift_right(unsigned('0' & operand_a_in),to_integer(unsigned(operand_b_in(4 downto 0)))));
				comparison_result_out <= '0';
			when ALU_SLL =>
				result <= signed(shift_left(unsigned('0'& operand_a_in),to_integer(unsigned(operand_b_in(4 downto 0)))));
				comparison_result_out <= '0';
			when ALU_SRA =>
				result <= signed(shift_right(signed('0' & operand_a_in),to_integer(unsigned(operand_b_in(4 downto 0)))));
				comparison_result_out <= '0';
			
			
			when others =>
				result <= "000000000000000000000000000000000";
				comparison_result_out <= '0';
		end case;
	end process calculation;

	result_out <= std_logic_vector(result(31 downto 0));
end arch;


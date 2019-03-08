library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library lib_VHDL;
use lib_VHDL.defines.all;

entity decoder is
	generic(
			   GPR_WIDTH	: natural := 5;
			   ALU_OP_WIDTH	: natural := 6
		   );
	port(
			reset			: in std_logic;
			instruction_in	: in std_logic_vector(31 downto 0);

			rA_out			: out std_logic_vector(GPR_WIDTH-1 downto 0);
			rB_out			: out std_logic_vector(GPR_WIDTH-1 downto 0);
			imm_out			: out std_logic_vector(31 downto 0);
			
			operator_out	: out std_logic_vector(ALU_OP_WIDTH-1 downto 0); 
			write_en_out	: out std_logic;
			imm_en_out		: out std_logic

		);
end decoder;

architecture arch of decoder is
begin

	op_code_parse : process(instruction_in,operator_out,reset)
		variable alu_operation : std_logic_vector(8 downto 0);
		variable opcode : std_logic_vector(6 downto 0);
		variable imm12_complement : std_logic_vector(19 downto 0) := (others => instruction_in(31));
	begin
		if reset = '1' then
			rA_out		<= (others => '0');
			rB_out		<= (others => '0');
			imm_out		<= (others => '0');
			operator_out <= (others => '0');
			write_en_out <= '0';
			imm_en_out <= '0';
		else
			opcode := instruction_in(6 downto 0);
			case opcode is
			--	when OPCODE_LUI =>
			--		-- (LUI) : Load Imm
			--	when OPCODE_JAL =>
			--		-- (JAL) : Unconditionnal jump Imm
			--	when OPCODE_JALR =>
			--		-- (JALR): Unconditionnal jump Reg
			--	when OPCODE_JUMP =>
			--		-- (B) : Conditional Jump
			--	when OPCODE_LOAD =>
			--		-- (L) : Memory load
			--	when OPCODE_STORE =>
			--		-- (S) : Memory store
				when OPCODE_OP_IMM =>
					-- Imm ALU op
					rA_out			<= (others => '0');
					rB_out			<= (others => '0');
					imm_out			<= imm12_complement & instruction_in(31 downto 20);
					imm_en_out		<= '1';
					write_en_out	<= '1';
					
					case instruction_in(14 downto 12)  is
						when  OP_ALU_ADDI	=> operator_out <= ALU_ADD;
						when  OP_ALU_SLTI	=> operator_out <= ALU_SLTS;
						when  OP_ALU_SLTUI	=> operator_out <= ALU_SLTU;
						when  OP_ALU_XORI	=> operator_out <= ALU_XOR;
						when  OP_ALU_ORI	=> operator_out <= ALU_OR;
						when  OP_ALU_ANDI	=> operator_out <= ALU_AND;
						when others => --nothing
					end case;

				when OPCODE_OP_REG =>
					-- Reg ALU op
					rA_out			<= instruction_in(19 downto 15);
					rB_out			<= instruction_in(24 downto 20);
					imm_out			<= (others => '0');
					imm_en_out		<= '0';
					write_en_out	<= '1';

					alu_operation :=  instruction_in(30 downto 25) & instruction_in(14 downto 12);
					case alu_operation is
						when OP_ALU_ADD => operator_out <= ALU_ADD;
						when OP_ALU_SUB => operator_out <= ALU_SUB;
						when OP_ALU_SLL	=> operator_out <= ALU_SLL;
						when OP_ALU_SLT	=> operator_out <= ALU_SLTS;
						when OP_ALU_SLTU=> operator_out <= ALU_SLTU;
						when OP_ALU_XOR	=> operator_out <= ALU_XOR;
						when OP_ALU_SRL	=> operator_out <= ALU_SRL;
						when OP_ALU_SRA	=> operator_out <= ALU_SRA;
						when OP_ALU_OR	=> operator_out <= ALU_OR;
						when OP_ALU_AND	=> operator_out <= ALU_AND;
						when others => --nothing
					end case;

				when others =>
					-- Nothing
					rA_out		<= (others => '0');
					rB_out		<= (others => '0');
					imm_out		<= (others => '0');
					operator_out <= (others => '0');
					write_en_out <= '1';
			end case;
		end if;
	end process op_code_parse;

end arch;

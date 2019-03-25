library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.defines.all;

entity decoder is
	generic(
			   GPR_WIDTH	: natural := 5;
			   ALU_OP_WIDTH	: natural := 6
		   );
	port(
			reset			: in std_logic;
			instruction_in	: in std_logic_vector(31 downto 0);

			-- Signals to GPR
			rA_out			: out std_logic_vector(GPR_WIDTH-1 downto 0);
			rB_out			: out std_logic_vector(GPR_WIDTH-1 downto 0);
			rC_out			: out std_logic_vector(GPR_WIDTH-1 downto 0);
			write_en_out	: out std_logic;

			-- Signals to ALU
			mux_a_out		: out std_logic_vector(1 downto 0);
			mux_b_out		: out std_logic_vector(1 downto 0);
			imm_out			: out std_logic_vector(31 downto 0);
			operator_out	: out std_logic_vector(ALU_OP_WIDTH-1 downto 0);

			jump_ex_in		: in std_logic;
			branch_ex_in	: in std_logic;

			load_en_out		: out std_logic;
			store_en_out	: out std_logic;
			load_imm		: out std_logic

		);
end decoder;

architecture arch of decoder is
begin

	op_code_parse : process(instruction_in,jump_ex_in, branch_ex_in,reset)
		variable alu_operation : std_logic_vector(8 downto 0);
		variable opcode : std_logic_vector(6 downto 0);
		variable imm12_complement : std_logic_vector(19 downto 0);
		variable imm20_complement : std_logic_vector(11 downto 0);
	begin
		if reset = '1' then
			rA_out		<= (others => '0');
			rB_out		<= (others => '0');
			rC_out		<= (others => '0');
			imm_out		<= (others => '0');
			operator_out <= (others => '0');
			write_en_out <= '0';
			mux_a_out <= (others => '0');
			mux_b_out <= (others => '0');
			load_en_out <= '0';
			store_en_out <= '0';
			load_imm <= '0';
		else
			opcode := instruction_in(6 downto 0);
			case opcode is
				when OPCODE_LUI =>
					imm20_complement := (others => instruction_in(31));
					-- (LUI) : Load Imm
					rA_out			<= (others => '0');
					rB_out			<= (others => '0');
					rC_out			<= instruction_in(11 downto 7);
					imm_out			<= imm20_complement & instruction_in(31 downto 12);
					mux_a_out		<= A_ZERO;
					mux_b_out		<= B_IMM;
					write_en_out	<= '1';
					load_en_out		<= '0';
					store_en_out	<= '0';
					load_imm <= '1';
					operator_out	<= ALU_ADD;
				when OPCODE_JAL =>
					imm20_complement := (others => instruction_in(31));
					-- (JAL) : Unconditionnal jump Imm
					if jump_ex_in = '0' then -- rC <- PC+4
						rA_out			<= (others => '0');
						rB_out			<= (others => '0');
						rC_out			<= instruction_in(11 downto 7);
						imm_out			<= (others => '0');
						mux_a_out		<= A_PC;
						mux_b_out		<= B_PC4;
						write_en_out	<= '1';
					else -- PC <- PC + imm12
						rA_out			<= (others => '0');
						rB_out			<= (others => '0');
						rC_out			<= (others => '0');
						imm_out			<= imm20_complement & instruction_in(31 downto 12);
						mux_a_out		<= A_PC;
						mux_b_out		<= B_IMM;
						write_en_out	<= '0';
					end if;
					load_en_out		<= '0';
					store_en_out	<= '0';
					operator_out	<= ALU_ADD;
					load_imm <= '0';

				when OPCODE_JALR =>
					imm12_complement := (others => instruction_in(31));
					-- (JALR): Unconditionnal jump Reg
					if jump_ex_in='0' then -- rC <- PC+4
						rA_out			<= (others => '0');
						rB_out			<= (others => '0');
						rC_out			<= instruction_in(11 downto 7);
						imm_out			<= imm12_complement & instruction_in(31 downto 20);
						mux_a_out		<= A_PC;
						mux_b_out		<= B_PC4;
						write_en_out	<= '1';
					else -- PC <- rA_data + imm12
						rA_out			<= instruction_in(19 downto 15);
						rB_out			<= (others => '0');
						rC_out			<= instruction_in(11 downto 7);
						imm_out			<= imm12_complement & instruction_in(31 downto 20);
						mux_a_out		<= A_REG;
						mux_b_out		<= B_IMM;
						write_en_out	<= '0';
					end if;
					load_en_out		<= '0';
					store_en_out	<= '0';
					load_imm <= '0';
					operator_out	<= ALU_ADD;

				when OPCODE_BRANCH =>
					imm12_complement := (others => instruction_in(31));
					-- (B) : Conditional Jump
					if branch_ex_in = '1' then
						rA_out			<= (others => '0');
						rB_out			<= (others => '0');
						rC_out			<= (others => '0');
						imm_out			<= imm12_complement & instruction_in(31 downto 25) & instruction_in(11 downto 7);
						mux_a_out		<= A_PC;
						mux_b_out		<= B_IMM;
						operator_out	<= ALU_ADD;
					else
						case instruction_in(14 downto 12) is
							when BRANCH_EQ	=> operator_out	<= ALU_EQ; --
							when BRANCH_NE	=> operator_out	<= ALU_NE; --
							when BRANCH_LT	=> operator_out	<= ALU_LTS; --
							when BRANCH_GE	=> operator_out	<= ALU_GES; --
							when BRANCH_LTU	=> operator_out	<= ALU_LTU; --
							when BRANCH_GEU	=> operator_out	<= ALU_GEU; --
							when others		=>
								operator_out <= (others => '0');
						end case;
						rA_out			<= instruction_in(19 downto 15);
						rB_out			<= instruction_in(24 downto 20);
						rC_out			<= (others => '0');
						imm_out			<= (others => '0');
						mux_a_out		<= A_REG;
						mux_b_out		<= B_REG;
					end if;
					write_en_out	<= '0';
					load_en_out		<= '0';
					store_en_out	<= '0';
					load_imm <= '0';

				when OPCODE_LOAD =>
					imm12_complement := (others => instruction_in(31));
					-- (L) : Memory load
					rA_out			<= instruction_in(19 downto 15);
					rB_out			<= (others => '0');
					rC_out			<= instruction_in(11 downto 7);
					imm_out			<= imm12_complement & instruction_in(31 downto 20);
					mux_a_out		<= A_REG;
					mux_b_out		<= B_IMM;
					write_en_out	<= '1';
					load_en_out		<= '1';
					store_en_out	<= '0';
					load_imm <= '0';
					operator_out	<= ALU_ADD;

				when OPCODE_STORE =>
					imm12_complement := (others => instruction_in(31));
					-- (S) : Memory store
					rA_out			<= instruction_in(19 downto 15);
					rB_out			<= instruction_in(24 downto 20);
					rC_out			<= (others => '0');
					imm_out			<= imm12_complement & instruction_in(31 downto 25) & instruction_in(11 downto 7);
					mux_a_out		<= A_REG;
					mux_b_out		<= B_IMM;
					write_en_out	<= '0';
					load_en_out		<= '0';
					store_en_out	<= '1';
					load_imm <= '0';
					operator_out	<= ALU_ADD;

				when OPCODE_OP_IMM =>
					imm12_complement := (others => instruction_in(31));
					-- Imm ALU op
					rA_out			<= instruction_in(19 downto 15);
					rB_out			<= (others => '0');
					rC_out			<= instruction_in(11 downto 7);
					imm_out			<= imm12_complement & instruction_in(31 downto 20);
					mux_a_out		<= A_REG;
					mux_b_out		<= B_IMM;
					write_en_out	<= '1';
					load_en_out		<= '0';
					store_en_out	<= '0';
					load_imm <= '0';
					
					case instruction_in(14 downto 12)  is
						when  OP_ALU_ADDI	=> operator_out <= ALU_ADD; --
						when  OP_ALU_SLTI	=> operator_out <= ALU_SLTS; --
						when  OP_ALU_SLTUI	=> operator_out <= ALU_SLTU; --
						when  OP_ALU_XORI	=> operator_out <= ALU_XOR; --
						when  OP_ALU_ORI	=> operator_out <= ALU_OR; --
						when  OP_ALU_ANDI	=> operator_out <= ALU_AND; --
						when  OP_ALU_SLLI	=> operator_out <= ALU_SLL; --
						when  OP_ALU_SRI	=>
							if instruction_in(30) = '0' then
								operator_out <= ALU_SRL; --
							else
								operator_out <= ALU_SRA; --
							end if;
						when others => 
							--nothing
							operator_out <= (others => '0');
					end case;

				when OPCODE_OP_REG =>
					-- Reg ALU op
					rA_out			<= instruction_in(19 downto 15);
					rB_out			<= instruction_in(24 downto 20);
					rC_out			<= instruction_in(11 downto 7);
					imm_out			<= (others => '0');
					mux_a_out		<= A_REG;
					mux_b_out		<= B_REG;
					write_en_out	<= '1';
					load_en_out		<= '0';
					store_en_out	<= '0';
					load_imm <= '0';

					alu_operation :=  instruction_in(30 downto 25) & instruction_in(14 downto 12);
					case alu_operation is
						when OP_ALU_ADD => operator_out <= ALU_ADD; --
						when OP_ALU_SUB => operator_out <= ALU_SUB; --
						when OP_ALU_SLL	=> operator_out <= ALU_SLL; --
						when OP_ALU_SLT	=> operator_out <= ALU_SLTS; --
						when OP_ALU_SLTU=> operator_out <= ALU_SLTU; --
						when OP_ALU_XOR	=> operator_out <= ALU_XOR; --
						when OP_ALU_SRL	=> operator_out <= ALU_SRL; --
						when OP_ALU_SRA	=> operator_out <= ALU_SRA; --
						when OP_ALU_OR	=> operator_out <= ALU_OR; --
						when OP_ALU_AND	=> operator_out <= ALU_AND; --
						when others => 
							--nothing
							operator_out <= (others => '0');
					end case;

				when others =>
					-- Nothing
					rA_out		<= (others => '0');
					rB_out		<= (others => '0');
					rC_out		<= (others => '0');
					imm_out		<= (others => '0');
					operator_out <= (others => '0');
					mux_a_out		<= (others => '0');
					mux_b_out		<= (others => '0');
					write_en_out	<= '0';
					load_en_out		<= '0';
					store_en_out	<= '0';
					load_imm <= '0';
			end case;
		end if;
	end process op_code_parse;

end arch;

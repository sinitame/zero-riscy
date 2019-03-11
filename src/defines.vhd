library ieee;
use ieee.std_logic_1164.all;

package defines is
	--------------------------------------------------------------
	----------- Simple ALU operations (testing purpose) ----------
	--------------------------------------------------------------

	constant TEST_ADD		: std_logic_vector(5 downto 0)	:= "000000";
	constant TEST_SUB		: std_logic_vector(5 downto 0)	:= "000001";
	constant TEST_INC		: std_logic_vector(5 downto 0)	:= "000010";
	constant TEST_DEC		: std_logic_vector(5 downto 0)	:= "000011";
	constant TEST_AND		: std_logic_vector(5 downto 0)	:= "000100";
	constant TEST_OR		: std_logic_vector(5 downto 0)	:= "000101";
	constant TEST_XOR		: std_logic_vector(5 downto 0)	:= "000110";
	constant TEST_NOT		: std_logic_vector(5 downto 0)	:= "000111";
	constant TEST_SHIFT		: std_logic_vector(5 downto 0)	:= "001000";
	
	--------------------------------------------------------------
	------------------- ALU instruction code  --------------------
	--------------------------------------------------------------
	constant OP_ALU_ADD		: std_logic_vector(8 downto 0) := "000000000";
	constant OP_ALU_SUB		: std_logic_vector(8 downto 0) := "100000000";
	constant OP_ALU_SLL		: std_logic_vector(8 downto 0) := "000000001";
	constant OP_ALU_SLT		: std_logic_vector(8 downto 0) := "000000010";
	constant OP_ALU_SLTU	: std_logic_vector(8 downto 0) := "000000011";
	constant OP_ALU_XOR		: std_logic_vector(8 downto 0) := "000000100";
	constant OP_ALU_SRL		: std_logic_vector(8 downto 0) := "000000101";
	constant OP_ALU_SRA		: std_logic_vector(8 downto 0) := "100000101";
	constant OP_ALU_OR		: std_logic_vector(8 downto 0) := "000000110";
	constant OP_ALU_AND		: std_logic_vector(8 downto 0) := "000000111";

	-------------------- IMM12 Instructions ----------------------
	constant OP_ALU_ADDI	: std_logic_vector(2 downto 0) := "000";
	constant OP_ALU_SLTI	: std_logic_vector(2 downto 0) := "010";
	constant OP_ALU_SLTUI	: std_logic_vector(2 downto 0) := "011";
	constant OP_ALU_XORI	: std_logic_vector(2 downto 0) := "100";
	constant OP_ALU_ORI		: std_logic_vector(2 downto 0) := "110";
	constant OP_ALU_ANDI	: std_logic_vector(2 downto 0) := "111";
	constant OP_ALU_SLLI	: std_logic_vector(2 downto 0) := "001";
	constant OP_ALU_SRI		: std_logic_vector(2 downto 0) := "101";

	--------------------------------------------------------------
	------------------- ALU operations codes ---------------------
	--------------------------------------------------------------
	constant ALU_ADD   : std_logic_vector(5 downto 0) := "011000";
	constant ALU_SUB   : std_logic_vector(5 downto 0) := "011001";
	constant ALU_ADDU  : std_logic_vector(5 downto 0) := "011010";
	constant ALU_SUBU  : std_logic_vector(5 downto 0) := "011011";
	constant ALU_ADDR  : std_logic_vector(5 downto 0) := "011100";
	constant ALU_SUBR  : std_logic_vector(5 downto 0) := "011101";
	constant ALU_ADDUR : std_logic_vector(5 downto 0) := "011110";
	constant ALU_SUBUR : std_logic_vector(5 downto 0) := "011111";

	constant ALU_XOR   : std_logic_vector(5 downto 0) := "101111";
	constant ALU_OR    : std_logic_vector(5 downto 0) := "101110";
	constant ALU_AND   : std_logic_vector(5 downto 0) := "010101";

	constant ALU_SRA   : std_logic_vector(5 downto 0) := "100100";
	constant ALU_SRL   : std_logic_vector(5 downto 0) := "100101";
	constant ALU_ROR   : std_logic_vector(5 downto 0) := "100110";
	constant ALU_SLL   : std_logic_vector(5 downto 0) := "100111";

	constant ALU_BEXT  : std_logic_vector(5 downto 0) := "101000";
	constant ALU_BEXTU : std_logic_vector(5 downto 0) := "101001";
	constant ALU_BINS  : std_logic_vector(5 downto 0) := "101010";
	constant ALU_BCLR  : std_logic_vector(5 downto 0) := "101011";
	constant ALU_BSET  : std_logic_vector(5 downto 0) := "101100";

	constant ALU_FF1   : std_logic_vector(5 downto 0) := "110110";
	constant ALU_FL1   : std_logic_vector(5 downto 0) := "110111";
	constant ALU_CNT   : std_logic_vector(5 downto 0) := "110100";
	constant ALU_CLB   : std_logic_vector(5 downto 0) := "110101";

	constant ALU_EXTS  : std_logic_vector(5 downto 0) := "111110";
	constant ALU_EXT   : std_logic_vector(5 downto 0) := "111111";

	constant ALU_LTS   : std_logic_vector(5 downto 0) := "000000";
	constant ALU_LTU   : std_logic_vector(5 downto 0) := "000001";
	constant ALU_LES   : std_logic_vector(5 downto 0) := "000100";
	constant ALU_LEU   : std_logic_vector(5 downto 0) := "000101";
	constant ALU_GTS   : std_logic_vector(5 downto 0) := "001000";
	constant ALU_GTU   : std_logic_vector(5 downto 0) := "001001";
	constant ALU_GES   : std_logic_vector(5 downto 0) := "001010";
	constant ALU_GEU   : std_logic_vector(5 downto 0) := "001011";
	constant ALU_EQ    : std_logic_vector(5 downto 0) := "001100";
	constant ALU_NE    : std_logic_vector(5 downto 0) := "001101";

	constant ALU_SLTS  : std_logic_vector(5 downto 0) := "000010";
	constant ALU_SLTU  : std_logic_vector(5 downto 0) := "000011";
	constant ALU_SLETS : std_logic_vector(5 downto 0) := "000110";
	constant ALU_SLETU : std_logic_vector(5 downto 0) := "000111";

	constant ALU_ABS   : std_logic_vector(5 downto 0) := "010100";
	constant ALU_CLIP  : std_logic_vector(5 downto 0) := "010110";
	constant ALU_CLIPU : std_logic_vector(5 downto 0) := "010111";

	constant ALU_INS   : std_logic_vector(5 downto 0) := "101101";

	constant ALU_MIN   : std_logic_vector(5 downto 0) := "010000";
	constant ALU_MINU  : std_logic_vector(5 downto 0) := "010001";
	constant ALU_MAX   : std_logic_vector(5 downto 0) := "010010";
	constant ALU_MAXU  : std_logic_vector(5 downto 0) := "010011";

	constant ALU_SHUF  : std_logic_vector(5 downto 0) := "111010";
	constant ALU_SHUF2 : std_logic_vector(5 downto 0) := "111011";
	constant ALU_PCKLO : std_logic_vector(5 downto 0) := "111000";
	constant ALU_PCKHI : std_logic_vector(5 downto 0) := "111001";	

	--------------------------------------------------------------
	-------------------- Operation categories --------------------
	--------------------------------------------------------------

	constant OPCODE_AUIPC	: std_logic_vector(6 downto 0) := "0010111";
	constant OPCODE_LUI		: std_logic_vector(6 downto 0) := "0110111";
	constant OPCODE_JAL		: std_logic_vector(6 downto 0) := "1101111";
	constant OPCODE_JALR	: std_logic_vector(6 downto 0) := "1100111";
	constant OPCODE_JUMP	: std_logic_vector(6 downto 0) := "1100011";
	constant OPCODE_LOAD	: std_logic_vector(6 downto 0) := "0000011";
	constant OPCODE_STORE	: std_logic_vector(6 downto 0) := "0100011";
	constant OPCODE_OP_REG	: std_logic_vector(6 downto 0) := "0110011";
	constant OPCODE_OP_IMM	: std_logic_vector(6 downto 0) := "0010011";

end package;

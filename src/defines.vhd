library ieee;
use ieee.std_logic_1164.all;

package defines is
	constant OP_ADD		: std_logic_vector(3 downto 0)	:= "0000";
	constant OP_SUB		: std_logic_vector(3 downto 0)	:= "0001";
	constant OP_INC		: std_logic_vector(3 downto 0)	:= "0010";
	constant OP_DEC		: std_logic_vector(3 downto 0)	:= "0011";
	constant OP_AND		: std_logic_vector(3 downto 0)	:= "0100";
	constant OP_OR		: std_logic_vector(3 downto 0)	:= "0101";
	constant OP_XOR		: std_logic_vector(3 downto 0)	:= "0110";
	constant OP_NOT		: std_logic_vector(3 downto 0)	:= "0111";
	constant OP_SHIFT	: std_logic_vector(3 downto 0)	:= "1000";
end package;

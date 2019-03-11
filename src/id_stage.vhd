library ieee;
use ieee.std_logic_1164.all;

library lib_VHDL;
use lib_VHDL.defines.all;

entity id_stage is
	generic(
			ALU_OP_WIDTH	: natural := 6;
			GPR_WIDTH		: natural := 5
		   );
	port(
			clk					: in std_logic;
			reset				: in std_logic;
			instruction			: in std_logic_vector(31 downto 0);

			OpA_out				: out std_logic_vector(31 downto 0);
			OpB_out				: out std_logic_vector(31 downto 0);
			Op_out				: out std_logic_vector(ALU_OP_WIDTH-1 downto 0);

			alu_result_in		: in std_logic_vector(31 downto 0)
		);

end id_stage;


architecture arch of id_stage is

	signal rA			: std_logic_vector(GPR_WIDTH-1 downto 0);
	signal rB			: std_logic_vector(GPR_WIDTH-1 downto 0);
	signal rC			: std_logic_vector(GPR_WIDTH-1 downto 0);
	signal imm			: std_logic_vector(31 downto 0);
	signal write_en		: std_logic;
	signal imm_en		: std_logic;

	signal rA_data		: std_logic_vector(31 downto 0);
	signal rB_data		: std_logic_vector(31 downto 0);
	signal rC_data		: std_logic_vector(31 downto 0);


	
begin

	DECODER : entity lib_VHDL.decoder
		port map (
					reset			=> reset,
					instruction_in	=> instruction,
					rA_out			=> rA,
					rB_out			=> rB,
					rC_out			=> rC,
					imm_out			=> imm,
					operator_out	=> Op_out,
					write_en_out	=> write_en,
					imm_en_out		=> imm_en
				 );
	
	GPR : entity lib_VHDL.GPR
		port map (
					clk				=> clk,
                    reset			=> reset,
                    raddr_a_in		=> rA,
                    rdata_a_out		=> rA_data,
                    raddr_b_in		=> rB,
                    rdata_b_out		=> rB_data,
                    waddr_in		=> rC,
                    wdata_in		=> rC_data,
                    write_en_in		=> write_en
				 );

		-----------------------------------------
		-------------- Operand A ----------------
		-----------------------------------------
		OpA_out <= rA_data;

		-----------------------------------------
		-------------- Operand B ----------------
		-----------------------------------------
		mux_operand_b : process(imm_en,rB_data, imm,clk)
		begin
			case imm_en is
				when '0' => OpB_out <= rB_data;
				when '1' => OpB_out <= imm;
				when others =>
			end case;
		end process;

		-----------------------------------------
		-------------- Result -------------------
		-----------------------------------------
		rC_data <= alu_result_in;

end arch;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

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

			-- Signals IF stage
			instruction			: in std_logic_vector(31 downto 0);
			pc_in				: in std_logic_vector(31 downto 0);
			next_pc_out			: out std_logic;
			mux_pc_out			: out std_logic_vector(1 downto 0);
			pc_boot_out			: out std_logic;
			fetch_hit_in		: in std_logic;

			--Signals ALU
			OpA_out				: out std_logic_vector(31 downto 0);
			OpB_out				: out std_logic_vector(31 downto 0);
			Op_out				: out std_logic_vector(ALU_OP_WIDTH-1 downto 0);
			alu_result_in		: in std_logic_vector(31 downto 0);
			branch_decision_in	: in std_logic;

			-- Signals LSU
			mem_data_in			: in std_logic_vector(31 downto 0);
			wdata_out			: out std_logic_vector(31 downto 0);
			load_en_out			: out std_logic;
			store_en_out		: out std_logic;
			mem_hit_in			: in std_logic
		);

end id_stage;


architecture arch of id_stage is

	signal rA			: std_logic_vector(GPR_WIDTH-1 downto 0);
	signal rB			: std_logic_vector(GPR_WIDTH-1 downto 0);
	signal rC			: std_logic_vector(GPR_WIDTH-1 downto 0);
	signal imm			: std_logic_vector(31 downto 0);
	signal write_en		: std_logic;
	signal mux_a		: std_logic_vector(1 downto 0);
	signal mux_b		: std_logic_vector(1 downto 0);

	signal rA_data		: std_logic_vector(31 downto 0);
	signal rB_data		: std_logic_vector(31 downto 0);
	signal rC_data		: std_logic_vector(31 downto 0);

	signal jump_ex		: std_logic;
	signal branch_ex	: std_logic;
	signal load_en		: std_logic;
	signal store_en		: std_logic;
	signal load_imm		: std_logic;

	
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
					mux_a_out		=> mux_a,
					mux_b_out		=> mux_b,
					load_en_out		=> load_en,
					store_en_out	=> store_en,
					jump_ex_in		=> jump_ex,
					branch_ex_in	=> branch_ex,
					load_imm		=> load_imm
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

	CONTROLLER : entity lib_VHDL.controller
		port map(
					clk					=> clk,
					reset				=> reset,
					opcode_in			=> instruction(6 downto 0),
					jump_ex_out			=> jump_ex,
					branch_ex_out		=> branch_ex,
					branch_decision_in	=> branch_decision_in,
					pc_boot_out			=> pc_boot_out,
					next_pc_out			=> next_pc_out,
					mux_pc_out			=> mux_pc_out,
					fetch_hit_in		=> fetch_hit_in,
					mem_hit_in			=> mem_hit_in
				);

		-----------------------------------------
		-------------- Operand A ----------------
		-----------------------------------------
		mux_operand_a : process(mux_a, rA_data, pc_in)
		begin
			case mux_a is
				when A_REG => OpA_out <= rA_data;
				when A_PC => OpA_out <= pc_in;
				when A_ZERO => OpA_out <= (others => '0');
				when others => OpA_out <= (others => '0');
			end case;
		end process;

		-----------------------------------------
		-------------- Operand B ----------------
		-----------------------------------------
		mux_operand_b : process(mux_b, rB_data,imm)
		begin
			case mux_b is
				when B_REG => OpB_out <= rB_data;
				when B_IMM => OpB_out <= imm;
				when B_PC4 => OpB_out <= std_logic_vector(to_unsigned(4,32));
				when others => OpB_out <= (others => '0');
			end case;
		end process;

		-----------------------------------------
		------------ Writing register -----------
		-----------------------------------------
		mux_write_data : process(load_en,mem_data_in,alu_result_in)
		begin
			case load_en is
				when '0' => rC_data <= alu_result_in;
				when '1' => rC_data <= mem_data_in;
				when others => rC_data <= (others => '0');
			end case;
		end process;

		-----------------------------------------
		------------ Writing register -----------
		-----------------------------------------
		mux_mem_data : process(load_imm, rB_data, alu_result_in)
		begin
			case load_imm is
				when '0' => wdata_out <= rB_data;
				when '1' => wdata_out <= alu_result_in;
				when others =>
			end case;
		end process;

		load_en_out <= load_en;
		store_en_out <= store_en;

end arch;

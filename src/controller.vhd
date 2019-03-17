library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library lib_VHDL;
use lib_VHDL.defines.all;

entity controller is
	port(
			clk					: in std_logic;
			reset				: in std_logic;
			
			-- Signals to/from decoder
			opcode_in			: in std_logic_vector(6 downto 0);
			jump_ex_out			: out std_logic;
			branch_ex_out		: out std_logic;
	
			-- Signals to/fom ALU
			branch_decision_in	: in std_logic;

			-- Signals to PC Unit
			pc_boot_out			: out std_logic;
			next_pc_out			: out std_logic;
			mux_pc_out			: out std_logic_vector(1 downto 0);

			-- Signals to/from Fetch
			fetch_hit_in		: in std_logic;

			-- Signals to/from LSU
			mem_hit_in			: in std_logic

		);
end controller;


architecture arch of controller is
	type state_type is (IDLE,FETCH,DECODE_EX,STALL);
	signal state : state_type;

	signal jump_ex : std_logic := '0';
	signal branch_ex : std_logic := '0';

begin

	FSM : process(clk,state)
	begin
		if reset= '1' then
			state <= IDLE;
		elsif rising_edge(clk) then
			case state is
				when IDLE =>
					next_pc_out <= '1';
					mux_pc_out  <= PC_BOOT;
					state <= FETCH;

				when FETCH =>
					next_pc_out <= '0';
					mux_pc_out  <= PC_INC;
					if fetch_hit_in = '1' then
						state <= DECODE_EX;
					else
						state <= FETCH;
					end if;

				when DECODE_EX =>
					case opcode_in is
						when OPCODE_AUIPC =>
							next_pc_out <= '1';
							mux_pc_out <= PC_JUMP;
							state <= FETCH;

						when OPCODE_LUI =>
							next_pc_out <= '1';
							mux_pc_out <= PC_INC;
							state <= FETCH;

						when OPCODE_OP_REG | OPCODE_OP_IMM => 
							next_pc_out <= '1';
							mux_pc_out <= PC_INC;
							state <= FETCH;

						when OPCODE_STORE | OPCODE_LOAD =>
							if mem_hit_in then
								next_pc_out <= '1';
								mux_pc_out <= PC_INC;
								state <= FETCH;
							else
								next_pc_out <= '0';
								mux_pc_out <= PC_INC;
								state <= STALL;
							end if;

						when OPCODE_JAL | OPCODE_JALR =>
							if jump_ex = '0' then
								next_pc_out <= '0';
								mux_pc_out  <= PC_INC;
								jump_ex <= '1';
								state <= DECODE_EX;
							else
								jump_ex <= '0';
								next_pc_out <= '1';
								mux_pc_out <= PC_JUMP;
								state <= FETCH;
							end if;

						when OPCODE_BRANCH =>
							if branch_ex = '0' and branch_decision_in = '1' then
								branch_ex <= '1';
								next_pc_out <= '0';
								mux_pc_out  <= PC_INC;
								state <= DECODE_EX;
							else
								branch_ex <= '0';
								next_pc_out <= '1';
								mux_pc_out <= PC_JUMP;
								state <= FETCH;
							end if;
						when others =>
					end case;

				when STALL => 
					if mem_hit_in then
						next_pc_out <= '1';
						mux_pc_out <= PC_INC;
						state <= FETCH;
					else
						next_pc_out <= '0';
						mux_pc_out <= PC_INC;
						state <= STALL;
					end if;

				when others =>
					state <= IDLE;
			end case;
		end if;
		
	end process FSM;

	jump_ex_out <= jump_ex;
	branch_ex_out <= branch_ex;

end arch;


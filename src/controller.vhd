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
	type state_type is (IDLE,FIRST_FETCH,DECODE_EX,STALL_MEM,STALL_FETCH);
	signal state : state_type;
	signal next_state : state_type;

	signal jump_ex : std_logic := '0';
	signal branch_ex : std_logic := '0';
	signal jump_en : std_logic := '0';
	signal branch_en : std_logic := '0';

begin

	FSM : process(state, fetch_hit_in, jump_ex, branch_decision_in, branch_ex, opcode_in)
	begin
		case state is
			when IDLE =>
				next_pc_out <= '0';
				mux_pc_out  <= PC_BOOT;
				next_state <= FIRST_FETCH;

			when FIRST_FETCH =>
				next_pc_out <= '1';
				mux_pc_out  <= PC_BOOT;
				if fetch_hit_in = '1' then
					next_state <= DECODE_EX;
				else
					next_state <= FIRST_FETCH;
				end if;

			when DECODE_EX =>
				case opcode_in is
					when OPCODE_AUIPC =>
						next_pc_out <= '1';
						mux_pc_out <= PC_JUMP;
						if fetch_hit_in = '1'  then
							next_state <= DECODE_EX;
						else
							next_state <= STALL_FETCH;
						end if;

					when OPCODE_LUI =>
						next_pc_out <= '1';
						mux_pc_out <= PC_INC;
						if fetch_hit_in = '1' then
							next_state <= DECODE_EX;
						else
							next_state <= STALL_FETCH;
						end if;

					when OPCODE_OP_REG | OPCODE_OP_IMM => 
						next_pc_out <= '1';
						mux_pc_out <= PC_INC;
						if fetch_hit_in = '1'  then
							next_state <= DECODE_EX;
						else
							next_state <= STALL_FETCH;
						end if;

					when OPCODE_STORE | OPCODE_LOAD =>
						if mem_hit_in = '1' then
							next_pc_out <= '1';
							mux_pc_out <= PC_INC;
							if fetch_hit_in = '1' then
								next_state <= DECODE_EX;
							else
								next_state <= STALL_FETCH;
							end if;
						else
							next_pc_out <= '0';
							mux_pc_out <= PC_INC;
							next_state <= STALL_MEM;
						end if;

					when OPCODE_JAL | OPCODE_JALR =>
						if jump_ex = '0' then
							next_pc_out <= '0';
							mux_pc_out  <= PC_INC;
							jump_en <= '1';
							next_state <= DECODE_EX;
						else
							jump_en <= '0';
							next_pc_out <= '1';
							mux_pc_out <= PC_JUMP;
							if fetch_hit_in = '1' then
								next_state <= DECODE_EX;
							else
								next_state <= STALL_FETCH;
							end if;
						end if;

					when OPCODE_BRANCH =>
						if branch_ex = '0' and branch_decision_in = '1' then
							branch_en <= '1';
							next_pc_out <= '0';
							mux_pc_out  <= PC_INC;
							next_state <= DECODE_EX;
						else
							if branch_ex = '1' then
								next_pc_out <= '1';
								mux_pc_out <= PC_JUMP;
							else
								next_pc_out <= '1';
								mux_pc_out <= PC_INC;
							end if;
							branch_en <= '0';
							if fetch_hit_in = '1' then
								next_state <= DECODE_EX;
							else
								next_state <= STALL_FETCH;
							end if;
						end if;
					when others =>
				end case;

			when STALL_MEM => 
				if mem_hit_in = '1' then
					next_pc_out <= '1';
					mux_pc_out <= PC_INC;
					next_state <= DECODE_EX;
				else
					next_pc_out <= '0';
					mux_pc_out <= PC_INC;
					next_state <= STALL_MEM;
				end if;

			when STALL_FETCH => 
				if fetch_hit_in = '1' then
					next_pc_out <= '1';
					mux_pc_out <= PC_INC;
					next_state <= DECODE_EX;
				else
					next_pc_out <= '0';
					mux_pc_out <= PC_INC;
					next_state <= STALL_FETCH;
				end if;

			when others =>
				next_state <= IDLE;
		end case;
	end process FSM;

	jump_ex_register : process(clk, jump_en)
	begin
		if reset = '1' then
			jump_ex <= '0';
		elsif rising_edge(clk) and jump_en = '1' then
			if jump_ex = '0' then
				jump_ex <= '1';
			end if;
		elsif rising_edge(clk) then
				jump_ex <= '0';
		end if;
	end process;
	
	branch_ex_register : process(clk, branch_en)
	begin
		if reset = '1' then
			branch_ex <= '0';
		elsif rising_edge(clk) and branch_en = '1' then
			if branch_ex = '0' then
				branch_ex <= '1';
			end if;
		elsif rising_edge(clk) then
				branch_ex <= '0';
		end if;
	end process;


	process(clk, reset, state, next_state)
	begin
		if reset = '1' then
			state <= IDLE;
			next_state <= state;
		elsif rising_edge(clk) then
			state <= next_state;
		end if;
	end process;

	jump_ex_out <= jump_ex;
	branch_ex_out <= branch_ex;

end arch;


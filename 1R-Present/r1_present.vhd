library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity r1_present is
    port(
        state: in std_logic_vector(63 downto 0);
        key: in std_logic_vector(79 downto 0);
        clk: in std_logic;
        start: in std_logic;
        cypher_state: out std_logic_vector(63 downto 0)
    );
end r1_present;

architecture behavioral of r1_present is
    signal state_reg_round: std_logic_vector(63 downto 0);
    signal key_reg_round: std_logic_vector(79 downto 0);

    signal done: std_logic; 
    signal round_count: unsigned(4 downto 0);

    signal state_round_out: std_logic_vector(63 downto 0);
    signal key_round_out: std_logic_vector(79 downto 0);
    signal pos_out: std_logic_vector(63 downto 0);

begin
    process(clk) 
    begin
        if rising_edge(clk) then
            --mux de entrada
            if(start = '1') then
                state_reg_round <= state;
                key_reg_round <= key;
            else
                state_reg_round <= state_round_out;
                key_reg_round <= key_round_out;
            end if;

            if (done = '1') then
                cypher_state <= pos_out;
            end if;
        end if;
    end process;

    ctrl_inst: entity work.ctrl port map (
        start => start,
        clk => clk,
        done => done,
        round_cnt => round_count
    );

    round: entity work.top port map(
        state => state_reg_round,
        key => key_reg_round,
        count => round_count,
        new_state => state_round_out,
        next_key => key_round_out
    );

    pos_inst: entity work.pos port map(
        state => state_round_out,
        key => key_round_out,
        new_state => pos_out
    );

end behavioral;
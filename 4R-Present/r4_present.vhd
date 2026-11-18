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
    signal round_count: std_logic_vector(4 downto 0);
    signal cnt_unsigned: unsigned(4 downto 0);

    signal state_r1, state_r2, state_r3, state_r4: std_logic_vector(63 downto 0);
    signal key_r1, key_r2, key_r3, key_r4: std_logic_vector(79 downto 0);
    
    signal pos_out: std_logic_vector(63 downto 0);

begin
    cnt_unsigned <= unsigned(round_count);

    process(clk) 
    begin
        if rising_edge(clk) then
            if(start='1') then
                state_reg_round <= state;
                key_reg_round <= key;
            else
                state_reg_round <= state_r4;
                key_reg_round <= key_r4;
            end if;

            if (done='1') then
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

    top1: entity work.top port map(
        state => state_reg_round,
        key => key_reg_round,
        count => std_logic_vector(cnt_unsigned),
        new_state => state_r1,
        next_key => key_r1
    );

    top2: entity work.top port map(
        state => state_r1,
        key => key_r1,
        count => std_logic_vector(cnt_unsigned + 1),
        new_state => state_r2,
        next_key => key_r2
    );

    top3: entity work.top port map(
        state => state_r2,
        key => key_r2,
        count => std_logic_vector(cnt_unsigned + 2),
        new_state => state_r3,
        next_key => key_r3
    );

    top4: entity work.top port map(
        state => state_r3,
        key => key_r3,
        count => std_logic_vector(cnt_unsigned + 3),
        new_state => state_r4,
        next_key => key_r4
    );

    pos_inst: entity work.pos port map(
        state => state_r3,
        key => key_r3,
        new_state => pos_out
    );

end behavioral;
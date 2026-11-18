library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ctrl is
    port(
        start     : in  std_logic;
        clk       : in  std_logic;
        done      : out std_logic;
        round_cnt : out std_logic_vector(4 downto 0)
    );
end ctrl;

architecture behavioral of ctrl is
    type state_type is (IDLE, PROCESS_DATA, FINISH);
    signal current_state, next_state : state_type;
    signal cnt, next_cnt : unsigned(4 downto 0);

begin
    process(clk)
    begin
        if rising_edge(clk) then
            current_state <= next_state;
            cnt <= next_cnt;
        end if;
    end process;

    round_cnt <= std_logic_vector(cnt);

    process(current_state, start, cnt)
    begin
        done <= '0';
        next_state <= current_state;
        next_cnt <= cnt; 

        case current_state is
            when IDLE =>
                next_cnt <= "00000"; 
                if start = '1' then
                    next_state <= PROCESS_DATA;
                    next_cnt <= "00001"; 
                end if;
                
            when PROCESS_DATA =>
                if cnt < 29 then
                    next_cnt <= cnt + 4; --sao quatro rodadas de cifra por ciclo então é cnt+4
                else
                    next_state <= FINISH;
                end if;
                
            when FINISH =>
                done <= '1';
                next_state <= IDLE;
                
            when others =>
                next_state <= IDLE;
        end case;
    end process;
end behavioral;
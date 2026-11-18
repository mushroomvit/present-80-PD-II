
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--pipeline 16 estágios
entity pipeline16_present is
    port(
        clk          : in  std_logic;
        rst          : in  std_logic;
        state        : in  std_logic_vector(63 downto 0);
        key          : in  std_logic_vector(79 downto 0);
        valid_in     : in  std_logic;
        cypher_state : out std_logic_vector(63 downto 0)
    );
end pipeline16_present;

architecture behavioral of pipeline16_present is

    type array_comb_state is array (0 to 30) of std_logic_vector(63 downto 0);
    type array_comb_key   is array (0 to 30) of std_logic_vector(79 downto 0);

    type array_reg_state is array (0 to 14) of std_logic_vector(63 downto 0);
    type array_reg_key   is array (0 to 14) of std_logic_vector(79 downto 0);

    signal round_state_in  : array_comb_state;
    signal round_key_in    : array_comb_key;
    signal round_state_out : array_comb_state;
    signal round_key_out   : array_comb_key;

    signal states_reg : array_reg_state;
    signal keys_reg   : array_reg_key;

    signal pos_state_comb : std_logic_vector(63 downto 0);

    signal valid : std_logic;

begin

    process(clk)
    begin
        if rising_edge(clk) then

            states_reg(0) <= round_state_out(1);
            keys_reg(0)   <= round_key_out(1);

            --duas rodadas por estágio
            for i in 1 to 14 loop
                states_reg(i) <= round_state_out(1 + i * 2);
                keys_reg(i)   <= round_key_out(1 + i * 2);
            end loop;

            if valid = '1' then
                cypher_state <= pos_state_comb;
            end if;

        end if;
    end process;

                --entradas das rodadas
    gen_inputs: for i in 0 to 30 generate

        gen_in_0: if i = 0 generate
            round_state_in(i) <= state;
            round_key_in(i)   <= key;
        end generate;

        gen_in_reg: if (i >= 2 and (i mod 2) = 0) generate
            round_state_in(i) <= states_reg((i - 2) / 2);
            round_key_in(i)   <= keys_reg((i - 2) / 2);
        end generate;

        gen_in_comb: if (i mod 2) = 1 generate
            round_state_in(i) <= round_state_out(i - 1);
            round_key_in(i)   <= round_key_out(i - 1);
        end generate;

    end generate;


    -- 31 rodadas de cifra
    gen_rounds: for i in 0 to 30 generate

        round_inst: entity work.top
            port map(
                plaintext  => round_state_in(i),
                master_key => round_key_in(i),
                count      => std_logic_vector(to_unsigned(i + 1, 5)),
                state_out  => round_state_out(i),
                next_key   => round_key_out(i)
            );

    end generate;


    pos_inst: entity work.pos
        port map(
            state     => round_state_out(30),
            key       => round_key_out(30),
            new_state => pos_state_comb
        );


    control_inst: entity work.ctrl16
        port map(
            clk      => clk,
            rst      => rst,
            valid_in => valid_in,
            valid_out    => valid
        );

end behavioral;

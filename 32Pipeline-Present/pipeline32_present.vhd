
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- pipeline present - 32 estágios

entity pipeline32_present is
    port(
        clk          : in  std_logic;
        rst          : in  std_logic;
        state        : in  std_logic_vector(63 downto 0);
        key          : in  std_logic_vector(79 downto 0);
        valid_in     : in  std_logic;
        cypher_state : out std_logic_vector(63 downto 0);
    );
end pipeline32_present;

architecture behavioral of pipeline32_present is

    type array_state is array (0 to 31) of std_logic_vector(63 downto 0);
    type array_key   is array (0 to 31) of std_logic_vector(79 downto 0);

    -- regs
    signal states : array_state;
    signal keys   : array_key;

    -- saidas das etapas combinacionais de cifra
    signal states_comb : array_state;
    signal keys_comb   : array_key;

    signal next_cypher_state : std_logic_vector(63 downto 0);

    --sinal de validade que vem do controle - en pro reg de saida
    signal valid : std_logic;

begin

    process(clk)
    begin
        if rising_edge(clk) then

            -- regs de entrada da arquitetura
            states(0) <= state;
            keys(0)   <= key;

            -- regs das 31 rodadas
            for i in 0 to 30 loop
                states(i + 1) <= states_comb(i);
                keys(i + 1)   <= keys_comb(i);
            end loop;

            -- reg de saida
            if (valid='1') then
            cypher_state <= next_cypher_state;
            end if;

        end if;
    end process;

    -- rodadas de cifra
    gen_rounds: for i in 0 to 30 generate

        round_inst: entity work.top
            port map(
                plaintext  => states(i),
                master_key => keys(i),
                count      => std_logic_vector(to_unsigned(i + 1, 5)),
                state_out  => states_comb(i),
                next_key   => keys_comb(i)
            );

    end generate;

    -- pós processamento
    pos_inst: entity work.pos
        port map(
            state     => states(31),
            key       => keys(31),
            new_state => next_cypher_state
        );

    -- controle
    control_inst: entity work.ctrl
        port map(
            clk       => clk,
            rst       => rst,
            valid_in  => valid_in,
            valid_out => valid
        );

end behavioral;

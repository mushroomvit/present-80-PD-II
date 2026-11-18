library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity R31_Present is
    port(
        clk          : in  std_logic;
        state        : in  std_logic_vector(63 downto 0);
        key          : in  std_logic_vector(79 downto 0);
        cypher_state : out std_logic_vector(63 downto 0)
    );
end R31_Present;

architecture behavioral of R31_Present is

    signal state_reg : std_logic_vector(63 downto 0);
    signal key_reg   : std_logic_vector(79 downto 0);

    type array_state is array (0 to 31) of std_logic_vector(63 downto 0); --arrays para as rodadas
    type array_key   is array (0 to 31) of std_logic_vector(79 downto 0); --32 indices pra inicialização e 31 rodadas de cifra

    signal states : array_state; --states intermediários
    signal keys   : array_key; --keys intermediárias

    signal next_cypher_state : std_logic_vector(63 downto 0);

begin
    --regiistradores de entrada e saída
    process(clk)
    begin
        if rising_edge(clk) then
            state_reg    <= state; --reg de entrada do state
            key_reg      <= key; --reg de entrada da chave
            cypher_state <= next_cypher_state; --reg de saida pro state cifrado
        end if;
    end process;

    -- arrays para lidar com as rodadas (não instanciei uma de cada vez porque o código ficava poluido)
    states(0) <= state_reg; --recebe valores dos regs de entrada
    keys(0)   <= key_reg;


    -- 31 rodadas de cifra
    gen_rounds: for i in 0 to 30 generate
        round_inst: entity work.top
            port map(
                state       => states(i),
                key         => keys(i),
                count       => to_unsigned(i + 1, 5),
                new_state   => states(i + 1),
                next_key    => keys(i + 1)
            );
    end generate;

    -- pós processamento
    pos_inst: entity work.pos
        port map(
            state     => states(31),
            key       => keys(31),
            new_state => next_cypher_state
        );

end behavioral;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--pipeline 8 estágios
entity pipeline8_present is
    port(
        clk          : in  std_logic;
        rst          : in  std_logic;
        state        : in  std_logic_vector(63 downto 0);
        key          : in  std_logic_vector(79 downto 0);
        valid_in     : in  std_logic;
        cypher_state : out std_logic_vector(63 downto 0)
    );
end pipeline8_present;

architecture behavioral of pipeline8_present is

    -- saida rodadas combinacionais
    type array_state is array (0 to 30) of std_logic_vector(63 downto 0);
    type array_key   is array (0 to 30) of std_logic_vector(79 downto 0);

    -- regs de estagio
    -- após rodadas 4, 8, 12, 16, 20, 24 e 28
    type array_reg_state is array (0 to 6) of std_logic_vector(63 downto 0);
    type array_reg_key   is array (0 to 6) of std_logic_vector(79 downto 0);

    signal round_state_in  : array_state;
    signal round_key_in    : array_key;
    signal round_state_out : array_state;
    signal round_key_out   : array_key;

    signal state_in_reg : std_logic_vector(63 downto 0);
    signal key_in_reg   : std_logic_vector(79 downto 0);

    signal states_reg : array_reg_state;
    signal keys_reg   : array_reg_key;

    signal pos_state_comb : std_logic_vector(63 downto 0);

    -- en do reg de saida - gerado pelo controle
    signal valid : std_logic;

begin

    process(clk)
    begin
        if rising_edge(clk) then

            -- regs de entrada
            state_in_reg <= state;
            key_in_reg   <= key;

            -- regs de estagio
            for i in 0 to 6 loop
                states_reg(i) <= round_state_out((i + 1) * 4 - 1);
                keys_reg(i)   <= round_key_out((i + 1) * 4 - 1);
            end loop;

            -- reg de saida
            if (valid = '1') then
                cypher_state <= pos_state_comb;
            end if;

        end if;
    end process;


    gen_inputs: for i in 0 to 30 generate

        -- primeira rodada as entradas vem dos regs de entrada
        gen_first: if i = 0 generate
            round_state_in(i) <= state_in_reg;
            round_key_in(i)   <= key_in_reg;
        end generate;

        -- estagios intermediarios - rodadas de inicio dos estagios
        -- recebe o resultado do estágio anterior
        gen_stage_reg: if (i > 0 and (i mod 4) = 0) generate
            round_state_in(i) <= states_reg((i / 4) - 1);
            round_key_in(i)   <= keys_reg((i / 4) - 1);
        end generate;

        -- outras rodadas - internas
        gen_comb: if (i > 0 and (i mod 4) /= 0) generate
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


    -- pos processamento
    pos_inst: entity work.pos
        port map(
            state     => round_state_out(30),
            key       => round_key_out(30),
            new_state => pos_state_comb
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

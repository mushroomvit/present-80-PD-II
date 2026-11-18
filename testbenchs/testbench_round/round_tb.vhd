
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all; --bibliotecas para lidar com o txt
use ieee.std_logic_textio.all;

entity round_tb is
end round_tb;

architecture sim of round_tb is

    signal state_in, state_out : std_logic_vector(63 downto 0);
    signal key_in, key_out     : std_logic_vector(79 downto 0);

begin
    --top level da rodada
    dut: entity work.top
        port map (
            state     => state_in,
            key       => key_in,
            count     => to_unsigned(1, 5),
            new_state => state_out,
            next_key  => key_out
        );

        --estimulo das entradas
        --a rodada é combinacional então não precisa de processo pro clock
    stim_proc: process

        file vector_file : text open read_mode is "C:\Users\ifsul\Documents\PDII_present80\testbenchs\testbench_round\golden_vectors_round.txt";

        variable line_buffer : line;
        variable key_vector : std_logic_vector(79 downto 0);
        variable state_vector : std_logic_vector(63 downto 0);
        variable expected : std_logic_vector(63 downto 0);
        variable separator : character;

        variable test_count : integer := 0;
        variable error_count : integer := 0;

    begin

        report "--- INICIANDO TESTES DE 1 RODADA ---"
            severity note;

        while not endfile(vector_file) loop

            readline(vector_file, line_buffer);

            -- le os vetores: KEY, STATE, SAÍDA ESPERADA
            hread(line_buffer, key_vector);
            read(line_buffer, separator);

            hread(line_buffer, state_vector);
            read(line_buffer, separator);

            hread(line_buffer, expected);

            --aplica as entradas com a informação do txt
            key_in   <= key_vector;
            state_in <= state_vector;

            wait for 10 ns;

            test_count := test_count + 1;

            -- verifica a saida
            assert state_out = expected
                report "ERRO no teste " & integer'image(test_count)
                severity error;

            if state_out = expected then
                report "Teste " & integer'image(test_count) & ": PASSOU"
                    severity note;
            else
                error_count := error_count + 1;

                report "Teste " & integer'image(test_count) &
                    ": FALHOU - A saída obtida é diferente da esperada."
                    severity note;
            end if;

        end loop;

        report "--- RESULTADO FINAL ---" severity note;
        report "Total: " & integer'image(test_count)
            severity note;
        report "Testes com erro: " & integer'image(error_count)
            severity note;

        if error_count = 0 then
            report "TODOS PASSARAM"
                severity note;
        else
            report "EXISTEM TESTES COM FALHA"
                severity error;
        end if;

        wait;

    end process;

end sim;

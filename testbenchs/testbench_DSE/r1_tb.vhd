
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity r1_tb is
end r1_tb;

architecture sim of r1_tb is

    signal plaintext  : std_logic_vector(63 downto 0);
    signal cyphertext : std_logic_vector(63 downto 0);
    signal masterkey  : std_logic_vector(79 downto 0);

    signal clk   : std_logic := '0';
    signal start : std_logic := '0';

    constant CLK_PERIOD : time := 10 ns;

begin

    -- DUT
    dut: entity work.r1_present
        port map (
            state        => plaintext,
            key          => masterkey,
            clk          => clk,
            start        => start,
            cypher_state => cyphertext
        );

    clk <= not clk after CLK_PERIOD / 2;

    stim_proc: process

        variable test_count  : integer := 0;
        variable error_count : integer := 0;

    begin

        report "--- INICIANDO TESTES R1 PRESENT ---"
            severity note;

        -- TESTE 1
        plaintext <= x"0000000000000000";
        masterkey <= x"00000000000000000000";
        start <= '1';

        wait until rising_edge(clk);
        start <= '0';

        wait for 400 ns;

        test_count := test_count + 1;

        assert cyphertext = x"5579C1387B228445"
            report "ERRO no teste 1"
            severity error;

        if cyphertext = x"5579C1387B228445" then
            report "Teste 1: PASSOU" severity note;
        else
            error_count := error_count + 1;
            report "Teste 1: FALHOU - Esperado: 5579C1387B228445 - Obtido: " &
                   to_hstring(cyphertext)
                severity note;
        end if;

        wait for CLK_PERIOD;


        -- TESTE 2
        plaintext <= x"FFFFFFFFFFFFFFFF";
        masterkey <= x"FFFFFFFFFFFFFFFFFFFF";
        start <= '1';

        wait until rising_edge(clk);
        start <= '0';

        wait for 400 ns;

        test_count := test_count + 1;

        assert cyphertext = x"3333DCD3213210D2"
            report "ERRO no teste 2"
            severity error;

        if cyphertext = x"3333DCD3213210D2" then
            report "Teste 2: PASSOU" severity note;
        else
            error_count := error_count + 1;
            report "Teste 2: FALHOU - Esperado: 3333DCD3213210D2 - Obtido: " &
                   to_hstring(cyphertext)
                severity note;
        end if;

        wait for CLK_PERIOD;


        -- TESTE 3
        plaintext <= x"FFFFFFFFFFFFFFFF";
        masterkey <= x"00000000000000000000";
        start <= '1';

        wait until rising_edge(clk);
        start <= '0';

        wait for 400 ns;

        test_count := test_count + 1;

        assert cyphertext = x"A112FFC72F68417B"
            report "ERRO no teste 3"
            severity error;

        if cyphertext = x"A112FFC72F68417B" then
            report "Teste 3: PASSOU" severity note;
        else
            error_count := error_count + 1;
            report "Teste 3: FALHOU - Esperado: A112FFC72F68417B - Obtido: " &
                   to_hstring(cyphertext)
                severity note;
        end if;

        wait for CLK_PERIOD;


        -- TESTE 4
        plaintext <= x"0000000000000000";
        masterkey <= x"FFFFFFFFFFFFFFFFFFFF";
        start <= '1';

        wait until rising_edge(clk);
        start <= '0';

        wait for 400 ns;

        test_count := test_count + 1;

        assert cyphertext = x"E72C46C0F5945049"
            report "ERRO no teste 4"
            severity error;

        if cyphertext = x"E72C46C0F5945049" then
            report "Teste 4: PASSOU" severity note;
        else
            error_count := error_count + 1;
            report "Teste 4: FALHOU - Esperado: E72C46C0F5945049 - Obtido: " &
                   to_hstring(cyphertext)
                severity note;
        end if;


        report "--- RESULTADO FINAL ---" severity note;

        report "Total: " &
            integer'image(test_count)
            severity note;

        report "Testes com erro: " &
            integer'image(error_count)
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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- processa 1 nibble na LUT

entity sbox is
    port(
        nibble: in std_logic_vector(3 downto 0);
        otp: out std_logic_vector(3 downto 0)
    );
end sbox;

architecture behavioral of sbox is
begin

    -- tabela de substituição sbox

    otp <= "1100" when nibble="0000" else -- C
           "0101" when nibble="0001" else -- 5
           "0110" when nibble="0010" else -- 6
           "1011" when nibble="0011" else -- B
           "1001" when nibble="0100" else -- 9
           "0000" when nibble="0101" else -- 0
           "1010" when nibble="0110" else -- A
           "1101" when nibble="0111" else -- D
           "0011" when nibble="1000" else -- 3
           "1110" when nibble="1001" else -- E
           "1111" when nibble="1010" else -- F
           "1000" when nibble="1011" else -- 8
           "0100" when nibble="1100" else -- 4
           "0111" when nibble="1101" else -- 7
           "0001" when nibble="1110" else -- 1
           "0010";                        -- 2

end behavioral;
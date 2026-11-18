
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- faz processamento dos nibbles pela LUT

entity sbox_layer is
    port(
        state: in std_logic_vector(63 downto 0);
        new_state: out std_logic_vector(63 downto 0)
    );
end sbox_layer;

architecture behavioral of sbox_layer is

    component sbox is
        port(
            nibble: in std_logic_vector(3 downto 0);
            otp: out std_logic_vector(3 downto 0)
        );
    end component;

    signal nibble1, nibble2, nibble3, nibble4, nibble5, nibble6, nibble7, nibble8: std_logic_vector(3 downto 0);
    signal nibble9, nibble10, nibble11, nibble12, nibble13, nibble14, nibble15, nibble16: std_logic_vector(3 downto 0);

begin

    sbox1: sbox port map(
        nibble => state(63 downto 60),
        otp => nibble1
    );

    sbox2: sbox port map(
        nibble => state(59 downto 56),
        otp => nibble2
    );

    sbox3: sbox port map(
        nibble => state(55 downto 52),
        otp => nibble3
    );

    sbox4: sbox port map(
        nibble => state(51 downto 48),
        otp => nibble4
    );

    sbox5: sbox port map(
        nibble => state(47 downto 44),
        otp => nibble5
    );

    sbox6: sbox port map(
        nibble => state(43 downto 40),
        otp => nibble6
    );

    sbox7: sbox port map(
        nibble => state(39 downto 36),
        otp => nibble7
    );

    sbox8: sbox port map(
        nibble => state(35 downto 32),
        otp => nibble8
    );

    sbox9: sbox port map(
        nibble => state(31 downto 28),
        otp => nibble9
    );

    sbox10: sbox port map(
        nibble => state(27 downto 24),
        otp => nibble10
    );

    sbox11: sbox port map(
        nibble => state(23 downto 20),
        otp => nibble11
    );

    sbox12: sbox port map(
        nibble => state(19 downto 16),
        otp => nibble12
    );

    sbox13: sbox port map(
        nibble => state(15 downto 12),
        otp => nibble13
    );

    sbox14: sbox port map(
        nibble => state(11 downto 8),
        otp => nibble14
    );

    sbox15: sbox port map(
        nibble => state(7 downto 4),
        otp => nibble15
    );

    sbox16: sbox port map(
        nibble => state(3 downto 0),
        otp => nibble16
    );

    new_state <= nibble1 & nibble2 & nibble3 & nibble4 &
                 nibble5 & nibble6 & nibble7 & nibble8 &
                 nibble9 & nibble10 & nibble11 & nibble12 &
                 nibble13 & nibble14 & nibble15 & nibble16;

end behavioral;

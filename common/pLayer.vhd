library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- permutação dos bits de state

entity pLayer is
    port(
        state: in std_logic_vector(63 downto 0);
        new_state: out std_logic_vector(63 downto 0)
    );
end pLayer;

architecture behavioral of player is

begin

    gen_permutation: for i in 0 to 62 generate
        new_state((16 * i) mod 63) <= state(i);
    end generate;

    new_state(63) <= state(63);

end behavioral;
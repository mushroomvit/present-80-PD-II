library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- faz o pós processamento

entity pos is
    port(
        state: in std_logic_vector(63 downto 0);
        key: in std_logic_vector(79 downto 0);
        new_state: out std_logic_vector(63 downto 0)
    );
end pos;

architecture behavioral of pos is
    
begin

    new_state <= state xor key(79 downto 16);

end behavioral;
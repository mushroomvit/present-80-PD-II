
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- faz as operações iniciais com a chave e xor entre round_key e state

entity key_schedule is
    port(
        state         : in  std_logic_vector(63 downto 0);
        key           : in  std_logic_vector(79 downto 0);
        count         : in  unsigned(4 downto 0);
        new_state     : out std_logic_vector(63 downto 0);
        next_key      : out std_logic_vector(79 downto 0)
    );
end key_schedule;

architecture behavioral of key_schedule is

    component sbox is
        port(
            nibble : in  std_logic_vector(3 downto 0);
            otp    : out std_logic_vector(3 downto 0)
        );
    end component;

    signal round_key   : std_logic_vector(63 downto 0);
    signal rotated_key : std_logic_vector(79 downto 0);
    signal new_key     : std_logic_vector(79 downto 0);
    signal sbox_output : std_logic_vector(3 downto 0);

begin

    round_key <= key(79 downto 16); -- extrai a chave usada nessa rodada

    rotated_key <= std_logic_vector(rotate_left(unsigned(key), 61)); --rotaciona a chave pós extração

    sbox_key: sbox 
        port map(
            nibble => rotated_key(79 downto 76),
            otp    => sbox_output
        ); --substitui os quatro bits mais significativos da chave pós rotação

    -- monta a nova chave

    new_key(79 downto 76) <= sbox_output;

    new_key(75 downto 20) <= rotated_key(75 downto 20);

    new_key(19 downto 15) <= std_logic_vector(unsigned(rotated_key(19 downto 15)) xor count); 

    new_key(14 downto 0) <= rotated_key(14 downto 0);

    -- -- -- --

    -- key atualizada
    next_key <= new_key;

    --addKeyRound 
    new_state <= state xor round_key;

end behavioral;

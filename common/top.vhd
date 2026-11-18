
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
-- top level: 1 rodada de cifra 
entity top is
    port(
        state       : in  std_logic_vector(63 downto 0); --o que vai ser cifrado
        key         : in  std_logic_vector(79 downto 0); --chave 
        count       : in  unsigned(4 downto 0);
        new_state   : out std_logic_vector(63 downto 0);
        next_key    : out std_logic_vector(79 downto 0)
    );
end top;

architecture structural of top is

    component key_schedule is
        port(
            state     : in  std_logic_vector(63 downto 0);
            key       : in  std_logic_vector(79 downto 0);
            count     : in  unsigned(4 downto 0);
            new_state : out std_logic_vector(63 downto 0);
            next_key  : out std_logic_vector(79 downto 0)
        );
    end component;

    component sbox_layer is
        port(
            state     : in  std_logic_vector(63 downto 0);
            new_state : out std_logic_vector(63 downto 0)
        );
    end component;

    component pLayer is
        port(
            state     : in  std_logic_vector(63 downto 0);
            new_state : out std_logic_vector(63 downto 0)
        );
    end component;

    signal state_add  : std_logic_vector(63 downto 0); --state pós xor com key
    signal state_sbox : std_logic_vector(63 downto 0);--state pós sbox layer

begin

    ks: key_schedule
        port map(
            state     => state,
            key       => key,
            count     => count,
            new_state => state_add,
            next_key  => next_key
        ); --keyschedule e addroundkey

    sl: sbox_layer 
        port map(
            state     => state_add,
            new_state => state_sbox
        ); -- sbox layer

    pl: pLayer
        port map(
            state     => state_sbox,
            new_state => new_state
        ); --permutação

end structural;

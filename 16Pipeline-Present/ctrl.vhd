
library ieee;
use ieee.std_logic_1164.all;

entity ctrl16 is
    port(
        clk      : in  std_logic;
        rst      : in  std_logic;
        valid_in : in  std_logic;
        valid_out    : out std_logic
    );
end ctrl16;

architecture behavioral of ctrl16 is

    signal valid_sr : std_logic_vector(14 downto 0);

begin

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                valid_sr <= (others => '0');
                valid_out    <= '0';

            else
                valid_sr(0) <= valid_in;

                for i in 1 to 14 loop
                    valid_sr(i) <= valid_sr(i - 1);
                end loop;

                valid_out <= valid_sr(13);

            end if;
        end if;
    end process;

end behavioral;

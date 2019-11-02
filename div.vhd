LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY div IS
    PORT (
        clk : IN STD_LOGIC;
        clk_out : OUT STD_LOGIC);
END div;

ARCHITECTURE div_arch OF div IS
    SIGNAL tmp : INTEGER RANGE 0 TO 4;
    SIGNAL clktmp : STD_LOGIC;
BEGIN
    PROCESS (clk)
    BEGIN
        IF clk'event AND clk = '0' THEN
            IF tmp = 4 THEN
                tmp <= 0;
                clktmp <= NOT clktmp;
            ELSE
                tmp <= tmp + 1;
            END IF;
        END IF;
    END PROCESS;
    clk_out <= clktmp;
END div_arch;
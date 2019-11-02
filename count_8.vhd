LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

ENTITY count_8 IS
    PORT (
        clk : IN STD_LOGIC;
        q1 : OUT INTEGER RANGE 0 TO 7);
END count_8;

ARCHITECTURE count_8_arch OF count_8 IS
    SIGNAL q1_temp : INTEGER RANGE 0 TO 7;
BEGIN
    PROCESS (clk)
    BEGIN

        IF (clk'event AND clk = '1') THEN
            IF q1_temp = 7 THEN
                q1_temp <= 0;
            ELSE
                q1_temp <= q1_temp + 1;
            END IF;
        END IF;
    END PROCESS;
    q1 <= q1_temp;
END count_8_arch;
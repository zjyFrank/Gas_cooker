LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.STD_LOGIC_arith.ALL;
ENTITY LCD IS
  PORT (
    clk : IN STD_LOGIC;
    rs : OUT STD_LOGIC;
    rw : OUT STD_LOGIC;
    en : OUT STD_LOGIC;
    data : OUT STD_LOGIC_vector(7 DOWNTO 0);
    choice_in : IN INTEGER RANGE 0 TO 5);
END LCD;

ARCHITECTURE ARCH OF LCD IS
  SIGNAL Content : STRING(1 TO 32); --显示内容的缓存变量，32字节
  SIGNAL state : INTEGER RANGE 0 TO 5;
  CONSTANT Content0 : STRING(1 TO 32) := "ZJY Gas_cooker  closed          ";--熄火
  CONSTANT Content1 : STRING(1 TO 32) := "micro fire                      ";--微火
  CONSTANT Content2 : STRING(1 TO 32) := "small fire                      ";--小火
  CONSTANT Content3 : STRING(1 TO 32) := "middle fire                     ";--中火
  CONSTANT Content4 : STRING(1 TO 32) := "big fire                        ";--大火
  CONSTANT Content5 : STRING(1 TO 32) := "test                            ";--测试
  --将字符转换为所对应的ASCII码
  FUNCTION char_to_integer (char_in : CHARACTER) RETURN INTEGER IS
    VARIABLE integer_out : INTEGER RANGE 0 TO 16#7F#;
  BEGIN
    CASE char_in IS
      WHEN ' ' => integer_out := 32;
      WHEN '0' => integer_out := 48;
      WHEN '1' => integer_out := 49;
      WHEN '2' => integer_out := 50;
      WHEN '3' => integer_out := 51;
      WHEN '4' => integer_out := 52;
      WHEN '5' => integer_out := 53;
      WHEN '6' => integer_out := 54;
      WHEN '7' => integer_out := 55;
      WHEN '8' => integer_out := 56;
      WHEN '9' => integer_out := 57;
      WHEN 'A' => integer_out := 65;
      WHEN 'B' => integer_out := 66;
      WHEN 'C' => integer_out := 67;
      WHEN 'D' => integer_out := 68;
      WHEN 'E' => integer_out := 69;
      WHEN 'F' => integer_out := 70;
      WHEN 'G' => integer_out := 71;
      WHEN 'H' => integer_out := 72;
      WHEN 'I' => integer_out := 73;
      WHEN 'J' => integer_out := 74;
      WHEN 'K' => integer_out := 75;
      WHEN 'L' => integer_out := 76;
      WHEN 'M' => integer_out := 77;
      WHEN 'N' => integer_out := 78;
      WHEN 'O' => integer_out := 79;
      WHEN 'P' => integer_out := 80;
      WHEN 'Q' => integer_out := 81;
      WHEN 'R' => integer_out := 82;
      WHEN 'S' => integer_out := 83;
      WHEN 'T' => integer_out := 84;
      WHEN 'U' => integer_out := 85;
      WHEN 'V' => integer_out := 86;
      WHEN 'W' => integer_out := 87;
      WHEN 'X' => integer_out := 88;
      WHEN 'Y' => integer_out := 89;
      WHEN 'Z' => integer_out := 90;
      WHEN 'a' => integer_out := 97;
      WHEN 'b' => integer_out := 98;
      WHEN 'c' => integer_out := 99;
      WHEN 'd' => integer_out := 100;
      WHEN 'e' => integer_out := 101;
      WHEN 'f' => integer_out := 102;
      WHEN 'g' => integer_out := 103;
      WHEN 'h' => integer_out := 104;
      WHEN 'i' => integer_out := 105;
      WHEN 'j' => integer_out := 106;
      WHEN 'k' => integer_out := 107;
      WHEN 'l' => integer_out := 108;
      WHEN 'm' => integer_out := 109;
      WHEN 'n' => integer_out := 110;
      WHEN 'o' => integer_out := 111;
      WHEN 'p' => integer_out := 112;
      WHEN 'q' => integer_out := 113;
      WHEN 'r' => integer_out := 114;
      WHEN 's' => integer_out := 115;
      WHEN 't' => integer_out := 116;
      WHEN 'u' => integer_out := 117;
      WHEN 'v' => integer_out := 118;
      WHEN 'w' => integer_out := 119;
      WHEN 'x' => integer_out := 120;
      WHEN 'y' => integer_out := 121;
      WHEN 'z' => integer_out := 122;
      WHEN OTHERS => integer_out := 32;
    END CASE;
    RETURN integer_out;
  END FUNCTION;

BEGIN
  rw <= '0';
  en <= clk;
  PROCESS (state) --切换信息显示
  BEGIN
  state <= choice_in;
    CASE state IS
      WHEN 0 => Content <= Content0;
      WHEN 1 => Content <= Content1;
      WHEN 2 => Content <= Content2;
      WHEN 3 => Content <= Content3;
      WHEN 4 => Content <= Content4;
      WHEN 5 => Content <= Content5;
    END CASE;
  END PROCESS;

  PROCESS (clk)
    VARIABLE cnt : INTEGER RANGE 0 TO 40;
  BEGIN
    IF clk'event AND clk = '1'THEN
      IF cnt=38 THEN
        cnt:=1;
      END IF;
      CASE cnt IS
        WHEN 0  => rs <= '0'; data <= "00000001";  --clear_display <= 0;
        WHEN 1  => rs <= '0'; data <= "00111000";  --set_function <= 1;
        WHEN 2  => rs <= '0'; data <= "00001100";  --set_display <= 2;
        WHEN 3  => rs <= '0'; data <= "00000110";  --set_cursor <= 3;
        WHEN 4  => rs <= '0'; data <= "10000000";  --set_ddram <= 4;
        WHEN 5  => rs <= '1'; data<=CONV_STD_LOGIC_VECTOR(char_to_integer (Content(1)),8);
        WHEN 6  => rs <= '1'; data<=CONV_STD_LOGIC_VECTOR(char_to_integer (Content(2)),8);
        WHEN 7  => rs <= '1'; data<=CONV_STD_LOGIC_VECTOR(char_to_integer (Content(3)),8);
        WHEN 8  => rs <= '1'; data<=CONV_STD_LOGIC_VECTOR(char_to_integer (Content(4)),8);
        WHEN 9  => rs <= '1'; data<=CONV_STD_LOGIC_VECTOR(char_to_integer (Content(5)),8);
        WHEN 10 => rs <= '1'; data<=CONV_STD_LOGIC_VECTOR(char_to_integer (Content(6)),8);
        WHEN 11 => rs <= '1'; data<=CONV_STD_LOGIC_VECTOR(char_to_integer (Content(7)),8);
        WHEN 12 => rs <= '1'; data<=CONV_STD_LOGIC_VECTOR(char_to_integer (Content(8)),8);
        WHEN 13 => rs <= '1'; data<=CONV_STD_LOGIC_VECTOR(char_to_integer (Content(9)),8);
        WHEN 14 => rs <= '1'; data<=CONV_STD_LOGIC_VECTOR(char_to_integer (Content(10)),8);
        WHEN 15 => rs <= '1'; data<=CONV_STD_LOGIC_VECTOR(char_to_integer (Content(11)),8);
        WHEN 16 => rs <= '1'; data<=CONV_STD_LOGIC_VECTOR(char_to_integer (Content(12)),8);
        WHEN 17 => rs <= '1'; data<=CONV_STD_LOGIC_VECTOR(char_to_integer (Content(13)),8);
        WHEN 18 => rs <= '1'; data<=CONV_STD_LOGIC_VECTOR(char_to_integer (Content(14)),8);
        WHEN 19 => rs <= '1'; data<=CONV_STD_LOGIC_VECTOR(char_to_integer (Content(15)),8);
        WHEN 20 => rs <= '1'; data<=CONV_STD_LOGIC_VECTOR(char_to_integer (Content(16)),8);
        WHEN 21 => rs <= '0'; data<="11000000";                   --切换到lcd第二行
        WHEN 22 => rs <= '1'; data<=CONV_STD_LOGIC_VECTOR(char_to_integer (Content(17)),8);
        WHEN 23 => rs <= '1'; data<=CONV_STD_LOGIC_VECTOR(char_to_integer (Content(18)),8);
        WHEN 24 => rs <= '1'; data<=CONV_STD_LOGIC_VECTOR(char_to_integer (Content(19)),8);
        WHEN 25 => rs <= '1'; data<=CONV_STD_LOGIC_VECTOR(char_to_integer (Content(20)),8);
        WHEN 26 => rs <= '1'; data<=CONV_STD_LOGIC_VECTOR(char_to_integer (Content(21)),8);
        WHEN 27 => rs <= '1'; data<=CONV_STD_LOGIC_VECTOR(char_to_integer (Content(22)),8);
        WHEN 28 => rs <= '1'; data<=CONV_STD_LOGIC_VECTOR(char_to_integer (Content(23)),8);
        WHEN 29 => rs <= '1'; data<=CONV_STD_LOGIC_VECTOR(char_to_integer (Content(24)),8);
        WHEN 30 => rs <= '1'; data<=CONV_STD_LOGIC_VECTOR(char_to_integer (Content(25)),8);
        WHEN 31 => rs <= '1'; data<=CONV_STD_LOGIC_VECTOR(char_to_integer (Content(26)),8);
        WHEN 32 => rs <= '1'; data<=CONV_STD_LOGIC_VECTOR(char_to_integer (Content(27)),8);
        WHEN 33 => rs <= '1'; data<=CONV_STD_LOGIC_VECTOR(char_to_integer (Content(28)),8);
        WHEN 34 => rs <= '1'; data<=CONV_STD_LOGIC_VECTOR(char_to_integer (Content(29)),8);
        WHEN 35 => rs <= '1'; data<=CONV_STD_LOGIC_VECTOR(char_to_integer (Content(30)),8);
        WHEN 36 => rs <= '1'; data<=CONV_STD_LOGIC_VECTOR(char_to_integer (Content(31)),8);
        WHEN 37 => rs <= '1'; data<=CONV_STD_LOGIC_VECTOR(char_to_integer (Content(32)),8);
        when others=>    RS<='0';data<="00000000";
      END CASE;
      cnt:=cnt+1;
    END IF;
  END PROCESS;
END ARCH;

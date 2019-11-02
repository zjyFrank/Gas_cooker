LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY BTN_ctrl IS
	PORT (
		clk : IN STD_LOGIC; --100Hz
		clk2 : IN STD_LOGIC;--1000Hz
		BTN7 : IN STD_LOGIC;--开关火
		BTN6 : IN STD_LOGIC;--增大活力
		BTN5 : IN STD_LOGIC;--减小活力
		BTN0 : IN STD_LOGIC;--计时器开始计时
		BTN2 : IN STD_LOGIC;--时间默认值
		timer_on_disp : IN STD_LOGIC;--数码管显示开关(SW0)
		state : OUT INTEGER RANGE 0 TO 8;
		rst : IN STD_LOGIC; --时间清零(BTN1)
		row : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		column : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		time_disp : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);--七段数码管
		disp : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);--八个数码管
		beep : OUT STD_LOGIC;
		choice_out : OUT INTEGER RANGE 0 TO 5);--lcd显示信息选择
END BTN_ctrl;

ARCHITECTURE BTN_ctrl_arch OF BTN_ctrl IS
	SIGNAL state_temp : INTEGER RANGE 0 TO 8;
	SIGNAL alert1 : INTEGER RANGE 0 TO 1;
	SIGNAL alert2 : INTEGER RANGE 0 TO 1;
	SIGNAL alert : INTEGER RANGE 0 TO 1;
	SIGNAL beep_cnt : INTEGER RANGE 0 TO 100;--蜂鸣器持续时间
	SIGNAL beep_temp : STD_LOGIC;
	SIGNAL sound1 : INTEGER RANGE 0 TO 1; --open sound
	SIGNAL sound2 : INTEGER RANGE 0 TO 1; --min/max sound
	SIGNAL tmp1 : INTEGER RANGE 0 TO 499;
	SIGNAL tmp2 : INTEGER RANGE 0 TO 1000;
	SIGNAL q1_temp : INTEGER RANGE 0 TO 3;
	SIGNAL scan_key : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL key_code : INTEGER RANGE 0 TO 16;--分钟计数
	SIGNAL sec_cnt : INTEGER RANGE 0 TO 59;--秒钟计数
	SIGNAL min : STD_LOGIC_VECTOR(13 DOWNTO 0);--分钟数码管
	SIGNAL sec : STD_LOGIC_VECTOR(13 DOWNTO 0);--秒钟数码管
	SIGNAL temp : INTEGER RANGE 0 TO 3;--数码管切换显示
	SIGNAL start_temp : INTEGER RANGE 0 TO 1;--计数器启动信号
	SIGNAL fire_over : INTEGER RANGE 0 TO 1;--关火信号
	SIGNAL fire_over_cnt : INTEGER RANGE 0 TO 10;
	SIGNAL choice_temp : INTEGER RANGE 0 TO 5;
BEGIN
	ctrl : PROCESS (clk, BTN7, BTN6, BTN5)
		VARIABLE state_var : INTEGER RANGE 0 TO 8;
		VARIABLE set_fire : INTEGER RANGE 0 TO 1;
		VARIABLE interval : INTEGER RANGE 0 TO 500;
	BEGIN
		IF (clk'event AND clk = '0') THEN
			--------------------------音效控制 start---------------------------
			IF alert1 = 1 THEN
				IF sound1 = 1 THEN --open sound(bi-bi-bi-)
					IF beep_cnt < 20 THEN
						alert2 <= alert1;
					ELSIF beep_cnt >= 20 AND beep_cnt < 40 THEN
						alert2 <= 0;
					ELSIF beep_cnt >= 40 AND beep_cnt < 60 THEN
						alert2 <= alert1;
					ELSIF beep_cnt >= 60 AND beep_cnt < 80 THEN
						alert2 <= 0;
					ELSIF beep_cnt >= 80 AND beep_cnt < 99 THEN
						alert2 <= alert1;
					END IF;
				END IF;
				IF sound2 = 1 THEN --max/min sound(bi------)
					IF beep_cnt < 99 THEN
						alert2 <= alert1;
					END IF;
				END IF;
				beep_cnt <= beep_cnt + 1;
				IF beep_cnt = 99 THEN
					beep_cnt <= 0;
					alert1 <= 0;
					alert2 <= 0;
					sound1 <= 0;
					sound2 <= 0;
				END IF;
			END IF;
			--------------------------音效控制 end---------------------------

			--------------------------火力控制 start---------------------------
			IF fire_over = 1 THEN
				state_var := 0;
			END IF;
			----熄火----
			IF (state_var = 0) THEN
				IF (BTN7 = '1') THEN
					set_fire := 1;
					sound1 <= 1;
				ELSE
					state_var := 0;
					choice_temp <= 0;
				END IF;
				----微火----
			ELSIF (state_var = 1) THEN
				IF (BTN7 = '1') THEN
					state_var := 0;
				ELSIF (BTN6 = '1') THEN
					state_var := 2;
				ELSIF (BTN5 = '1') THEN
					state_var := 1;
					alert1 <= 1;
					sound2 <= 1;
				ELSE
					state_var := 1;
					choice_temp <= 1;
				END IF;
				----小火----
			ELSIF (state_var = 2) THEN
				IF (BTN7 = '1') THEN
					state_var := 0;
				ELSIF (BTN6 = '1') THEN
					state_var := 3;
				ELSIF (BTN5 = '1') THEN
					state_var := 1;
				ELSE
					state_var := 2;
					choice_temp <= 2;
				END IF;
				----中火----
			ELSIF (state_var = 3) THEN
				IF (BTN7 = '1') THEN
					state_var := 0;
				ELSIF (BTN6 = '1') THEN
					state_var := 4;
				ELSIF (BTN5 = '1') THEN
					state_var := 2;
				ELSE
					state_var := 3;
					choice_temp <= 3;
				END IF;
				----大火----
			ELSIF (state_var = 4) THEN
				IF (BTN7 = '1') THEN
					state_var := 0;
				ELSIF (BTN6 = '1') THEN
					state_var := 4;
					alert1 <= 1;
					sound2 <= 1;
				ELSIF (BTN5 = '1') THEN
					state_var := 3;
				ELSE
					state_var := 4;
					choice_temp <= 4;
				END IF;
			END IF;
			--------------------------火力控制 end---------------------------
			--------------------------点火动画控制 start---------------------
			IF set_fire = 1 THEN
				alert1 <= 1;
				IF interval <= 80 THEN
					state_var := 5;
					IF interval = 20 THEN
						state_var := 6;
					ELSIF interval = 40 THEN
						state_var := 7;
					ELSIF interval = 60 THEN
						state_var := 8;
					ELSIF interval = 80 THEN
						state_var := 2;
						set_fire := 0;
						interval := 0;
					END IF;
					interval := interval + 1;
				END IF;
			END IF;
			--------------------------点火动画控制 end---------------------
		END IF;
		state_temp <= state_var;
	END PROCESS;
	--------------------------蜂鸣器鸣叫 start---------------------
	PROCESS (clk2)
	BEGIN
		IF (clk2'event AND clk2 = '1') THEN
			alert <= alert2;
		END IF;
		IF alert = 1 THEN
			IF clk2 = '1' THEN
				beep_temp <= '1';
			ELSE
				beep_temp <= '0';
			END IF;
		END IF;
	END PROCESS;
	--------------------------蜂鸣器鸣叫 end---------------------

	---------------------------倒计时 start----------------------
	column <= scan_key;

	PROCESS (clk)
	BEGIN
		IF rst = '1' THEN
			q1_temp <= 0;
		ELSIF (clk'event AND clk = '1') THEN
			IF q1_temp = 3 THEN
				q1_temp <= 0;
			ELSE
				q1_temp <= q1_temp + 1;
			END IF;
		END IF;
	END PROCESS;

	PROCESS (q1_temp)
	BEGIN
		CASE q1_temp IS
			WHEN 0 => scan_key <= "1110";
			WHEN 1 => scan_key <= "1101";
			WHEN 2 => scan_key <= "1011";
			WHEN 3 => scan_key <= "0111";
		END CASE;
	END PROCESS;

	PROCESS (clk2, rst)
	BEGIN
		IF (clk2'EVENT AND clk2 = '1') THEN
			IF BTN2 = '1' THEN
				key_code <= 5;
			END IF;
			IF (rst = '1') THEN
				key_code <= 0;
				sec_cnt <= 0;
			END IF;
			CASE scan_key IS
				WHEN "1110" =>
					CASE row IS
						WHEN "0111" => key_code <= 1;--1
						WHEN "1011" => key_code <= 5;--5
						WHEN "1101" => key_code <= 9;--9
						WHEN "1110" => key_code <= 13;--13
						WHEN OTHERS => NULL;
					END CASE;
				WHEN "1101" =>
					CASE row IS
						WHEN "0111" => key_code <= 2;--2
						WHEN "1011" => key_code <= 6;--6
						WHEN "1101" => key_code <= 10;--10
						WHEN "1110" => key_code <= 14;--14
						WHEN OTHERS => NULL;
					END CASE;
				WHEN "1011" =>
					CASE row IS
						WHEN "0111" => key_code <= 3;--3
						WHEN "1011" => key_code <= 7;--7
						WHEN "1101" => key_code <= 11;--11
						WHEN "1110" => key_code <= 15;--15
						WHEN OTHERS => NULL;
					END CASE;
				WHEN "0111" =>
					CASE row IS
						WHEN "0111" => key_code <= 4;--4
						WHEN "1011" => key_code <= 8;--8
						WHEN "1101" => key_code <= 12;--12
						WHEN "1110" => key_code <= 16;--16
						WHEN OTHERS => NULL;
					END CASE;
				WHEN OTHERS => NULL;
			END CASE;
			IF fire_over_cnt = 9 THEN
				fire_over <= 0;
				fire_over_cnt <= 0;
			ELSE
				fire_over_cnt <= fire_over_cnt + 1;
			END IF;

			IF BTN0 = '1' THEN
				start_temp <= 1;
			END IF;
			IF start_temp = 1 THEN
				IF tmp2 = 999 THEN	--一秒
					tmp2 <= 0;
					IF sec_cnt = 0 THEN	
						sec_cnt <= 59;
						key_code <= key_code - 1;
						IF key_code = 0 THEN	--先判断分钟
							key_code <= 0;
							IF sec_cnt = 0 THEN	--后判断秒
								sec_cnt <= 0;
								fire_over <= 1;
								start_temp <= 0;
							END IF;
						END IF;
					ELSE
						sec_cnt <= sec_cnt - 1;
					END IF;
				ELSE
					tmp2 <= tmp2 + 1;
				END IF;
			END IF;
			IF (key_code = 0 AND sec_cnt = 0) THEN
				fire_over <= 1;
			END IF;
		END IF;
	END PROCESS;
	---------------------------倒计时 end----------------------
	------------------------分钟数码管编码 start------------------
	PROCESS (key_code)
	BEGIN
		CASE key_code IS
			WHEN 0 => min <= "11111101111110";--00
			WHEN 1 => min <= "11111100110000";--01
			WHEN 2 => min <= "11111101101101";--02
			WHEN 3 => min <= "11111101111001";--03
			WHEN 4 => min <= "11111100110011";--04
			WHEN 5 => min <= "11111101011011";--05
			WHEN 6 => min <= "11111101011111";--06
			WHEN 7 => min <= "11111101110000";--07
			WHEN 8 => min <= "11111101111111";--08
			WHEN 9 => min <= "11111101111011";--09		
			WHEN 10 => min <= "01100001111110";--10		
			WHEN 11 => min <= "01100000110000";--11			
			WHEN 12 => min <= "01100001101101";--12		
			WHEN 13 => min <= "01100001111001";--13			
			WHEN 14 => min <= "01100000110011";--14
			WHEN 15 => min <= "01100001011011";--15		
			WHEN 16 => min <= "01100001011111";--16			
			WHEN OTHERS => min <= "11111101111110";--00
		END CASE;
	END PROCESS;
	------------------------分钟数码管编码 end------------------
	------------------------秒钟数码管编码 start------------------
	PROCESS (sec_cnt)
	BEGIN

		CASE(sec_cnt) IS
			WHEN 0 => sec <= "11111101111110";--0
			WHEN 1 => sec <= "11111100110000";--1
			WHEN 2 => sec <= "11111101101101";--2
			WHEN 3 => sec <= "11111101111001";--3
			WHEN 4 => sec <= "11111100110011";--4
			WHEN 5 => sec <= "11111101011011";--5
			WHEN 6 => sec <= "11111101011111";--6
			WHEN 7 => sec <= "11111101110000";--7
			WHEN 8 => sec <= "11111101111111";--8
			WHEN 9 => sec <= "11111101111011";--9
			WHEN 10 => sec <= "01100001111110";--10
			WHEN 11 => sec <= "01100000110000";--11
			WHEN 12 => sec <= "01100001101101";--12
			WHEN 13 => sec <= "01100001111001";--13
			WHEN 14 => sec <= "01100000110011";--14
			WHEN 15 => sec <= "01100001011011";--15
			WHEN 16 => sec <= "01100001011111";--16
			WHEN 17 => sec <= "01100001110000";--17
			WHEN 18 => sec <= "01100001111111";--18
			WHEN 19 => sec <= "01100001111011";--19
			WHEN 20 => sec <= "11011011111110";--20
			WHEN 21 => sec <= "11011010110000";--21
			WHEN 22 => sec <= "11011011101101";--22
			WHEN 23 => sec <= "11011011111001";--23
			WHEN 24 => sec <= "11011010110011";--24
			WHEN 25 => sec <= "11011011011011";--25
			WHEN 26 => sec <= "11011011011111";--26
			WHEN 27 => sec <= "11011011110000";--27
			WHEN 28 => sec <= "11011011111111";--28
			WHEN 29 => sec <= "11011011111011";--29
			WHEN 30 => sec <= "11110011111110";--30
			WHEN 31 => sec <= "11110010110000";--31
			WHEN 32 => sec <= "11110011101101";--32
			WHEN 33 => sec <= "11110011111001";--33
			WHEN 34 => sec <= "11110010110011";--34
			WHEN 35 => sec <= "11110011011011";--35
			WHEN 36 => sec <= "11110011011111";--36
			WHEN 37 => sec <= "11110011110000";--37
			WHEN 38 => sec <= "11110011111111";--38
			WHEN 39 => sec <= "11110011111011";--39
			WHEN 40 => sec <= "01100111111110";--40
			WHEN 41 => sec <= "01100110110000";--41
			WHEN 42 => sec <= "01100111101101";--42
			WHEN 43 => sec <= "01100111111001";--43
			WHEN 44 => sec <= "01100110110011";--44
			WHEN 45 => sec <= "01100111011011";--45
			WHEN 46 => sec <= "01100111011111";--46
			WHEN 47 => sec <= "01100111110000";--47
			WHEN 48 => sec <= "01100111111111";--48
			WHEN 49 => sec <= "01100111111011";--49
			WHEN 50 => sec <= "10110111111110";--50
			WHEN 51 => sec <= "10110110110000";--51
			WHEN 52 => sec <= "10110111101101";--52
			WHEN 53 => sec <= "10110111111001";--53
			WHEN 54 => sec <= "10110110110011";--54
			WHEN 55 => sec <= "10110111011011";--55
			WHEN 56 => sec <= "10110111011111";--56
			WHEN 57 => sec <= "10110111110000";--57
			WHEN 58 => sec <= "10110111111111";--58
			WHEN 59 => sec <= "10110111111011";--59
			WHEN OTHERS => NULL;
		END CASE;
	END PROCESS;
	------------------------秒钟数码管编码 start------------------
	------------------------数码管切换显示 start------------------
	PROCESS (clk2)
	BEGIN
		IF clk2'event AND clk2 = '0' THEN
			IF timer_on_disp = '1' THEN
				IF (temp = 0) THEN
					time_disp <= min(6 DOWNTO 0);
					disp <= "11101111";
					temp <= temp + 1;
				ELSIF (temp = 1) THEN
					time_disp <= min(13 DOWNTO 7);
					disp <= "11011111";
					temp <= temp + 1;
				ELSIF temp = 2 THEN
					time_disp <= sec(6 DOWNTO 0);
					disp <= "11111011";
					temp <= temp + 1;
				ELSIF temp = 3 THEN
					time_disp <= sec(13 DOWNTO 7);
					disp <= "11110111";
					temp <= temp - 3;
				END IF;
			ELSE
				disp <= "11111111";
			END IF;
		END IF;
	END PROCESS;
	------------------------数码管切换显示 end------------------
	beep <= beep_temp;
	state <= state_temp;
	choice_out <= choice_temp;
END BTN_ctrl_arch;
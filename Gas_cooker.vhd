LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

ENTITY Gas_cooker IS
	PORT (
		clk_in, BTN7_in, BTN6_in, BTN5_in ,BTN0_in ,BTN2_in ,timer_on_disp_in: IN STD_LOGIC;
		row_out, colr_out, colg_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		rst_in : IN std_logic; --reset
		row_in : IN std_logic_vector(3 DOWNTO 0);
		column_out : OUT std_logic_vector(3 DOWNTO 0);
		time_disp_out : OUT std_logic_vector(6 DOWNTO 0);
		disp_out : OUT std_logic_vector(7 DOWNTO 0);
		beep_out : OUT std_logic;
		rs_out : OUT std_logic;
		rw_out : OUT std_logic;
		en_out : OUT std_logic;
		data_out : OUT std_logic_vector(7 DOWNTO 0));
END Gas_cooker;

ARCHITECTURE Gas_cooker_arch OF Gas_cooker IS
	COMPONENT div
		PORT (
			clk : IN STD_LOGIC;
			clk_out : OUT STD_LOGIC);
	END COMPONENT;

	COMPONENT count_8
		PORT (
			clk : IN STD_LOGIC;
			q1 : OUT INTEGER RANGE 0 TO 7);
	END COMPONENT;

	COMPONENT BTN_ctrl
		PORT (
			clk, clk2, BTN7, BTN6, BTN5 ,BTN0 ,BTN2 ,timer_on_disp: IN STD_LOGIC;
			state : OUT INTEGER RANGE 0 TO 8;
			rst : IN std_logic; --reset
			row : IN std_logic_vector(3 DOWNTO 0);
			column : OUT std_logic_vector(3 DOWNTO 0);
			time_disp : OUT std_logic_vector(6 DOWNTO 0);
			disp : OUT std_logic_vector(7 DOWNTO 0);
			beep : OUT STD_LOGIC;
			choice_out : OUT INTEGER RANGE 0 TO 5);
	END COMPONENT;

	COMPONENT display_8x8
		PORT (
			state : IN INTEGER RANGE 0 TO 8;
			row_num : IN INTEGER RANGE 0 TO 7;
			row, colr, colg : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
	END COMPONENT;

	COMPONENT keyin
		PORT (
			clk, reset : IN STD_LOGIC;
			resetn : OUT STD_LOGIC);
	END COMPONENT;
	
	COMPONENT LCD
		PORT (
			clk : IN std_logic;
			rs : OUT std_logic;
			rw : OUT std_logic;
			en : OUT std_logic;
			data : OUT std_logic_vector(7 DOWNTO 0);
			choice_in : IN INTEGER RANGE 0 TO 5);
	END COMPONENT;

	SIGNAL clktmp : STD_LOGIC;
	SIGNAL q1_temp : INTEGER RANGE 0 TO 7;
	SIGNAL BTN7_temp : STD_LOGIC;
	SIGNAL BTN6_temp : STD_LOGIC;
	SIGNAL BTN5_temp : STD_LOGIC;
	SIGNAL BTN0_temp : STD_LOGIC;
	SIGNAL BTN2_temp : STD_LOGIC;
	SIGNAL state_temp : INTEGER RANGE 0 TO 8;
	SIGNAL choice_temp : INTEGER RANGE 0 TO 5;
BEGIN
	u1 : div PORT MAP(clk => clk_in, clk_out => clktmp);
	u2 : keyin PORT MAP(clk => clktmp, reset => BTN7_in, resetn => BTN7_temp);
	u3 : keyin PORT MAP(clk => clktmp, reset => BTN6_in, resetn => BTN6_temp);
	u4 : keyin PORT MAP(clk => clktmp, reset => BTN5_in, resetn => BTN5_temp);
	u5 : keyin PORT MAP(clk => clktmp, reset => BTN0_in, resetn => BTN0_temp);
	u6 : keyin PORT MAP(clk => clktmp, reset => BTN2_in, resetn => BTN2_temp);
	u7 : count_8 PORT MAP(clk => clk_in, q1 => q1_temp);
	u8 : BTN_ctrl PORT MAP(clk => clktmp, clk2 => clk_in, BTN7 => BTN7_temp, BTN6 => BTN6_temp, BTN5 => BTN5_temp, BTN0 => BTN0_temp, BTN2 => BTN2_temp, timer_on_disp =>timer_on_disp_in, state => state_temp,rst =>rst_in, row =>row_in, column => column_out, time_disp => time_disp_out, disp =>disp_out, beep => beep_out,choice_out => choice_temp);
	u9 : display_8x8 PORT MAP(state => state_temp, row_num => q1_temp, row => row_out, colr => colr_out, colg => colg_out);
	u10: LCD PORT MAP(clk => clk_in,rs => rs_out,rw => rw_out,en => en_out,data => data_out,choice_in => choice_temp);
END Gas_cooker_arch;
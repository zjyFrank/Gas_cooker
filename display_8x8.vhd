LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;  
USE IEEE.STD_LOGIC_ARITH.ALL;

ENTITY display_8x8 IS
	PORT(state:IN INTEGER RANGE 0 TO 8;
	row_num:IN INTEGER  RANGE 0 TO 7;
	row,colr,colg:OUT STD_LOGIC_VECTOR(7 downto 0));
END display_8x8;

ARCHITECTURE display_8x8_arch OF display_8x8 IS
SIGNAL row_temp,colr_temp,colg_temp:STD_LOGIC_VECTOR(7 downto 0);
BEGIN
	PROCESS(state,row_num)
	BEGIN
	CASE state IS
		WHEN 0 => CASE row_num IS
					WHEN 0=> row_temp<="11111110";colr_temp<="00000000";colg_temp<="00000000";
					WHEN 1=> row_temp<="11111101";colr_temp<="00000000";colg_temp<="00000000";
					WHEN 2=> row_temp<="11111011";colr_temp<="00000000";colg_temp<="00000000";
					WHEN 3=> row_temp<="11110111";colr_temp<="00000000";colg_temp<="00000000";
					WHEN 4=> row_temp<="11101111";colr_temp<="00000000";colg_temp<="00000000";
					WHEN 5=> row_temp<="11011111";colr_temp<="00000000";colg_temp<="00000000";
					WHEN 6=> row_temp<="10111111";colr_temp<="00000000";colg_temp<="00000000";
					WHEN 7=> row_temp<="01111111";colr_temp<="00000000";colg_temp<="00000000";
				  END CASE;
		WHEN 1 => CASE row_num IS
					WHEN 0=> row_temp<="11111110";colr_temp<="00000000";colg_temp<="00000000";
					WHEN 1=> row_temp<="11111101";colr_temp<="00000000";colg_temp<="00000000";
					WHEN 2=> row_temp<="11111011";colr_temp<="00000000";colg_temp<="00000000";
					WHEN 3=> row_temp<="11110111";colr_temp<="00011000";colg_temp<="00000000";
					WHEN 4=> row_temp<="11101111";colr_temp<="00011000";colg_temp<="00000000";
					WHEN 5=> row_temp<="11011111";colr_temp<="00000000";colg_temp<="00000000";
					WHEN 6=> row_temp<="10111111";colr_temp<="00000000";colg_temp<="00000000";
					WHEN 7=> row_temp<="01111111";colr_temp<="00000000";colg_temp<="00000000";
				  END CASE;
		WHEN 2 => CASE row_num IS
					WHEN 0=> row_temp<="11111110";colr_temp<="00000000";colg_temp<="00000000";
					WHEN 1=> row_temp<="11111101";colr_temp<="00000000";colg_temp<="00000000";
					WHEN 2=> row_temp<="11111011";colr_temp<="00011000";colg_temp<="00000000";
					WHEN 3=> row_temp<="11110111";colr_temp<="00100100";colg_temp<="00000000";
					WHEN 4=> row_temp<="11101111";colr_temp<="00100100";colg_temp<="00000000";
					WHEN 5=> row_temp<="11011111";colr_temp<="00011000";colg_temp<="00000000";
					WHEN 6=> row_temp<="10111111";colr_temp<="00000000";colg_temp<="00000000";
					WHEN 7=> row_temp<="01111111";colr_temp<="00000000";colg_temp<="00000000";
				  END CASE;
		WHEN 3 => CASE row_num IS
					WHEN 0=> row_temp<="11111110";colr_temp<="00000000";colg_temp<="00000000";
					WHEN 1=> row_temp<="11111101";colr_temp<="00011000";colg_temp<="00000000";
					WHEN 2=> row_temp<="11111011";colr_temp<="00100100";colg_temp<="00000000";
					WHEN 3=> row_temp<="11110111";colr_temp<="01011010";colg_temp<="00000000";
					WHEN 4=> row_temp<="11101111";colr_temp<="01011010";colg_temp<="00000000";
					WHEN 5=> row_temp<="11011111";colr_temp<="00100100";colg_temp<="00000000";
					WHEN 6=> row_temp<="10111111";colr_temp<="00011000";colg_temp<="00000000";
					WHEN 7=> row_temp<="01111111";colr_temp<="00000000";colg_temp<="00000000";
				  END CASE;
		WHEN 4 => CASE row_num IS
					WHEN 0=> row_temp<="11111110";colr_temp<="00011000";colg_temp<="00011000";
					WHEN 1=> row_temp<="11111101";colr_temp<="00100100";colg_temp<="00100100";
					WHEN 2=> row_temp<="11111011";colr_temp<="01011010";colg_temp<="01000010";
					WHEN 3=> row_temp<="11110111";colr_temp<="10111101";colg_temp<="10000001";
					WHEN 4=> row_temp<="11101111";colr_temp<="10111101";colg_temp<="10000001";
					WHEN 5=> row_temp<="11011111";colr_temp<="01011010";colg_temp<="01000010";
					WHEN 6=> row_temp<="10111111";colr_temp<="00100100";colg_temp<="00100100";
					WHEN 7=> row_temp<="01111111";colr_temp<="00011000";colg_temp<="00011000";
				  END CASE;
		WHEN 5 => CASE row_num IS
					WHEN 0=> row_temp<="11111110";colr_temp<="00000000";colg_temp<="00000000";
					WHEN 1=> row_temp<="11111101";colr_temp<="00000000";colg_temp<="00000000";
					WHEN 2=> row_temp<="11111011";colr_temp<="00000000";colg_temp<="00000000";
					WHEN 3=> row_temp<="11110111";colr_temp<="00000000";colg_temp<="00011000";
					WHEN 4=> row_temp<="11101111";colr_temp<="00000000";colg_temp<="00011000";
					WHEN 5=> row_temp<="11011111";colr_temp<="00000000";colg_temp<="00000000";
					WHEN 6=> row_temp<="10111111";colr_temp<="00000000";colg_temp<="00000000";
					WHEN 7=> row_temp<="01111111";colr_temp<="00000000";colg_temp<="00000000";	
				  END CASE;
		WHEN 6 => CASE row_num IS
					WHEN 0=> row_temp<="11111110";colr_temp<="00000000";colg_temp<="00000000";
					WHEN 1=> row_temp<="11111101";colr_temp<="00000000";colg_temp<="00000000";
					WHEN 2=> row_temp<="11111011";colr_temp<="00000000";colg_temp<="00000000";
					WHEN 3=> row_temp<="11110111";colr_temp<="00011000";colg_temp<="00011000";
					WHEN 4=> row_temp<="11101111";colr_temp<="00011000";colg_temp<="00011000";
					WHEN 5=> row_temp<="11011111";colr_temp<="00000000";colg_temp<="00000000";
					WHEN 6=> row_temp<="10111111";colr_temp<="00000000";colg_temp<="00000000";
					WHEN 7=> row_temp<="01111111";colr_temp<="00000000";colg_temp<="00000000";	
				  END CASE;
		WHEN 7 => CASE row_num IS
					WHEN 0=> row_temp<="11111110";colr_temp<="00000000";colg_temp<="00000000";
					WHEN 1=> row_temp<="11111101";colr_temp<="00000000";colg_temp<="00000000";
					WHEN 2=> row_temp<="11111011";colr_temp<="00011000";colg_temp<="00011000";
					WHEN 3=> row_temp<="11110111";colr_temp<="00100100";colg_temp<="00100100";
					WHEN 4=> row_temp<="11101111";colr_temp<="00100100";colg_temp<="00100100";
					WHEN 5=> row_temp<="11011111";colr_temp<="00011000";colg_temp<="00011000";
					WHEN 6=> row_temp<="10111111";colr_temp<="00000000";colg_temp<="00000000";
					WHEN 7=> row_temp<="01111111";colr_temp<="00000000";colg_temp<="00000000";	
				  END CASE;
		WHEN 8 => CASE row_num IS
					WHEN 0=> row_temp<="11111110";colr_temp<="00000000";colg_temp<="00000000";
					WHEN 1=> row_temp<="11111101";colr_temp<="00011000";colg_temp<="00011000";
					WHEN 2=> row_temp<="11111011";colr_temp<="00100100";colg_temp<="00100100";
					WHEN 3=> row_temp<="11110111";colr_temp<="01000010";colg_temp<="01000010";
					WHEN 4=> row_temp<="11101111";colr_temp<="01000010";colg_temp<="01000010";
					WHEN 5=> row_temp<="11011111";colr_temp<="00100100";colg_temp<="00100100";
					WHEN 6=> row_temp<="10111111";colr_temp<="00011000";colg_temp<="00011000";
					WHEN 7=> row_temp<="01111111";colr_temp<="00000000";colg_temp<="00000000";	
				  END CASE;
	END CASE;	
	END PROCESS;
	row<=row_temp;
	colr<=colr_temp;
	colg<=colg_temp;
END display_8x8_arch;

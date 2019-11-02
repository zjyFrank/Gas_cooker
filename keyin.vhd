LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY keyin IS
	PORT(clk,reset :  IN		STD_LOGIC;
	  	  resetn     :  OUT  	STD_LOGIC);
END keyin;
ARCHITECTURE a OF keyin IS
		SIGNAL resetmp1,resetmp2 : STD_LOGIC;
BEGIN
PROCESS(clk)
BEGIN
IF (clk'EVENT AND clk='1') THEN
		resetmp2<= resetmp1;
		resetmp1<= reset;
END IF;
END PROCESS;
resetn<=clk AND resetmp1 AND (NOT resetmp2);
END a;

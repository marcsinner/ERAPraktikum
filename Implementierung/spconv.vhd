library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY spconv IS 
	PORT (
		fsync, sclk, sdata : IN STD_LOGIC;
		flag : OUT STD_LOGIC;
		leftS, rightS : OUT SIGNED(17 DOWNTO 0)
	);
END spconv;

ARCHITECTURE pt OF spconv IS
	SIGNAL counter : UNSIGNED(4 DOWNTO 0);							--counts from 0 up to 18 (18 means current vector is finished)
	SIGNAL leftMemo : SIGNED(17 DOWNTO 0);
	SIGNAL rightMemo : SIGNED(17 DOWNTO 0);
BEGIN
	flag <= '1' WHEN (counter = 18 AND fsync = '0') ELSE '0';
	leftS <= leftMemo;
	rightS <= rightMemo;
	
	PROCESS(fsync)										--resets counter - new vector begins
	BEGIN
		counter <= "00000";
	END PROCESS;
	
	PROCESS(sclk)
	BEGIN
		IF (sclk = '0' AND counter /= 18) THEN
			IF (fsync = '1') THEN
				leftMemo <= sdata & leftMemo(17 DOWNTO 1);
			ELSE
				rightMemo <= sdata & rightMemo(17 DOWNTO 1);
			END IF;
			
			counter <= counter + 1;
		END IF;
	END PROCESS;
END pt;
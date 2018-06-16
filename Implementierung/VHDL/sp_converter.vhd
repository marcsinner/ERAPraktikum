library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY sp_converter IS 
	PORT (
		fsync, sclk, sdata : IN STD_LOGIC;							--fsync: 0 = Right, 1 = Left; 1 fsync cycle = 64 sclk cycles; sclk at 44.1 kHz
		flag : OUT STD_LOGIC;										--rising edge on new signal pair output
		leftS, rightS : OUT SIGNED(17 DOWNTO 0)						--18bit signed parallel outputs
	);
END sp_converter;

ARCHITECTURE shift_memo OF sp_converter IS							--architecture with shift-based memorizing
	SIGNAL counter : UNSIGNED(4 DOWNTO 0);							--counts from 0 up to 18 (18 means current vector is finished)
	SIGNAL leftMemo : SIGNED(17 DOWNTO 0);							--two output memory vectors
	SIGNAL rightMemo : SIGNED(17 DOWNTO 0);
BEGIN
	flag <= '1' WHEN (counter = 18 AND fsync = '0') ELSE '0';
	
	PROCESS(fsync)													--resets counter - new vector begins
	BEGIN
		counter <= "00000";
		
		IF (fsync = '1') THEN
			leftMemo <= "000000000000000000";
		ELSE
			rightMemo <= "000000000000000000";
		END IF;
	END PROCESS;
	
	PROCESS(sclk)
	BEGIN
		IF (sclk = '0') THEN
			IF (counter < 18) THEN
				IF (fsync = '1') THEN
					leftMemo <= leftMemo(16 DOWNTO 0) & sdata;		--shifts first 17 bits to the left and places current sdata value in the front
				ELSE
					rightMemo <= rightMemo(16 DOWNTO 0) & sdata;	--shifts first 17 bits to the left and places current sdata value in the front
				END IF;
				
				counter <= counter + 1;
			ELSE
				IF (fsync = '0') THEN								--upon filling both memo vectors - output assigned
					leftS <= leftMemo;
					rightS <= rightMemo;
				END IF;
			END IF;
		END IF;
	END PROCESS;
END shift_memo;
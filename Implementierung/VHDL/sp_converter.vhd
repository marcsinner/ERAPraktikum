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
	SIGNAL counter : UNSIGNED(4 DOWNTO 0) := "00000";				--counts from 0 up to 18 (18 means current vector is finished)
	SIGNAL leftMemo : SIGNED(17 DOWNTO 0);							--two output memory vectors
	SIGNAL rightMemo : SIGNED(17 DOWNTO 0);
BEGIN
	flag <= '1' WHEN (counter = 18 AND fsync = '0') ELSE '0';
	leftS <= leftMemo;
	rightS <= rightMemo;

	process (sclk, fsync)
	begin
		if (rising_edge(fsync) or falling_edge(fsync)) then
			counter <= "00000";
		end if;
		
		if (falling_edge(sclk)) then
			IF (counter < 18) THEN
				IF (fsync = '1') THEN
					leftMemo <= leftMemo(16 DOWNTO 0) & sdata;		--shifts first 17 bits to the left and places current sdata value in the front
				ELSE
					rightMemo <= rightMemo(16 DOWNTO 0) & sdata;	--shifts first 17 bits to the left and places current sdata value in the front
				END IF;
				
				counter <= counter + 1;
			END IF;
		end if;
	end process;
END shift_memo;
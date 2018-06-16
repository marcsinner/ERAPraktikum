library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity sp_input is
	port (
		flag : OUT STD_LOGIC;										--rising edge on new signal pair output
		leftS, rightS : OUT SIGNED(17 DOWNTO 0)						--18bit signed parallel outputs
	);
end sp_input;

architecture test of sp_input is
	component sp_converter
		PORT (
			fsync, sclk, sdata : IN STD_LOGIC;							--fsync: 0 = Right, 1 = Left; 1 fsync cycle = 64 sclk cycles; sclk at 44.1 kHz
			flag : OUT STD_LOGIC;										--rising edge on new signal pair output
			leftS, rightS : OUT SIGNED(17 DOWNTO 0)						--18bit signed parallel outputs
		);
	end component;
	
	procedure clk_gen(signal clk : out std_logic; constant FREQ : real) is
		constant PERIOD    : time := 1 sec / FREQ;        -- Full period
		constant HIGH_TIME : time := PERIOD / 2;          -- High time
		constant LOW_TIME  : time := PERIOD - HIGH_TIME;  -- Low time; always >= HIGH_TIME
	begin
		-- Check the arguments
		assert (HIGH_TIME /= 0 fs) report "clk_plain: High time is zero; time resolution to large for frequency" severity FAILURE;
		-- Generate a clock cycle
		loop
			clk <= '1';
			wait for HIGH_TIME;
			clk <= '0';
			wait for LOW_TIME;
		end loop;
	end procedure; --https://stackoverflow.com/questions/17904514/vhdl-how-should-i-create-a-clock-in-a-testbench
	
	signal sclk : std_logic;
	signal fsync : std_logic;
	signal sdata : std_logic;
	
begin
	name: sp_converter port map(fsync => fsync, sclk => sclk, sdata => sdata, flag => flag, leftS => leftS, rightS => rightS);

	sdata <= '1';
	clk_gen(fsync, 4.41E4);
	clk_gen(sclk, 2.8224E6);
end test;
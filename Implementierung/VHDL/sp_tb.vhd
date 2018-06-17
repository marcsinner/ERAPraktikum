library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity sp_tb is
end sp_tb;

architecture test of sp_tb is
	component sp_converter
		PORT (
			fsync, sclk, sdata : in std_logic;							--fsync: 0 = Right, 1 = Left; 1 fsync cycle = 64 sclk cycles; sclk at 44.1 kHz
			flag : out std_logic;										--rising edge on new signal pair output
			leftS, rightS : out signed(17 DOWNTO 0)					--18bit signed parallel outputs
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
	
	signal fsync : std_logic;
	signal sclk : std_logic;
	signal sdata : std_logic;
	signal flag : std_logic;
	signal leftS : signed(17 downto 0);
	signal rightS : signed(17 downto 0);
	signal count : integer := 0;															--counter for sdataArray
	constant sdataArray : unsigned(35 downto 0) := "101010101010101010010101010101010101";  --input for sdat: changing 0 and 1 for better view of succesfull output - left side starting with 1, right side starting with 0
	signal stopcounter : integer := 0;														--counter for stopping program after a time - otherwise the generation of the .vcd would never stop (we let the program calculate 100 cycles)
	
begin
	mapper: sp_converter
	port map(																				--mapping in- and output of sp_converter to this testbench 
		fsync => fsync, 
		sclk => sclk, 
		sdata => sdata, 
		flag => flag, 
		leftS => leftS, 
		rightS => rightS
	);

	sdata <= sdataArray(count);																--Concurrent statements: reading from sdataArray at position count
	clk_gen(fsync, 4.41E4);																	--generating clock for fsync with frequency of 44.1 kHz
	clk_gen(sclk, 2.8224E6);																--generating clock for sclk with frequency of 44.1kHz * 64 = 2822.4 kHz
	
	process(sclk, fsync)
	begin
	
		if(rising_edge(fsync)) then															--reset counter after each cycle fsync cycle
			count <= 0;																		
		end if;
		if(rising_edge(sclk) and count < 17 and fsync /= '0') then							--when fsync is 1, take with every rising_edge of sclk the next of in total 18 (0-17) sdata bits
			count <= count + 1;															
			stopcounter <= stopcounter + 1;
		elsif(rising_edge(sclk) and count < 35 and fsync /= '1') then						--when fsync is 0, take with every rising_edge of sclk the next of in total 18 (18-35) sdata bits
			count <= count + 1;
			stopcounter <= stopcounter + 1;
		end if;
		if(stopcounter >= 35000) then														--100 cycles * 35 counts per cycle = 35000
			assert false
				report "simulation ended - error report is just an exit out of simulation"
				severity failure;
		end if;
		
	
	end process;
end test;
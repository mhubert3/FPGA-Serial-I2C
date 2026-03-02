-- Note: To execute a full end-to-end simulation, a UART transmit 
-- waveform must be driven onto 'rx' to trigger the lab08_gui component,
-- and a dummy I2C slave process must be written to pull SDA low ('0') 
-- during the ACK clock cycles. 
		
-- This framework verifies synthesizability, sets up the physical 
-- bus characteristics, and establishes the timing environment.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity lab08_tb is
end lab08_tb;

architecture sim of lab08_tb is
	-- Component declaration for the Unit/Device Under Test (UUT)
	component lab08 is
		port(
			clk: in    std_logic;
			rx:  in    std_logic;
			tx:  out   std_logic;
			srx: out   std_logic;
			stx: in    std_logic;
			nss: out   std_logic;
			sck: out   std_logic;
			sdi: out   std_logic;
			sdo: in    std_logic;
			scl: inout std_logic;
			sda: inout std_logic
		);
	end component;

	-- Simulation Signals
	signal clk : std_logic := '0';
	signal rx  : std_logic := '1'; -- UART idle high
	signal tx  : std_logic;
	signal srx : std_logic;
	signal stx : std_logic := '1';
	signal nss : std_logic;
	signal sck : std_logic;
	signal sdi : std_logic;
	signal sdo : std_logic := '0';
	signal scl : std_logic;
	signal sda : std_logic;

	-- Clock period for 12 MHz (from Digilent Cmod A7-35T)
	constant CLK_PERIOD : time := 83.33 ns; 

begin
	-- Instantiate UUT
	uut: lab08 port map (
		clk => clk, rx  => rx,  tx  => tx,  srx => srx,
		stx => stx, nss => nss, sck => sck, sdi => sdi, 
		sdo => sdo, scl => scl, sda => sda
	);

	-- 12 MHz Clock Generation
	clk_process : process
	begin
		clk <= '0';
		wait for CLK_PERIOD/2;
		clk <= '1';
		wait for CLK_PERIOD/2;
	end process;

	-- Simulate I2C Pull-up resistors for open-drain bus
	scl <= 'H';
	sda <= 'H';

	-- Stimulus Process
	stim_proc: process
	begin
		-- Wait for global reset and initial stabilization
		wait for 2 us;
		
		wait;
	end process;
end sim;
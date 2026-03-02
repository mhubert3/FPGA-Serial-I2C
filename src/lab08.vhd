library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library UNISIM;
use UNISIM.vcomponents.all;

entity lab08 is
	port(
		clk: in    std_logic;
		rx:  in    std_logic;
		tx:  out   std_logic;
		srx: out   std_logic;-- PIC pin 9 RS-232
		stx: in    std_logic;-- PIC pin 10 RS-232
		nss: out   std_logic;-- PIC pin 11 SPI
		sck: out   std_logic;-- PIC pin 12 SPI
		sdi: out   std_logic;-- PIC pin 4 SPI
		sdo: in    std_logic;-- PIC pin 3 SPI
		scl: inout std_logic;-- PIC pin 6 I2C
		sda: inout std_logic -- PIC pin 5 I2C
	);
end lab08;

architecture arch of lab08 is
	component lab08_gui
		port(
			clk_i:  in  std_logic;
			rx_i:   in  std_logic;
			tx_o:   out std_logic;
			data_o: out std_logic_vector(7 downto 0);
			data_i: in  std_logic_vector(7 downto 0);
			trig_o: out std_logic
		);
	end component;
	signal data_o:      std_logic_vector(7 downto 0);
	signal data_i:      std_logic_vector(7 downto 0);
	signal trig:        std_logic;
	signal scl_in:      std_logic;
	signal scl_out:     std_logic;
	signal sda_in:      std_logic;
	signal sda_out:     std_logic;
begin
	gui: lab08_gui port map(clk_i=>clk,rx_i=>rx,tx_o=>tx,
		data_o=>data_o,data_i=>data_i,trig_o=>trig);

	scl_pin: IOBUF port map(O=>scl_in,IO=>scl,I=>'0',T=>scl_out);
	sda_pin: IOBUF port map(O=>sda_in,IO=>sda,I=>'0',T=>sda_out);

	-- Example default state of FPGA outputs
	srx<='1';
	nss<='1';
	sck<='0';
	sdi<='0';
	--scl<='1';
	--sda<='1';
end arch;
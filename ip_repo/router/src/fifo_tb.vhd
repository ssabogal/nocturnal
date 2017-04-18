library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fifo_tb is
end entity;

architecture testbench of fifo_tb is

	component fifo32x1K is
		port ( 
			s_aclk : in STD_LOGIC;
			s_aresetn : in STD_LOGIC;
			s_axis_tvalid : in STD_LOGIC;
			s_axis_tready : out STD_LOGIC;
			s_axis_tdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
			m_axis_tvalid : out STD_LOGIC;
			m_axis_tready : in STD_LOGIC;
			m_axis_tdata : out STD_LOGIC_VECTOR ( 31 downto 0 )
		);
	end component;

	signal CLOCK : std_logic := '0';
	signal RESET : std_logic := '0';

	signal DIN   : std_logic_vector(31 downto 0) := (others => 'X');
	signal VIN   : std_logic := '0';
	signal RIN   : std_logic;

	signal DOUT  : std_logic_vector(31 downto 0);
	signal VOUT  : std_logic;
	signal ROUT  : std_logic := '0';

	signal reset_n : std_logic;

begin

	UUT: fifo32x1K
		port map (
			s_aclk        => CLOCK,
			s_aresetn     => reset_n,

			s_axis_tdata  => DIN,
			s_axis_tvalid => VIN,
			s_axis_tready => RIN,

			m_axis_tdata  => DOUT,
			m_axis_tvalid => VOUT,
			m_axis_tready => ROUT
		);

	CLOCK <= not CLOCK after 5 ns;

	reset_n <= not RESET;

	process
	begin
		RESET <= '1';
		wait until rising_edge(CLOCK);
		RESET <= '0';

        wait until RIN = '1';
		wait until rising_edge(CLOCK);

		for i in 1 to 8 loop
			DIN <= std_logic_vector(to_unsigned(i, 32));
			VIN <= '1';
			wait until rising_edge(CLOCK);
		end loop;

		DIN <= (others => 'X');
		VIN <= '0';

		wait for 50 ns;

		for i in 1 to 8 loop
			ROUT <= '1';
			wait until rising_edge(CLOCK);
		end loop;

		ROUT <= '0';
		
		wait for 500 ns;

		wait;
	end process;

end architecture;

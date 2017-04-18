library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fifo_in_tb is
end entity;

architecture structure of fifo_in_tb is

	component fifo_in is
		port (
			CLOCK : in  std_logic;
			RESET : in  std_logic;

			DIN   : in  std_logic_vector(31 downto 0);
			VIN   : in  std_logic;
			RIN   : out std_logic;

			DOUT  : out std_logic_vector(31 downto 0);
			VOUT  : out std_logic;
			ROUT  : in  std_logic;

			AX    : out std_logic_vector(1 downto 0);
			AY    : out std_logic_vector(1 downto 0);
			SZ    : out std_logic_vector(15 downto 0);
			HVAL  : out std_logic
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

	signal AX    : std_logic_vector(1 downto 0);
	signal AY    : std_logic_vector(1 downto 0);
	signal SZ    : std_logic_vector(15 downto 0);
	signal HVAL  : std_logic;

	constant PKT_SIZE : positive := 8;

begin

	UUT: fifo_in
		port map (
			CLOCK => CLOCK,
			RESET => RESET,

			DIN   => DIN,
			VIN   => VIN,
			RIN   => RIN,

			DOUT  => DOUT,
			VOUT  => VOUT,
			ROUT  => ROUT,

			AX    => AX,
			AY    => AY,
			SZ    => SZ,
			HVAL  => HVAL
		);

	CLOCK <= not CLOCK after 5 ns;

	process
	begin
		RESET <= '1';
		wait until rising_edge(CLOCK);
        RESET <= '0';

		DIN <= X"50000000";
		VIN <= '1';
        wait until rising_edge(CLOCK);

		DIN <= X"10000000";
		VIN <= '1';
        wait until rising_edge(CLOCK);

		DIN <= std_logic_vector(to_unsigned(PKT_SIZE, 32));
		VIN <= '1';
        wait until rising_edge(CLOCK);

		for i in 1 to PKT_SIZE - 3 loop
			DIN <= std_logic_vector(to_unsigned(i, 32));
			VIN <= '1';
            wait until rising_edge(CLOCK);
		end loop;

        DIN <= (others => 'X');
        VIN <= '0';

		wait for 50 ns;

        for i in 1 to 16 loop
            ROUT <= '1';
            wait until rising_edge(CLOCK);
        end loop;

        ROUT <= '0';

		wait for 100 ns;
		
		DIN <= X"A0000000";
        VIN <= '1';
        wait until rising_edge(CLOCK);

        DIN <= X"F0000000";
        VIN <= '1';
        wait until rising_edge(CLOCK);

        DIN <= std_logic_vector(to_unsigned(PKT_SIZE, 32));
        VIN <= '1';
        wait until rising_edge(CLOCK);

        for i in 1 to PKT_SIZE - 3 loop
            DIN <= std_logic_vector(to_unsigned(i*2, 32));
            VIN <= '1';
            wait until rising_edge(CLOCK);
        end loop;

        DIN <= (others => 'X');
        VIN <= '0';

        wait for 50 ns;

        for i in 1 to 16 loop
            ROUT <= '1';
            wait until rising_edge(CLOCK);
        end loop;

        ROUT <= '0';
		
		wait;
	end process;

end architecture;

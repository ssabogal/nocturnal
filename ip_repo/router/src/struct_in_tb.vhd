library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity struct_in_tb is
end entity;

architecture structure of struct_in_tb is

	component router_struct is
		generic (
			ADDR_X : natural range 0 to 3 := 0;
			ADDR_Y : natural range 0 to 3 := 0;
			N_INST : boolean := true;
			S_INST : boolean := true;
			E_INST : boolean := true;
			W_INST : boolean := true
		);
		port (
			CLOCK : in  std_logic;
			RESET : in  std_logic;

			-- local
			L_DIN   : in  std_logic_vector(31 downto 0);
			L_VIN   : in  std_logic;
			L_RIN   : out std_logic;

			L_DOUT  : out std_logic_vector(31 downto 0);
			L_VOUT  : out std_logic;
			L_ROUT  : in  std_logic;

			L_SZ    : out std_logic_vector(15 downto 0);
			L_DIR   : out std_logic_vector(4 downto 0); --LNSEW

			-- north
			N_DIN   : in  std_logic_vector(31 downto 0);
			N_VIN   : in  std_logic;
			N_RIN   : out std_logic;

			N_DOUT  : out std_logic_vector(31 downto 0);
			N_VOUT  : out std_logic;
			N_ROUT  : in  std_logic;

			N_SZ    : out std_logic_vector(15 downto 0);
			N_DIR   : out std_logic_vector(4 downto 0);

			-- south
			S_DIN   : in  std_logic_vector(31 downto 0);
			S_VIN   : in  std_logic;
			S_RIN   : out std_logic;

			S_DOUT  : out std_logic_vector(31 downto 0);
			S_VOUT  : out std_logic;
			S_ROUT  : in  std_logic;

			S_SZ    : out std_logic_vector(15 downto 0);
			S_DIR   : out std_logic_vector(4 downto 0);

			-- east
			E_DIN   : in  std_logic_vector(31 downto 0);
			E_VIN   : in  std_logic;
			E_RIN   : out std_logic;

			E_DOUT  : out std_logic_vector(31 downto 0);
			E_VOUT  : out std_logic;
			E_ROUT  : in  std_logic;

			E_SZ    : out std_logic_vector(15 downto 0);
			E_DIR   : out std_logic_vector(4 downto 0);

			-- west
			W_DIN   : in  std_logic_vector(31 downto 0);
			W_VIN   : in  std_logic;
			W_RIN   : out std_logic;

			W_DOUT  : out std_logic_vector(31 downto 0);
			W_VOUT  : out std_logic;
			W_ROUT  : in  std_logic;

			W_SZ    : out std_logic_vector(15 downto 0);
			W_DIR   : out std_logic_vector(4 downto 0)
		);
	end component;

	constant ADDR_X : natural range 0 to 3 := 1;
	constant ADDR_Y : natural range 0 to 3 := 1;
	constant N_INST : boolean := true;
	constant S_INST : boolean := true;
	constant E_INST : boolean := true;
	constant W_INST : boolean := true;

	signal CLOCK : std_logic := '0';
	signal RESET : std_logic := '0';

	-- local
	signal L_DIN   : std_logic_vector(31 downto 0) := (others => 'X');
	signal L_VIN   : std_logic := '0';
	signal L_RIN   : std_logic;

	signal L_DOUT  : std_logic_vector(31 downto 0);
	signal L_VOUT  : std_logic;
	signal L_ROUT  : std_logic := '0';

	signal L_SZ    : std_logic_vector(15 downto 0);
	signal L_DIR   : std_logic_vector(4 downto 0); --LNSEW

	-- north
	signal N_DIN   : std_logic_vector(31 downto 0) := (others => 'X');
	signal N_VIN   : std_logic := '0';
	signal N_RIN   : std_logic;

	signal N_DOUT  : std_logic_vector(31 downto 0);
	signal N_VOUT  : std_logic;
	signal N_ROUT  : std_logic := '0';

	signal N_SZ    : std_logic_vector(15 downto 0);
	signal N_DIR   : std_logic_vector(4 downto 0);

	-- south
	signal S_DIN   : std_logic_vector(31 downto 0) := (others => 'X');
	signal S_VIN   : std_logic := '0';
	signal S_RIN   : std_logic;

	signal S_DOUT  : std_logic_vector(31 downto 0);
	signal S_VOUT  : std_logic;
	signal S_ROUT  : std_logic := '0';

	signal S_SZ    : std_logic_vector(15 downto 0);
	signal S_DIR   : std_logic_vector(4 downto 0);

	-- east
	signal E_DIN   : std_logic_vector(31 downto 0) := (others => 'X');
	signal E_VIN   : std_logic := '0';
	signal E_RIN   : std_logic;

	signal E_DOUT  : std_logic_vector(31 downto 0);
	signal E_VOUT  : std_logic;
	signal E_ROUT  : std_logic := '0';

	signal E_SZ    : std_logic_vector(15 downto 0);
	signal E_DIR   : std_logic_vector(4 downto 0);

	-- west
	signal W_DIN   : std_logic_vector(31 downto 0) := (others => 'X');
	signal W_VIN   : std_logic := '0';
	signal W_RIN   : std_logic;

	signal W_DOUT  : std_logic_vector(31 downto 0);
	signal W_VOUT  : std_logic;
	signal W_ROUT  : std_logic := '0';

	signal W_SZ    : std_logic_vector(15 downto 0);
	signal W_DIR   : std_logic_vector(4 downto 0);

	constant PKT_SIZE : positive := 8;

begin

	UUT: struct_in
		generic map (
			ADDR_X => ADDR_X,
			ADDR_Y => ADDR_Y,
			N_INST => N_INST,
			S_INST => S_INST,
			E_INST => E_INST,
			W_INST => W_INST
		)
		port map (
			CLOCK => CLOCK,
			RESET => RESET,

			-- local
			L_DIN   => L_DIN,
			L_VIN   => L_VIN,
			L_RIN   => L_RIN,

			L_DOUT  => L_DOUT,
			L_VOUT  => L_VOUT,
			L_ROUT  => L_ROUT,

			L_SZ    => L_SZ,
			L_DIR   => L_DIR,

			-- north
			N_DIN   => N_DIN,
			N_VIN   => N_VIN,
			N_RIN   => N_RIN,

			N_DOUT  => N_DOUT,
			N_VOUT  => N_VOUT,
			N_ROUT  => N_ROUT,

			N_SZ    => N_SZ,
			N_DIR   => N_DIR,

			-- south
			S_DIN   => S_DIN,
			S_VIN   => S_VIN,
			S_RIN   => S_RIN,

			S_DOUT  => S_DOUT,
			S_VOUT  => S_VOUT,
			S_ROUT  => S_ROUT,

			S_SZ    => S_SZ,
			S_DIR   => S_DIR,

			-- east
			E_DIN   => E_DIN,
			E_VIN   => E_VIN,
			E_RIN   => E_RIN,

			E_DOUT  => E_DOUT,
			E_VOUT  => E_VOUT,
			E_ROUT  => E_ROUT,

			E_SZ    => E_SZ,
			E_DIR   => E_DIR,

			-- west
			W_DIN   => W_DIN,
			W_VIN   => W_VIN,
			W_RIN   => W_RIN,

			W_DOUT  => W_DOUT,
			W_VOUT  => W_VOUT,
			W_ROUT  => W_ROUT,

			W_SZ    => W_SZ,
			W_DIR   => W_DIR
		);

	CLOCK <= not CLOCK after 5 ns;
	RESET <= '1', '0' after 20 ns;

	-- local
	L_PROC: process
	begin
		wait for 20 ns;

		L_DIN <= X"00000000"; --west
		L_VIN <= '1';
        wait until rising_edge(CLOCK);

		L_DIN <= X"10000000";
		L_VIN <= '1';
        wait until rising_edge(CLOCK);

		L_DIN <= std_logic_vector(to_unsigned(PKT_SIZE, 32));
		L_VIN <= '1';
        wait until rising_edge(CLOCK);

		for i in 1 to PKT_SIZE - 3 loop
			L_DIN <= std_logic_vector(to_unsigned(i, 32));
			L_VIN <= '1';
            wait until rising_edge(CLOCK);
		end loop;

        L_DIN <= (others => 'X');
        L_VIN <= '0';

		wait for 50 ns;

        for i in 1 to 16 loop
            L_ROUT <= '1';
            wait until rising_edge(CLOCK);
        end loop;

        L_ROUT <= '0';

		wait for 100 ns;
		
		wait;
	end process;

	-- north
	N_PROC: process
	begin
		wait for 20 ns;

		N_DIN <= X"F0000000"; --east
		N_VIN <= '1';
        wait until rising_edge(CLOCK);

		N_DIN <= X"10000000";
		N_VIN <= '1';
        wait until rising_edge(CLOCK);

		N_DIN <= std_logic_vector(to_unsigned(PKT_SIZE, 32));
		N_VIN <= '1';
        wait until rising_edge(CLOCK);

		for i in 1 to PKT_SIZE - 3 loop
			N_DIN <= std_logic_vector(to_unsigned(i, 32));
			N_VIN <= '1';
            wait until rising_edge(CLOCK);
		end loop;

        N_DIN <= (others => 'X');
        N_VIN <= '0';

		wait for 50 ns;

        for i in 1 to 16 loop
            N_ROUT <= '1';
            wait until rising_edge(CLOCK);
        end loop;

        N_ROUT <= '0';

		wait for 100 ns;
		
		wait;
	end process;

	-- south
	S_PROC: process
	begin
		wait for 20 ns;

		S_DIN <= X"70000000"; --north
		S_VIN <= '1';
        wait until rising_edge(CLOCK);

		S_DIN <= X"10000000";
		S_VIN <= '1';
        wait until rising_edge(CLOCK);

		S_DIN <= std_logic_vector(to_unsigned(PKT_SIZE, 32));
		S_VIN <= '1';
        wait until rising_edge(CLOCK);

		for i in 1 to PKT_SIZE - 3 loop
			S_DIN <= std_logic_vector(to_unsigned(i, 32));
			S_VIN <= '1';
            wait until rising_edge(CLOCK);
		end loop;

        S_DIN <= (others => 'X');
        S_VIN <= '0';

		wait for 50 ns;

        for i in 1 to 16 loop
            S_ROUT <= '1';
            wait until rising_edge(CLOCK);
        end loop;

        S_ROUT <= '0';

		wait for 100 ns;
		
		wait;
	end process;

	-- east
	E_PROC: process
	begin
		wait for 20 ns;

		E_DIN <= X"40000000"; --south
		E_VIN <= '1';
        wait until rising_edge(CLOCK);

		E_DIN <= X"10000000";
		E_VIN <= '1';
        wait until rising_edge(CLOCK);

		E_DIN <= std_logic_vector(to_unsigned(PKT_SIZE, 32));
		E_VIN <= '1';
        wait until rising_edge(CLOCK);

		for i in 1 to PKT_SIZE - 3 loop
			E_DIN <= std_logic_vector(to_unsigned(i, 32));
			E_VIN <= '1';
            wait until rising_edge(CLOCK);
		end loop;

        E_DIN <= (others => 'X');
        E_VIN <= '0';

		wait for 50 ns;

        for i in 1 to 16 loop
            E_ROUT <= '1';
            wait until rising_edge(CLOCK);
        end loop;

        E_ROUT <= '0';

		wait for 100 ns;
		
		wait;
	end process;

	-- west
	W_PROC: process
	begin
		wait for 20 ns;

		W_DIN <= X"50000000"; --local
		W_VIN <= '1';
        wait until rising_edge(CLOCK);

		W_DIN <= X"10000000";
		W_VIN <= '1';
        wait until rising_edge(CLOCK);

		W_DIN <= std_logic_vector(to_unsigned(PKT_SIZE, 32));
		W_VIN <= '1';
        wait until rising_edge(CLOCK);

		for i in 1 to PKT_SIZE - 3 loop
			W_DIN <= std_logic_vector(to_unsigned(i, 32));
			W_VIN <= '1';
            wait until rising_edge(CLOCK);
		end loop;

        W_DIN <= (others => 'X');
        W_VIN <= '0';

		wait for 50 ns;

        for i in 1 to 16 loop
            W_ROUT <= '1';
            wait until rising_edge(CLOCK);
        end loop;

        W_ROUT <= '0';

		wait for 100 ns;
		
		wait;
	end process;


end architecture;


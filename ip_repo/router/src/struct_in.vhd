library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity struct_in is
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
end entity;

architecture structure of struct_in is

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

	signal l_hval : std_logic;
	signal n_hval : std_logic;
	signal s_hval : std_logic;
	signal e_hval : std_logic;
	signal w_hval : std_logic;

	signal l_ax   : std_logic_vector(1 downto 0);
	signal n_ax   : std_logic_vector(1 downto 0);
	signal s_ax   : std_logic_vector(1 downto 0);
	signal e_ax   : std_logic_vector(1 downto 0);
	signal w_ax   : std_logic_vector(1 downto 0);

	signal l_ay   : std_logic_vector(1 downto 0);
	signal n_ay   : std_logic_vector(1 downto 0);
	signal s_ay   : std_logic_vector(1 downto 0);
	signal e_ay   : std_logic_vector(1 downto 0);
	signal w_ay   : std_logic_vector(1 downto 0);


begin

	-- local
	L_fifo: fifo_in
		port map (
			CLOCK => CLOCK,
			RESET => RESET,

			DIN   => L_DIN,
			VIN   => L_VIN,
			RIN   => L_RIN,

			DOUT  => L_DOUT,
			VOUT  => L_VOUT,
			ROUT  => L_ROUT,

			AX    => l_ax,
			AY    => l_ay,
			SZ    => L_SZ,
			HVAL  => l_hval
		);

	-- north
	N_fifo_gen: if N_INST = true generate
		N_fifo: fifo_in
			port map (
				CLOCK => CLOCK,
				RESET => RESET,

				DIN   => N_DIN,
				VIN   => N_VIN,
				RIN   => N_RIN,

				DOUT  => N_DOUT,
				VOUT  => N_VOUT,
				ROUT  => N_ROUT,

				AX    => n_ax,
				AY    => n_ay,
				SZ    => N_SZ,
				HVAL  => n_hval
			);
	end generate;
	N_fifo_ngen: if N_INST = false generate
		n_hval <= '0';
	end generate;

	-- south
	S_fifo_gen: if S_INST = true generate
		S_fifo: fifo_in
			port map (
				CLOCK => CLOCK,
				RESET => RESET,

				DIN   => S_DIN,
				VIN   => S_VIN,
				RIN   => S_RIN,

				DOUT  => S_DOUT,
				VOUT  => S_VOUT,
				ROUT  => S_ROUT,

				AX    => s_ax,
				AY    => s_ay,
				SZ    => S_SZ,
				HVAL  => s_hval
			);
	end generate;
	S_fifo_ngen: if S_INST = false generate
		s_hval <= '0';
	end generate;

	-- east
	E_fifo_gen: if E_INST = true generate
		E_fifo: fifo_in
			port map (
				CLOCK => CLOCK,
				RESET => RESET,

				DIN   => E_DIN,
				VIN   => E_VIN,
				RIN   => E_RIN,

				DOUT  => E_DOUT,
				VOUT  => E_VOUT,
				ROUT  => E_ROUT,

				AX    => e_ax,
				AY    => e_ay,
				SZ    => E_SZ,
				HVAL  => e_hval
			);
	end generate;
	E_fifo_ngen: if E_INST = false generate
		e_hval <= '0';
	end generate;

	-- west
	W_fifo_gen: if W_INST = true generate
		W_fifo: fifo_in
			port map (
				CLOCK => CLOCK,
				RESET => RESET,

				DIN   => W_DIN,
				VIN   => W_VIN,
				RIN   => W_RIN,

				DOUT  => W_DOUT,
				VOUT  => W_VOUT,
				ROUT  => W_ROUT,

				AX    => w_ax,
				AY    => w_ay,
				SZ    => W_SZ,
				HVAL  => w_hval
			);
	end generate;
	W_fifo_ngen: if W_INST = false generate
		w_hval <= '0';
	end generate;

	process (
		l_ax, l_ay, l_hval,
		n_ax, n_ay, n_hval,
		s_ax, s_ay, s_hval,
		e_ax, e_ay, e_hval,
		w_ax, w_ay, w_hval
	)
	begin
		L_DIR <= (others => '0');
		N_DIR <= (others => '0');
		S_DIR <= (others => '0');
		E_DIR <= (others => '0');
		W_DIR <= (others => '0');

		-- local
		if l_hval = '1' then
			if unsigned(l_ax) < ADDR_X then
				L_DIR <= "00001"; --send west (left)
			elsif unsigned(l_ax) > ADDR_X then
				L_DIR <= "00010"; --send east (right)
			else
				if unsigned(l_ay) < ADDR_Y then
					L_DIR <= "00100"; --send south (down)
				elsif unsigned(l_ay) > ADDR_Y then
					L_DIR <= "01000"; --send north (up)
				else
					L_DIR <= "10000"; --send local
			    end if;
			end if;
		end if;

		-- north
		if n_hval = '1' then
			if unsigned(n_ax) < ADDR_X then
				N_DIR <= "00001"; --send west (left)
			elsif unsigned(n_ax) > ADDR_X then
				N_DIR <= "00010"; --send east (right)
			else
				if unsigned(n_ay) < ADDR_Y then
					N_DIR <= "00100"; --send south (down)
				elsif unsigned(n_ay) > ADDR_Y then
					N_DIR <= "01000"; --send north (up)
				else
					N_DIR <= "10000"; --send local
                end if;
			end if;
		end if;

		-- south
		if s_hval = '1' then
			if unsigned(s_ax) < ADDR_X then
				S_DIR <= "00001"; --send west (left)
			elsif unsigned(s_ax) > ADDR_X then
				S_DIR <= "00010"; --send east (right)
			else
				if unsigned(s_ay) < ADDR_Y then
					S_DIR <= "00100"; --send south (down)
				elsif unsigned(s_ay) > ADDR_Y then
					S_DIR <= "01000"; --send north (up)
				else
					S_DIR <= "10000"; --send local
                end if;
			end if;
		end if;

		-- east
		if e_hval = '1' then
			if unsigned(e_ax) < ADDR_X then
				E_DIR <= "00001"; --send west (left)
			elsif unsigned(e_ax) > ADDR_X then
				E_DIR <= "00010"; --send east (right)
			else
				if unsigned(e_ay) < ADDR_Y then
					E_DIR <= "00100"; --send south (down)
				elsif unsigned(e_ay) > ADDR_Y then
					E_DIR <= "01000"; --send north (up)
				else
					E_DIR <= "10000"; --send local
                end if;
			end if;
		end if;

		-- west
		if w_hval = '1' then
			if unsigned(w_ax) < ADDR_X then
				W_DIR <= "00001"; --send west (left)
			elsif unsigned(w_ax) > ADDR_X then
				W_DIR <= "00010"; --send east (right)
			else
				if unsigned(w_ay) < ADDR_Y then
					W_DIR <= "00100"; --send south (down)
				elsif unsigned(w_ay) > ADDR_Y then
					W_DIR <= "01000"; --send north (up)
				else
					W_DIR <= "10000"; --send local
                end if;
			end if;
		end if;
	end process;

end architecture;


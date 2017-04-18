library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity struct_out is
	generic (
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

		L_SZ    : in  std_logic_vector(15 downto 0);
		L_DIR   : in  std_logic_vector(4 downto 0);

		L_DOUT  : out std_logic_vector(31 downto 0);
		L_VOUT  : out std_logic;
		L_ROUT  : in  std_logic;

		-- north
		N_DIN   : in  std_logic_vector(31 downto 0);
		N_VIN   : in  std_logic;
		N_RIN   : out std_logic;

		N_SZ    : in  std_logic_vector(15 downto 0);
		N_DIR   : in  std_logic_vector(4 downto 0);

		N_DOUT  : out std_logic_vector(31 downto 0);
		N_VOUT  : out std_logic;
		N_ROUT  : in  std_logic;

		-- south
		S_DIN   : in  std_logic_vector(31 downto 0);
		S_VIN   : in  std_logic;
		S_RIN   : out std_logic;

		S_SZ    : in  std_logic_vector(15 downto 0);
		S_DIR   : in  std_logic_vector(4 downto 0);

		S_DOUT  : out std_logic_vector(31 downto 0);
		S_VOUT  : out std_logic;
		S_ROUT  : in  std_logic;

		-- east
		E_DIN   : in  std_logic_vector(31 downto 0);
		E_VIN   : in  std_logic;
		E_RIN   : out std_logic;

		E_SZ    : in  std_logic_vector(15 downto 0);
		E_DIR   : in  std_logic_vector(4 downto 0);

		E_DOUT  : out std_logic_vector(31 downto 0);
		E_VOUT  : out std_logic;
		E_ROUT  : in  std_logic;

		-- west
		W_DIN   : in  std_logic_vector(31 downto 0);
		W_VIN   : in  std_logic;
		W_RIN   : out std_logic;

		W_SZ    : in  std_logic_vector(15 downto 0);
		W_DIR   : in  std_logic_vector(4 downto 0);

		W_DOUT  : out std_logic_vector(31 downto 0);
		W_VOUT  : out std_logic;
		W_ROUT  : in  std_logic
	);
end entity;

architecture structure of struct_out is

	component fifo_out is
		port (
			CLOCK : in  std_logic;
			RESET : in  std_logic;

			-- local
			L_DIN   : in  std_logic_vector(31 downto 0);
			L_VIN   : in  std_logic;
			L_RIN   : out std_logic;

			L_SZ    : in  std_logic_vector(15 downto 0);
			L_DIR   : in  std_logic;

			-- north
			N_DIN   : in  std_logic_vector(31 downto 0);
			N_VIN   : in  std_logic;
			N_RIN   : out std_logic;

			N_SZ    : in  std_logic_vector(15 downto 0);
			N_DIR   : in  std_logic;

			-- south
			S_DIN   : in  std_logic_vector(31 downto 0);
			S_VIN   : in  std_logic;
			S_RIN   : out std_logic;

			S_SZ    : in  std_logic_vector(15 downto 0);
			S_DIR   : in  std_logic;

			-- east
			E_DIN   : in  std_logic_vector(31 downto 0);
			E_VIN   : in  std_logic;
			E_RIN   : out std_logic;

			E_SZ    : in  std_logic_vector(15 downto 0);
			E_DIR   : in  std_logic;

			-- west
			W_DIN   : in  std_logic_vector(31 downto 0);
			W_VIN   : in  std_logic;
			W_RIN   : out std_logic;

			W_SZ    : in  std_logic_vector(15 downto 0);
			W_DIR   : in  std_logic;

			-- output
			DOUT  : out std_logic_vector(31 downto 0);
			VOUT  : out std_logic;
			ROUT  : in  std_logic
		);
	end component;

	signal l_l_rin : std_logic;
	signal l_n_rin : std_logic;
	signal l_s_rin : std_logic;
	signal l_e_rin : std_logic;
	signal l_w_rin : std_logic;

	signal n_l_rin : std_logic;
	signal n_n_rin : std_logic;
	signal n_s_rin : std_logic;
	signal n_e_rin : std_logic;
	signal n_w_rin : std_logic;

	signal s_l_rin : std_logic;
	signal s_n_rin : std_logic;
	signal s_s_rin : std_logic;
	signal s_e_rin : std_logic;
	signal s_w_rin : std_logic;

	signal e_l_rin : std_logic;
	signal e_n_rin : std_logic;
	signal e_s_rin : std_logic;
	signal e_e_rin : std_logic;
	signal e_w_rin : std_logic;

	signal w_l_rin : std_logic;
	signal w_n_rin : std_logic;
	signal w_s_rin : std_logic;
	signal w_e_rin : std_logic;
	signal w_w_rin : std_logic;

begin

	L_RIN <= l_l_rin or n_l_rin or s_l_rin or e_l_rin or w_l_rin;
	N_RIN <= l_n_rin or n_n_rin or s_n_rin or e_n_rin or w_n_rin;
	S_RIN <= l_s_rin or n_s_rin or s_s_rin or e_s_rin or w_s_rin;
	E_RIN <= l_e_rin or n_e_rin or s_e_rin or e_e_rin or w_e_rin;
	W_RIN <= l_w_rin or n_w_rin or s_w_rin or e_w_rin or w_w_rin;

	-- local
	L_fifo: fifo_out
		port map (
			CLOCK   => CLOCK,
			RESET   => RESET,

			-- local
			L_DIN   => L_DIN,
			L_VIN   => L_VIN,
			L_RIN   => l_l_rin,

			L_SZ    => L_SZ,
			L_DIR   => L_DIR(4),

			-- north
			N_DIN   => N_DIN,
			N_VIN   => N_VIN,
			N_RIN   => l_n_rin,

			N_SZ    => N_SZ,
			N_DIR   => N_DIR(4),

			-- south
			S_DIN   => S_DIN,
			S_VIN   => S_VIN,
			S_RIN   => l_s_rin,

			S_SZ    => S_SZ,
			S_DIR   => S_DIR(4),

			-- east
			E_DIN   => E_DIN,
			E_VIN   => E_VIN,
			E_RIN   => l_e_rin,

			E_SZ    => E_SZ,
			E_DIR   => E_DIR(4),

			-- west
			W_DIN   => W_DIN,
			W_VIN   => W_VIN,
			W_RIN   => l_w_rin,

			W_SZ    => W_SZ,
			W_DIR   => W_DIR(4),

			-- output
			DOUT    => L_DOUT,
			VOUT    => L_VOUT,
			ROUT    => L_ROUT
		);

	-- north
	N_fifo_gen: if N_INST = true generate
		N_fifo: fifo_out
			port map (
				CLOCK   => CLOCK,
				RESET   => RESET,

				-- local
				L_DIN   => L_DIN,
				L_VIN   => L_VIN,
				L_RIN   => n_l_rin,

				L_SZ    => L_SZ,
				L_DIR   => L_DIR(3),

				-- north
				N_DIN   => N_DIN,
				N_VIN   => N_VIN,
				N_RIN   => n_n_rin,

				N_SZ    => N_SZ,
				N_DIR   => N_DIR(3),

				-- south
				S_DIN   => S_DIN,
				S_VIN   => S_VIN,
				S_RIN   => n_s_rin,

				S_SZ    => S_SZ,
				S_DIR   => S_DIR(3),

				-- east
				E_DIN   => E_DIN,
				E_VIN   => E_VIN,
				E_RIN   => n_e_rin,

				E_SZ    => E_SZ,
				E_DIR   => E_DIR(3),

				-- west
				W_DIN   => W_DIN,
				W_VIN   => W_VIN,
				W_RIN   => n_w_rin,

				W_SZ    => W_SZ,
				W_DIR   => W_DIR(3),

				-- output
				DOUT    => N_DOUT,
				VOUT    => N_VOUT,
				ROUT    => N_ROUT
			);
	end generate;
	N_fifo_ngen: if N_INST = false generate
		N_VOUT <= '0';
	end generate;

	-- south
	S_fifo_gen: if S_INST = true generate
		S_fifo: fifo_out
			port map (
				CLOCK   => CLOCK,
				RESET   => RESET,

				-- local
				L_DIN   => L_DIN,
				L_VIN   => L_VIN,
				L_RIN   => s_l_rin,

				L_SZ    => L_SZ,
				L_DIR   => L_DIR(2),

				-- north
				N_DIN   => N_DIN,
				N_VIN   => N_VIN,
				N_RIN   => s_n_rin,

				N_SZ    => N_SZ,
				N_DIR   => N_DIR(2),

				-- south
				S_DIN   => S_DIN,
				S_VIN   => S_VIN,
				S_RIN   => s_s_rin,

				S_SZ    => S_SZ,
				S_DIR   => S_DIR(2),

				-- east
				E_DIN   => E_DIN,
				E_VIN   => E_VIN,
				E_RIN   => s_e_rin,

				E_SZ    => E_SZ,
				E_DIR   => E_DIR(2),

				-- west
				W_DIN   => W_DIN,
				W_VIN   => W_VIN,
				W_RIN   => s_w_rin,

				W_SZ    => W_SZ,
				W_DIR   => W_DIR(2),

				-- output
				DOUT    => S_DOUT,
				VOUT    => S_VOUT,
				ROUT    => S_ROUT
			);
	end generate;
	S_fifo_ngen: if S_INST = false generate
		S_VOUT <= '0';
	end generate;

	-- east
	E_fifo_gen: if E_INST = true generate
		E_fifo: fifo_out
			port map (
				CLOCK   => CLOCK,
				RESET   => RESET,

				-- local
				L_DIN   => L_DIN,
				L_VIN   => L_VIN,
				L_RIN   => e_l_rin,

				L_SZ    => L_SZ,
				L_DIR   => L_DIR(1),

				-- north
				N_DIN   => N_DIN,
				N_VIN   => N_VIN,
				N_RIN   => e_n_rin,

				N_SZ    => N_SZ,
				N_DIR   => N_DIR(1),

				-- south
				S_DIN   => S_DIN,
				S_VIN   => S_VIN,
				S_RIN   => e_s_rin,

				S_SZ    => S_SZ,
				S_DIR   => S_DIR(1),

				-- east
				E_DIN   => E_DIN,
				E_VIN   => E_VIN,
				E_RIN   => e_e_rin,

				E_SZ    => E_SZ,
				E_DIR   => E_DIR(1),

				-- west
				W_DIN   => W_DIN,
				W_VIN   => W_VIN,
				W_RIN   => e_w_rin,

				W_SZ    => W_SZ,
				W_DIR   => W_DIR(1),

				-- output
				DOUT    => E_DOUT,
				VOUT    => E_VOUT,
				ROUT    => E_ROUT
			);
	end generate;
	E_fifo_ngen: if E_INST = false generate
		E_VOUT <= '0';
	end generate;

	-- west
	W_fifo_gen: if W_INST = true generate
		W_fifo: fifo_out
			port map (
				CLOCK   => CLOCK,
				RESET   => RESET,

				-- local
				L_DIN   => L_DIN,
				L_VIN   => L_VIN,
				L_RIN   => w_l_rin,

				L_SZ    => L_SZ,
				L_DIR   => L_DIR(0),

				-- north
				N_DIN   => N_DIN,
				N_VIN   => N_VIN,
				N_RIN   => w_n_rin,

				N_SZ    => N_SZ,
				N_DIR   => N_DIR(0),

				-- south
				S_DIN   => S_DIN,
				S_VIN   => S_VIN,
				S_RIN   => w_s_rin,

				S_SZ    => S_SZ,
				S_DIR   => S_DIR(0),

				-- east
				E_DIN   => E_DIN,
				E_VIN   => E_VIN,
				E_RIN   => w_e_rin,

				E_SZ    => E_SZ,
				E_DIR   => E_DIR(0),

				-- west
				W_DIN   => W_DIN,
				W_VIN   => W_VIN,
				W_RIN   => w_w_rin,

				W_SZ    => W_SZ,
				W_DIR   => W_DIR(0),

				-- output
				DOUT    => W_DOUT,
				VOUT    => W_VOUT,
				ROUT    => W_ROUT
			);
	end generate;
	W_fifo_ngen: if W_INST = false generate
		W_VOUT <= '0';
	end generate;

end architecture;

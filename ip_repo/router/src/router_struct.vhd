library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity router_struct is
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

		-- north
		N_DIN   : in  std_logic_vector(31 downto 0);
		N_VIN   : in  std_logic;
		N_RIN   : out std_logic;

		N_DOUT  : out std_logic_vector(31 downto 0);
		N_VOUT  : out std_logic;
		N_ROUT  : in  std_logic;

		-- south
		S_DIN   : in  std_logic_vector(31 downto 0);
		S_VIN   : in  std_logic;
		S_RIN   : out std_logic;

		S_DOUT  : out std_logic_vector(31 downto 0);
		S_VOUT  : out std_logic;
		S_ROUT  : in  std_logic;

		-- east
		E_DIN   : in  std_logic_vector(31 downto 0);
		E_VIN   : in  std_logic;
		E_RIN   : out std_logic;

		E_DOUT  : out std_logic_vector(31 downto 0);
		E_VOUT  : out std_logic;
		E_ROUT  : in  std_logic;

		-- west
		W_DIN   : in  std_logic_vector(31 downto 0);
		W_VIN   : in  std_logic;
		W_RIN   : out std_logic;

		W_DOUT  : out std_logic_vector(31 downto 0);
		W_VOUT  : out std_logic;
		W_ROUT  : in  std_logic
	);
end entity;

architecture structure of router_struct is

	component struct_in is
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

	component struct_out is
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
	end component;

	signal l_inter_data : std_logic_vector(31 downto 0);
	signal l_inter_valid : std_logic;
	signal l_inter_ready : std_logic;

	signal l_sz  : std_logic_vector(15 downto 0);
	signal l_dir : std_logic_vector(4 downto 0);

	signal n_inter_data : std_logic_vector(31 downto 0);
	signal n_inter_valid : std_logic;
	signal n_inter_ready : std_logic;

	signal n_sz  : std_logic_vector(15 downto 0);
	signal n_dir : std_logic_vector(4 downto 0);

	signal s_inter_data : std_logic_vector(31 downto 0);
	signal s_inter_valid : std_logic;
	signal s_inter_ready : std_logic;

	signal s_sz  : std_logic_vector(15 downto 0);
	signal s_dir : std_logic_vector(4 downto 0);

	signal e_inter_data : std_logic_vector(31 downto 0);
	signal e_inter_valid : std_logic;
	signal e_inter_ready : std_logic;

	signal e_sz  : std_logic_vector(15 downto 0);
	signal e_dir : std_logic_vector(4 downto 0);

	signal w_inter_data : std_logic_vector(31 downto 0);
	signal w_inter_valid : std_logic;
	signal w_inter_ready : std_logic;

	signal w_sz  : std_logic_vector(15 downto 0);
	signal w_dir : std_logic_vector(4 downto 0);

begin

	sin: struct_in
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

			L_DOUT  => l_inter_data,
			L_VOUT  => l_inter_valid,
			L_ROUT  => l_inter_ready,

			L_SZ    => l_sz,
			L_DIR   => l_dir,

			-- north
			N_DIN   => N_DIN,
			N_VIN   => N_VIN,
			N_RIN   => N_RIN,

			N_DOUT  => n_inter_data,
			N_VOUT  => n_inter_valid,
			N_ROUT  => n_inter_ready,

			N_SZ    => n_sz,
			N_DIR   => n_dir,

			-- south
			S_DIN   => S_DIN,
			S_VIN   => S_VIN,
			S_RIN   => S_RIN,

			S_DOUT  => s_inter_data,
			S_VOUT  => s_inter_valid,
			S_ROUT  => s_inter_ready,

			S_SZ    => s_sz,
			S_DIR   => s_dir,

			-- east
			E_DIN   => E_DIN,
			E_VIN   => E_VIN,
			E_RIN   => E_RIN,

			E_DOUT  => e_inter_data,
			E_VOUT  => e_inter_valid,
			E_ROUT  => e_inter_ready,

			E_SZ    => e_sz,
			E_DIR   => e_dir,

			-- west
			W_DIN   => W_DIN,
			W_VIN   => W_VIN,
			W_RIN   => W_RIN,

			W_DOUT  => w_inter_data,
			W_VOUT  => w_inter_valid,
			W_ROUT  => w_inter_ready,

			W_SZ    => w_sz,
			W_DIR   => w_dir
		);

	sout: struct_out
		generic map (
			N_INST => N_INST,
			S_INST => S_INST,
			E_INST => E_INST,
			W_INST => W_INST
		)
		port map (
			CLOCK   => CLOCK,
			RESET   => RESET,

			-- local
			L_DIN   => l_inter_data,
			L_VIN   => l_inter_valid,
			L_RIN   => l_inter_ready,

			L_SZ    => l_sz,
			L_DIR   => l_dir,

			L_DOUT  => L_DOUT,
			L_VOUT  => L_VOUT,
			L_ROUT  => L_ROUT,

			-- north
			N_DIN   => n_inter_data,
			N_VIN   => n_inter_valid,
			N_RIN   => n_inter_ready,

			N_SZ    => n_sz,
			N_DIR   => n_dir,

			N_DOUT  => N_DOUT,
			N_VOUT  => N_VOUT,
			N_ROUT  => N_ROUT,

			-- south
			S_DIN   => s_inter_data,
			S_VIN   => s_inter_valid,
			S_RIN   => s_inter_ready,

			S_SZ    => s_sz,
			S_DIR   => s_dir,

			S_DOUT  => S_DOUT,
			S_VOUT  => S_VOUT,
			S_ROUT  => S_ROUT,

			-- east
			E_DIN   => e_inter_data,
			E_VIN   => e_inter_valid,
			E_RIN   => e_inter_ready,

			E_SZ    => e_sz,
			E_DIR   => e_dir,

			E_DOUT  => E_DOUT,
			E_VOUT  => E_VOUT,
			E_ROUT  => E_ROUT,

			-- west
			W_DIN   => w_inter_data,
			W_VIN   => w_inter_valid,
			W_RIN   => w_inter_ready,

			W_SZ    => w_sz,
			W_DIR   => w_dir,

			W_DOUT  => W_DOUT,
			W_VOUT  => W_VOUT,
			W_ROUT  => W_ROUT
		);

end architecture;


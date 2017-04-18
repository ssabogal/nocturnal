library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fifo_out is
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
end entity;

architecture structure of fifo_out is

	component fifo is
		generic (
			FIFO_WIDTH  : positive := 10;
			DATA_WIDTH  : positive := 32
		);
		port (
			-- clock and reset
			CLOCK       : in  std_logic;
			RESET       : in  std_logic;

			-- fifo input interface
			DAT_I       : in  std_logic_vector(DATA_WIDTH-1 downto 0); --din
			VAL_I       : in  std_logic; --push
			RDY_I       : out std_logic; --ready for push
			FULL        : out std_logic; --not ready for push

			-- fifo output interface
			DAT_O       : out std_logic_vector(DATA_WIDTH-1 downto 0); --dout
			VAL_O       : out std_logic; --ready for pop
			RDY_O       : in  std_logic; --pop
			EMPTY       : out std_logic; --not ready for pop

			OCC_SIZE    : out std_logic_vector(FIFO_WIDTH-1 downto 0);
			VAC_SIZE    : out std_logic_vector(FIFO_WIDTH-1 downto 0)
		);
	end component;

	component FIFO_32x1Kr is
	  Port ( 
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

	constant RAW         : boolean := false;

	signal reset_n       : std_logic;

	type state_t             is (RR, TRACK);
	signal state, state_next : state_t;
	signal count, count_next : unsigned(15 downto 0); -- track packet size
	signal index, index_next : natural range 0 to 4; -- index input fifo

	signal fifo_din : std_logic_vector(31 downto 0);
	signal fifo_vin : std_logic;
	signal fifo_rin : std_logic;

begin

	-- fifo
	fifo_raw: if RAW = true generate
		fifo_i: fifo
			generic map (
				FIFO_WIDTH  => 10,
				DATA_WIDTH  => 32
			)
			port map (
				-- clock and reset
				CLOCK       => CLOCK,
				RESET       => RESET,

				-- fifo input interface
				DAT_I       => fifo_din,
				VAL_I       => fifo_vin,
				RDY_I       => fifo_rin,
				FULL        => open,

				-- fifo output interface
				DAT_O       => DOUT,
				VAL_O       => VOUT,
				RDY_O       => ROUT,
				EMPTY       => open,

				OCC_SIZE    => open,
				VAC_SIZE    => open
			);
	end generate;

	fifo_xil: if RAW = false generate
		fifo_i: FIFO_32x1Kr
		  port map ( 
			s_aclk        => CLOCK,
			s_aresetn     => reset_n,
			s_axis_tdata  => fifo_din,
			s_axis_tvalid => fifo_vin,
			s_axis_tready => fifo_rin,
			m_axis_tdata  => DOUT,
			m_axis_tvalid => VOUT,
			m_axis_tready => ROUT
		  );
	end generate;

	reset_n <= not RESET;

	process (CLOCK)
	begin
		if rising_edge(CLOCK) then
			if RESET = '1' then
				state <= RR;
				index <= 0;
			else
				state <= state_next;
				count <= count_next;
				index <= index_next;
			end if;
		end if;
	end process;

	process (
		state, count, index, fifo_rin,
		L_DIR, L_SZ, L_DIN, L_VIN,
		N_DIR, N_SZ, N_DIN, N_VIN,
		S_DIR, S_SZ, S_DIN, S_VIN,
		E_DIR, E_SZ, E_DIN, E_VIN,
		W_DIR, W_SZ, W_DIN, W_VIN
	)
	begin
		state_next <= state;
		count_next <= count;
		index_next <= index;

		fifo_din <= (others => '0');
		fifo_vin <= '0';

		L_RIN <= '0';
		N_RIN <= '0';
		S_RIN <= '0';
		E_RIN <= '0';
		W_RIN <= '0';

		case state is
			when RR =>
				if index = 0 and L_DIR = '1' then
					state_next <= TRACK;
					count_next <= unsigned(L_SZ);
				elsif index = 1 and N_DIR = '1' then
					state_next <= TRACK;
					count_next <= unsigned(N_SZ);
				elsif index = 2 and S_DIR = '1' then
					state_next <= TRACK;
					count_next <= unsigned(S_SZ);
				elsif index = 3 and E_DIR = '1' then
					state_next <= TRACK;
					count_next <= unsigned(E_SZ);
				elsif index = 4 and W_DIR = '1' then
					state_next <= TRACK;
					count_next <= unsigned(W_SZ);
				else
					if index = 4 then
						index_next <= 0;
					else
						index_next <= index + 1;
					end if;
				end if;
			when TRACK =>
				if index = 0 then
					L_RIN <= fifo_rin;
					fifo_din <= L_DIN;
					fifo_vin <= L_VIN;

					if fifo_rin = '1' and L_VIN = '1' then
						count_next <= count - 1;

						if count = 1 then -- last word is transfering
							state_next <= RR;
						end if;
					end if;
				elsif index = 1 then
					N_RIN <= fifo_rin;
					fifo_din <= N_DIN;
					fifo_vin <= N_VIN;

					if fifo_rin = '1' and N_VIN = '1' then
						count_next <= count - 1;

						if count = 1 then -- last word is transfering
							state_next <= RR;
						end if;
					end if;
				elsif index = 2 then
					S_RIN <= fifo_rin;
					fifo_din <= S_DIN;
					fifo_vin <= S_VIN;

					if fifo_rin = '1' and S_VIN = '1' then
						count_next <= count - 1;

						if count = 1 then -- last word is transfering
							state_next <= RR;
						end if;
					end if;
				elsif index = 3 then
					E_RIN <= fifo_rin;
					fifo_din <= E_DIN;
					fifo_vin <= E_VIN;

					if fifo_rin = '1' and E_VIN = '1' then
						count_next <= count - 1;

						if count = 1 then -- last word is transfering
							state_next <= RR;
						end if;
					end if;
				elsif index = 4 then
					W_RIN <= fifo_rin;
					fifo_din <= W_DIN;
					fifo_vin <= W_VIN;

					if fifo_rin = '1' and W_VIN = '1' then
						count_next <= count - 1;

						if count = 1 then -- last word is transfering
							state_next <= RR;
						end if;
					end if;
				end if;
		end case;
	end process;

end architecture;

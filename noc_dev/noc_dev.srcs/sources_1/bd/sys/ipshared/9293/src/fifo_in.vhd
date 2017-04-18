library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fifo_in is
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
end entity;

architecture structure of fifo_in is
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

	signal inter_data    : std_logic_vector(31 downto 0);
	signal inter_valid   : std_logic;
    signal inter_ready   : std_logic;
    
    signal val3          : std_logic;

    signal srs_vout      : std_logic;

	component shift_reg_stub is
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
			VAL3  : out std_logic
		);
	end component;

	type state_t             is (INIT, TRACK);
	signal state, state_next : state_t;

	signal count, count_next : unsigned(15 downto 0);
	signal srs_size          : std_logic_vector(15 downto 0);

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
				DAT_I       => DIN,
				VAL_I       => VIN,
				RDY_I       => RIN,
				FULL        => open,

				-- fifo output interface
				DAT_O       => inter_data,
				VAL_O       => inter_valid,
				RDY_O       => inter_ready,
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
			s_axis_tdata  => DIN,
			s_axis_tvalid => VIN,
			s_axis_tready => RIN,
			m_axis_tdata  => inter_data,
			m_axis_tvalid => inter_valid,
			m_axis_tready => inter_ready
		  );
	end generate;

	reset_n <= not RESET;

	-- srstub
	srstub: shift_reg_stub
		port map (
			CLOCK => CLOCK,
			RESET => RESET,

			DIN   => inter_data,
			VIN   => inter_valid,
			RIN   => inter_ready,

			DOUT  => DOUT,
			VOUT  => srs_vout,
			ROUT  => ROUT,

			AX    => AX,
			AY    => AY,
			SZ    => srs_size,
			VAL3  => val3
		);

	VOUT <= srs_vout;
	SZ <= srs_size;

	process (CLOCK)
	begin
		if rising_edge(CLOCK) then
			if RESET = '1' then
				state <= INIT;
			else
				state <= state_next;
				count <= count_next;
			end if;
		end if;
	end process;

	process (state, count, val3, ROUT, srs_size, srs_vout)
	begin
		state_next <= state;
		count_next <= count;
		HVAL <= '0';

		case state is
			when INIT =>
				if val3 = '1' then
					HVAL <= '1';
					count_next <= unsigned(srs_size) - 1;
					if ROUT = '1' and srs_vout = '1' then
						state_next <= TRACK;
					end if;
				end if;
			when TRACK =>
				if ROUT = '1' and srs_vout = '1' then
					count_next <= count - 1;
					if count = 1 then -- last word is transfering
						state_next <= INIT;
					end if;
				end if;
		end case;
	end process;

end architecture;

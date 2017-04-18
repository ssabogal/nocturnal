library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity fifo is
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
end entity;

architecture structure of fifo is
	constant NR_ENTRIES : positive := 2**FIFO_WIDTH-1;

	type memory_t       is array (NR_ENTRIES downto 0) of std_logic_vector(DATA_WIDTH-1 downto 0);
	signal mem          : memory_t;

	signal wr_addr      : unsigned(FIFO_WIDTH-1 downto 0);
	signal rd_addr      : unsigned(FIFO_WIDTH-1 downto 0);

	signal full_sig     : std_logic;
	signal empty_sig    : std_logic;

	signal size_sig     : std_logic_vector(FIFO_WIDTH-1 downto 0);
begin

	DAT_O <= mem(to_integer(rd_addr));

	empty_sig <= '1' when wr_addr = rd_addr else '0';
	full_sig <= '1' when wr_addr + 1 = rd_addr else '0';

	EMPTY <= empty_sig;
	FULL <= full_sig;

	VAL_O <= not empty_sig;
	RDY_I <= not full_sig;

	OCC_SIZE <= size_sig;
	VAC_SIZE <= std_logic_vector(to_unsigned(NR_ENTRIES, FIFO_WIDTH) - unsigned(size_sig));

	process (wr_addr, rd_addr)
	begin
		if wr_addr >= rd_addr then
			size_sig <= std_logic_vector(wr_addr - rd_addr);
		else
			size_sig <= std_logic_vector((rd_addr - wr_addr) + to_unsigned(NR_ENTRIES, FIFO_WIDTH));
		end if;
	end process;

	process (CLOCK)
	begin
		if rising_edge(CLOCK) then
			if RESET = '1' then
				wr_addr <= (others => '0');
				rd_addr <= (others => '0');
			else
				if VAL_I = '1' and full_sig = '0' then
					mem(to_integer(wr_addr)) <= DAT_I;
					wr_addr <= wr_addr + 1;
				end if;

				if RDY_O = '1' and empty_sig = '0' then
					rd_addr <= rd_addr + 1;
				end if;
			end if;
		end if;
	end process;

end architecture;


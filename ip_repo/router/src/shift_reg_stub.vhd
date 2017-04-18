library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shift_reg_stub is
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
end entity;

architecture structure of shift_reg_stub is
	type shift_reg_t         is array(2 downto 0) of std_logic_vector(31 downto 0);
	signal shift_reg         : shift_reg_t;
	signal shift_reg_next    : shift_reg_t;

	type state_t             is (S000, S001, S011, S111);
	signal state, state_next : state_t;
begin

	DOUT <= shift_reg(2);

	AX <= shift_reg(2)(31 downto 30);
	AY <= shift_reg(2)(29 downto 28);
	SZ <= shift_reg(0)(15 downto  0);

	process (CLOCK)
	begin
		if rising_edge(CLOCK) then
			if RESET = '1' then
				state <= S000;
			else
				state <= state_next;

				shift_reg(2) <= shift_reg_next(2);
				shift_reg(1) <= shift_reg_next(1);
				shift_reg(0) <= shift_reg_next(0);
			end if;
		end if;
	end process;

	process (state, shift_reg, DIN, VIN, ROUT)
	begin
		state_next <= state;
		RIN <= '0';
		VOUT <= '0';
		VAL3 <= '0';
		
		shift_reg_next <= shift_reg;

		case state is
			when S000 =>
				if VIN = '1' then
					RIN <= '1';
					state_next <= S001;
					shift_reg_next(2) <= DIN;
				end if;
			when S001 =>
				VOUT <= '1';
				if VIN = '1' and ROUT = '1' then
					RIN <= '1';
					state_next <= S001;
					shift_reg_next(2) <= DIN;
				elsif VIN = '1' then
					RIN <= '1';
					state_next <= S011;
					shift_reg_next(1) <= DIN;
				elsif ROUT = '1' then
					state_next <= S000;
				end if;
			when S011 =>
				VOUT <= '1';
				if VIN = '1' and ROUT = '1' then
					RIN <= '1';
					state_next <= S011;
					shift_reg_next(2) <= shift_reg(1);
					shift_reg_next(1) <= DIN;
				elsif VIN = '1' then
					RIN <= '1';
					state_next <= S111;
					shift_reg_next(0) <= DIN;
				elsif ROUT = '1' then
					shift_reg_next(2) <= shift_reg(1);
					state_next <= S001;
				end if;
			when S111 =>
				VAL3 <= '1';
				VOUT <= '1';
				if VIN = '1' and ROUT = '1' then
					RIN <= '1';
					state_next <= S111;
					shift_reg_next(2) <= shift_reg(1);
					shift_reg_next(1) <= shift_reg(0);
					shift_reg_next(0) <= DIN;
				elsif ROUT = '1' then
					shift_reg_next(2) <= shift_reg(1);
					shift_reg_next(1) <= shift_reg(0);
					state_next <= S011;
				end if;
		end case;
	end process;

end architecture;

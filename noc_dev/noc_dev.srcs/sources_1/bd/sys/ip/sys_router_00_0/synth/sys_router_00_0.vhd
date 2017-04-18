-- (c) Copyright 1995-2017 Xilinx, Inc. All rights reserved.
-- 
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
-- 
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
-- 
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
-- 
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
-- 
-- DO NOT MODIFY THIS FILE.

-- IP VLNV: user.org:user:router:1.0
-- IP Revision: 7

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY sys_router_00_0 IS
  PORT (
    CLOCK : IN STD_LOGIC;
    RESET : IN STD_LOGIC;
    L_DIN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    L_VIN : IN STD_LOGIC;
    L_RIN : OUT STD_LOGIC;
    L_DOUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    L_VOUT : OUT STD_LOGIC;
    L_ROUT : IN STD_LOGIC;
    N_DIN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    N_VIN : IN STD_LOGIC;
    N_RIN : OUT STD_LOGIC;
    N_DOUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    N_VOUT : OUT STD_LOGIC;
    N_ROUT : IN STD_LOGIC;
    E_DIN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    E_VIN : IN STD_LOGIC;
    E_RIN : OUT STD_LOGIC;
    E_DOUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    E_VOUT : OUT STD_LOGIC;
    E_ROUT : IN STD_LOGIC;
    W_DIN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    W_VIN : IN STD_LOGIC;
    W_RIN : OUT STD_LOGIC;
    W_DOUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    W_VOUT : OUT STD_LOGIC;
    W_ROUT : IN STD_LOGIC
  );
END sys_router_00_0;

ARCHITECTURE sys_router_00_0_arch OF sys_router_00_0 IS
  ATTRIBUTE DowngradeIPIdentifiedWarnings : STRING;
  ATTRIBUTE DowngradeIPIdentifiedWarnings OF sys_router_00_0_arch: ARCHITECTURE IS "yes";
  COMPONENT router_struct IS
    GENERIC (
      ADDR_X : INTEGER;
      ADDR_Y : INTEGER;
      N_INST : BOOLEAN;
      S_INST : BOOLEAN;
      E_INST : BOOLEAN;
      W_INST : BOOLEAN
    );
    PORT (
      CLOCK : IN STD_LOGIC;
      RESET : IN STD_LOGIC;
      L_DIN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      L_VIN : IN STD_LOGIC;
      L_RIN : OUT STD_LOGIC;
      L_DOUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      L_VOUT : OUT STD_LOGIC;
      L_ROUT : IN STD_LOGIC;
      N_DIN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      N_VIN : IN STD_LOGIC;
      N_RIN : OUT STD_LOGIC;
      N_DOUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      N_VOUT : OUT STD_LOGIC;
      N_ROUT : IN STD_LOGIC;
      S_DIN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      S_VIN : IN STD_LOGIC;
      S_RIN : OUT STD_LOGIC;
      S_DOUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      S_VOUT : OUT STD_LOGIC;
      S_ROUT : IN STD_LOGIC;
      E_DIN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      E_VIN : IN STD_LOGIC;
      E_RIN : OUT STD_LOGIC;
      E_DOUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      E_VOUT : OUT STD_LOGIC;
      E_ROUT : IN STD_LOGIC;
      W_DIN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
      W_VIN : IN STD_LOGIC;
      W_RIN : OUT STD_LOGIC;
      W_DOUT : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
      W_VOUT : OUT STD_LOGIC;
      W_ROUT : IN STD_LOGIC
    );
  END COMPONENT router_struct;
  ATTRIBUTE X_CORE_INFO : STRING;
  ATTRIBUTE X_CORE_INFO OF sys_router_00_0_arch: ARCHITECTURE IS "router_struct,Vivado 2016.4";
  ATTRIBUTE CHECK_LICENSE_TYPE : STRING;
  ATTRIBUTE CHECK_LICENSE_TYPE OF sys_router_00_0_arch : ARCHITECTURE IS "sys_router_00_0,router_struct,{}";
  ATTRIBUTE X_INTERFACE_INFO : STRING;
  ATTRIBUTE X_INTERFACE_INFO OF CLOCK: SIGNAL IS "xilinx.com:signal:clock:1.0 CLOCK CLK";
  ATTRIBUTE X_INTERFACE_INFO OF RESET: SIGNAL IS "xilinx.com:signal:reset:1.0 RESET RST";
  ATTRIBUTE X_INTERFACE_INFO OF L_DIN: SIGNAL IS "xilinx.com:interface:axis:1.0 L_IN TDATA";
  ATTRIBUTE X_INTERFACE_INFO OF L_VIN: SIGNAL IS "xilinx.com:interface:axis:1.0 L_IN TVALID";
  ATTRIBUTE X_INTERFACE_INFO OF L_RIN: SIGNAL IS "xilinx.com:interface:axis:1.0 L_IN TREADY";
  ATTRIBUTE X_INTERFACE_INFO OF L_DOUT: SIGNAL IS "xilinx.com:interface:axis:1.0 L_OUT TDATA";
  ATTRIBUTE X_INTERFACE_INFO OF L_VOUT: SIGNAL IS "xilinx.com:interface:axis:1.0 L_OUT TVALID";
  ATTRIBUTE X_INTERFACE_INFO OF L_ROUT: SIGNAL IS "xilinx.com:interface:axis:1.0 L_OUT TREADY";
  ATTRIBUTE X_INTERFACE_INFO OF N_DIN: SIGNAL IS "xilinx.com:interface:axis:1.0 N_IN TDATA";
  ATTRIBUTE X_INTERFACE_INFO OF N_VIN: SIGNAL IS "xilinx.com:interface:axis:1.0 N_IN TVALID";
  ATTRIBUTE X_INTERFACE_INFO OF N_RIN: SIGNAL IS "xilinx.com:interface:axis:1.0 N_IN TREADY";
  ATTRIBUTE X_INTERFACE_INFO OF N_DOUT: SIGNAL IS "xilinx.com:interface:axis:1.0 N_OUT TDATA";
  ATTRIBUTE X_INTERFACE_INFO OF N_VOUT: SIGNAL IS "xilinx.com:interface:axis:1.0 N_OUT TVALID";
  ATTRIBUTE X_INTERFACE_INFO OF N_ROUT: SIGNAL IS "xilinx.com:interface:axis:1.0 N_OUT TREADY";
  ATTRIBUTE X_INTERFACE_INFO OF E_DIN: SIGNAL IS "xilinx.com:interface:axis:1.0 E_IN TDATA";
  ATTRIBUTE X_INTERFACE_INFO OF E_VIN: SIGNAL IS "xilinx.com:interface:axis:1.0 E_IN TVALID";
  ATTRIBUTE X_INTERFACE_INFO OF E_RIN: SIGNAL IS "xilinx.com:interface:axis:1.0 E_IN TREADY";
  ATTRIBUTE X_INTERFACE_INFO OF E_DOUT: SIGNAL IS "xilinx.com:interface:axis:1.0 E_OUT TDATA";
  ATTRIBUTE X_INTERFACE_INFO OF E_VOUT: SIGNAL IS "xilinx.com:interface:axis:1.0 E_OUT TVALID";
  ATTRIBUTE X_INTERFACE_INFO OF E_ROUT: SIGNAL IS "xilinx.com:interface:axis:1.0 E_OUT TREADY";
  ATTRIBUTE X_INTERFACE_INFO OF W_DIN: SIGNAL IS "xilinx.com:interface:axis:1.0 W_IN TDATA";
  ATTRIBUTE X_INTERFACE_INFO OF W_VIN: SIGNAL IS "xilinx.com:interface:axis:1.0 W_IN TVALID";
  ATTRIBUTE X_INTERFACE_INFO OF W_RIN: SIGNAL IS "xilinx.com:interface:axis:1.0 W_IN TREADY";
  ATTRIBUTE X_INTERFACE_INFO OF W_DOUT: SIGNAL IS "xilinx.com:interface:axis:1.0 W_OUT TDATA";
  ATTRIBUTE X_INTERFACE_INFO OF W_VOUT: SIGNAL IS "xilinx.com:interface:axis:1.0 W_OUT TVALID";
  ATTRIBUTE X_INTERFACE_INFO OF W_ROUT: SIGNAL IS "xilinx.com:interface:axis:1.0 W_OUT TREADY";
BEGIN
  U0 : router_struct
    GENERIC MAP (
      ADDR_X => 1,
      ADDR_Y => 0,
      N_INST => true,
      S_INST => false,
      E_INST => true,
      W_INST => true
    )
    PORT MAP (
      CLOCK => CLOCK,
      RESET => RESET,
      L_DIN => L_DIN,
      L_VIN => L_VIN,
      L_RIN => L_RIN,
      L_DOUT => L_DOUT,
      L_VOUT => L_VOUT,
      L_ROUT => L_ROUT,
      N_DIN => N_DIN,
      N_VIN => N_VIN,
      N_RIN => N_RIN,
      N_DOUT => N_DOUT,
      N_VOUT => N_VOUT,
      N_ROUT => N_ROUT,
      S_DIN => STD_LOGIC_VECTOR(TO_UNSIGNED(0, 32)),
      S_VIN => '0',
      S_ROUT => '0',
      E_DIN => E_DIN,
      E_VIN => E_VIN,
      E_RIN => E_RIN,
      E_DOUT => E_DOUT,
      E_VOUT => E_VOUT,
      E_ROUT => E_ROUT,
      W_DIN => W_DIN,
      W_VIN => W_VIN,
      W_RIN => W_RIN,
      W_DOUT => W_DOUT,
      W_VOUT => W_VOUT,
      W_ROUT => W_ROUT
    );
END sys_router_00_0_arch;

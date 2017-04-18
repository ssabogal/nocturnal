# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  ipgui::add_page $IPINST -name "Page 0"

  ipgui::add_param $IPINST -name "ADDR_X"
  ipgui::add_param $IPINST -name "ADDR_Y"
  ipgui::add_param $IPINST -name "N_INST"
  ipgui::add_param $IPINST -name "S_INST"
  ipgui::add_param $IPINST -name "E_INST"
  ipgui::add_param $IPINST -name "W_INST"

}

proc update_PARAM_VALUE.ADDR_X { PARAM_VALUE.ADDR_X } {
	# Procedure called to update ADDR_X when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ADDR_X { PARAM_VALUE.ADDR_X } {
	# Procedure called to validate ADDR_X
	return true
}

proc update_PARAM_VALUE.ADDR_Y { PARAM_VALUE.ADDR_Y } {
	# Procedure called to update ADDR_Y when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ADDR_Y { PARAM_VALUE.ADDR_Y } {
	# Procedure called to validate ADDR_Y
	return true
}

proc update_PARAM_VALUE.E_INST { PARAM_VALUE.E_INST } {
	# Procedure called to update E_INST when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.E_INST { PARAM_VALUE.E_INST } {
	# Procedure called to validate E_INST
	return true
}

proc update_PARAM_VALUE.N_INST { PARAM_VALUE.N_INST } {
	# Procedure called to update N_INST when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.N_INST { PARAM_VALUE.N_INST } {
	# Procedure called to validate N_INST
	return true
}

proc update_PARAM_VALUE.S_INST { PARAM_VALUE.S_INST } {
	# Procedure called to update S_INST when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.S_INST { PARAM_VALUE.S_INST } {
	# Procedure called to validate S_INST
	return true
}

proc update_PARAM_VALUE.W_INST { PARAM_VALUE.W_INST } {
	# Procedure called to update W_INST when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.W_INST { PARAM_VALUE.W_INST } {
	# Procedure called to validate W_INST
	return true
}


proc update_MODELPARAM_VALUE.ADDR_X { MODELPARAM_VALUE.ADDR_X PARAM_VALUE.ADDR_X } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ADDR_X}] ${MODELPARAM_VALUE.ADDR_X}
}

proc update_MODELPARAM_VALUE.ADDR_Y { MODELPARAM_VALUE.ADDR_Y PARAM_VALUE.ADDR_Y } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ADDR_Y}] ${MODELPARAM_VALUE.ADDR_Y}
}

proc update_MODELPARAM_VALUE.N_INST { MODELPARAM_VALUE.N_INST PARAM_VALUE.N_INST } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.N_INST}] ${MODELPARAM_VALUE.N_INST}
}

proc update_MODELPARAM_VALUE.S_INST { MODELPARAM_VALUE.S_INST PARAM_VALUE.S_INST } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.S_INST}] ${MODELPARAM_VALUE.S_INST}
}

proc update_MODELPARAM_VALUE.E_INST { MODELPARAM_VALUE.E_INST PARAM_VALUE.E_INST } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.E_INST}] ${MODELPARAM_VALUE.E_INST}
}

proc update_MODELPARAM_VALUE.W_INST { MODELPARAM_VALUE.W_INST PARAM_VALUE.W_INST } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.W_INST}] ${MODELPARAM_VALUE.W_INST}
}


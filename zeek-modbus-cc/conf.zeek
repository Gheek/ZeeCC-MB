#
# Modbus Covert Channel Detection - Config
#

module ModbusCovertChannels;

export {
	redef enum Notice::Type += { Potential_Covert_Channel };

	# CONFIG
	# define here which Unit Ids are allowed/used in your environment
	global allowed_unit_ids = [1, 2];
}

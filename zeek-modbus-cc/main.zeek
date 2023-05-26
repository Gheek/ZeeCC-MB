##! Modbus Covert Channel Detection Scripts - Contains Zeek scripts for detection of known covert channels.
##!
##! Detection results are logged in notice.log
##!
##! Author:  Kevin Lamshöft
##! Contact: zeek@gheek.de
##!
##! Copyright (c) 2023, Kevin Lamshöft,  All rights reserved.

@load ./conf


    #########################################################################################################################
    #####################################  MODBUS UNIT ID COVERT CHANNEL DETECTION  ##########################################
    #########################################################################################################################


event modbus_message(c: connection, headers: ModbusHeaders, is_orig: bool)
{
	local unit_id = headers$uid;
	if (unit_id !in ModbusCovertChannels::allowed_unit_ids)
		{
			local message = "[CC_UnitID] Potential Covert Channel identified using Unit IDs!";
			local sub_message = fmt("Found Unit ID %s. (not allowed)", unit_id);

			NOTICE([$note=ModbusCovertChannels::Potential_Covert_Channel,
					$msg=message,
	        		$sub=sub_message,
	        		$conn=c,
	        		$n=8]);
		}
}


    #########################################################################################################################
    #####################################  Modbus Unused Bits Covert Channel Detection  #####################################
    #########################################################################################################################


global requested_coils = 0;

event modbus_read_coils_request(c: connection, headers: ModbusHeaders, start_address: count, quantity: count)
	{
		requested_coils = quantity;
	}

event modbus_read_coils_response(c: connection, headers: ModbusHeaders, coils: ModbusCoils)
{
	local unused_bits = (8 - requested_coils) % 8;
	# print fmt("Requested %s coils, therefore the last %s bits are not used and should be 0/FALSE", requested_coils, unused_bits);
	# print fmt("CoilStatus: %s", coils);

	if (unused_bits != 0)  {
		local true_bits = 0;
		for ( index, coil in coils[-unused_bits:] )
			{
				if (coil == T)
					true_bits += 1;
			};
		if (true_bits != 0)
			{
				local message = "[CC_Unused_Bits] Potential Covert Channel identified using unused bits!";
				local sub_message = fmt("Found %s bits that are not zero (but should be).", true_bits);
				NOTICE([$note=ModbusCovertChannels::Potential_Covert_Channel,
						$msg=message,
	        			$sub=sub_message,
	        			$conn=c,
	        			$n=unused_bits]);
			};
	};
}

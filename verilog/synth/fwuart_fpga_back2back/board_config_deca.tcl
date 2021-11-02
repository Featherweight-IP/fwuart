#============================================================
# disable config pin so bank8 can use 1.2V 
#============================================================
set_global_assignment -name AUTO_RESTART_CONFIGURATION ON
set_global_assignment -name ENABLE_CONFIGURATION_PINS OFF
set_global_assignment -name ENABLE_BOOT_SEL_PIN OFF

#============================================================
# CLOCK
#============================================================
set_location_assignment PIN_M8 -to clock
set_instance_assignment -name IO_STANDARD "2.5 V" -to clock

#============================================================
# LED
#============================================================
set_location_assignment PIN_C7 -to led[0]
set_instance_assignment -name IO_STANDARD "1.2 V" -to led[0]
set_location_assignment PIN_C8 -to led[1]
set_instance_assignment -name IO_STANDARD "1.2 V" -to led[1]
set_location_assignment PIN_A6 -to led[2]
set_instance_assignment -name IO_STANDARD "1.2 V" -to led[2]
set_location_assignment PIN_B7 -to led[3]
set_instance_assignment -name IO_STANDARD "1.2 V" -to led[3]
set_location_assignment PIN_C4 -to led[4]
set_instance_assignment -name IO_STANDARD "1.2 V" -to led[4]
set_location_assignment PIN_A5 -to led[5]
set_instance_assignment -name IO_STANDARD "1.2 V" -to led[5]
set_location_assignment PIN_B4 -to led[6]
set_instance_assignment -name IO_STANDARD "1.2 V" -to led[6]
set_location_assignment PIN_C5 -to led[7]
set_instance_assignment -name IO_STANDARD "1.2 V" -to led[7]

#============================================================
# UART
#============================================================
set_location_assignment PIN_AA17 -to tx
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to tx
set_location_assignment PIN_AA19 -to rx
set_instance_assignment -name IO_STANDARD "3.3-V LVTTL" -to rx


set_global_assignment -name USE_CONFIGURATION_DEVICE ON
set_global_assignment -name CRC_ERROR_OPEN_DRAIN OFF
set_global_assignment -name OUTPUT_IO_TIMING_NEAR_END_VMEAS "HALF VCCIO" -rise
set_global_assignment -name OUTPUT_IO_TIMING_NEAR_END_VMEAS "HALF VCCIO" -fall
set_global_assignment -name OUTPUT_IO_TIMING_FAR_END_VMEAS "HALF SIGNAL SWING" -rise
set_global_assignment -name OUTPUT_IO_TIMING_FAR_END_VMEAS "HALF SIGNAL SWING" -fall
set_global_assignment -name STRATIX_DEVICE_IO_STANDARD "2.5 V"
set_global_assignment -name MIN_CORE_JUNCTION_TEMP 0
set_global_assignment -name MAX_CORE_JUNCTION_TEMP 85
set_global_assignment -name POWER_PRESET_COOLING_SOLUTION "23 MM HEAT SINK WITH 200 LFPM AIRFLOW"
set_global_assignment -name POWER_BOARD_THERMAL_MODEL "NONE (CONSERVATIVE)"

create_project rs_synth vivado_synth_proj -part xc7a35tcpg236-1 -force
add_files src/rtl/reservation_station.sv
set_property top reservation_station [current_fileset]
synth_design -top reservation_station -part xc7a35tcpg236-1
report_utilization -file reports/rs_util.rpt
report_timing_summary -file reports/rs_timing.rpt
exit

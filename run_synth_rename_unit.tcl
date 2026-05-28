create_project rename_synth vivado_synth_proj -part xc7a35tcpg236-1 -force
add_files src/rtl/frat.sv
add_files src/rtl/free_list.sv
add_files src/rtl/rename_unit.sv
add_files src/rtl/reservation_station.sv
add_files src/rtl/wakeup_bus.sv
add_files src/rtl/age_matrix_arbiter.sv
set_property top rename_unit [current_fileset]
synth_design -top rename_unit -part xc7a35tcpg236-1 -mode out_of_context
report_utilization -file reports/rename_unit_util.rpt
report_timing_summary -file reports/rename_unit_timing.rpt
exit

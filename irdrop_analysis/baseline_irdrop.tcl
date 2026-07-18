# baseline_irdrop.tcl

read_lef /openlane/designs/picorv32/runs/RUN_2026.06.09_15.32.26/tmp/merged.nom.lef
read_def /openlane/designs/picorv32/runs/RUN_2026.06.09_15.32.26/results/final/def/picorv32.def

read_liberty /home/dakshaa_sreerama/.ciel/ciel/sky130/versions/0fe599b2afb6708d281543108caf8310912f54af/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib

read_sdc /openlane/designs/picorv32/runs/RUN_2026.06.09_15.32.26/results/final/sdc/picorv32.sdc

read_spef /openlane/designs/picorv32/runs/RUN_2026.06.09_15.32.26/results/final/spef/picorv32.spef

set_propagated_clock [all_clocks]

analyze_power_grid -net VPWR -outfile reports/irdrop_baseline_vpwr.rpt
analyze_power_grid -net VGND -outfile reports/irdrop_baseline_vgnd.rpt

exit

ghdl -a sp_converter.vhd
ghdl -a sp_tb.vhd
ghdl -e sp_tb
ghdl -r sp_tb --vcd=tb.vcd
gtkwave tb.vcd
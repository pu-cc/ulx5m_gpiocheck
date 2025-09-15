## tools
YOSYS = yosys
PR = p_r
NEXTPNR = nextpnr-himbaechel
PACK = gmpack
OFL = openFPGALoader

TOP = tc_gpio
NEXTPNRFLAGS = --vopt allow-unconstrained
PACKFLAGS =
OFLFLAGS = --index-chain 0 --freq 1M

net/$(TOP)_synth.json: src/$(TOP).v
	$(YOSYS) -l log/synth.log -p 'read_verilog -sv $^; synth_gatemate -top top -luttree $(YSFLAGS) -vlog net/$(TOP)_synth.v -json net/$(TOP)_synth.json'

$(TOP).txt: net/$(TOP)_synth.json src/top.ccf
	$(NEXTPNR) --device CCGM1A1 --json net/$(TOP)_synth.json --vopt ccf=src/top.ccf $(NEXTPNRFLAGS) --vopt out=$(TOP).txt --router router2

$(TOP).bit: $(TOP).txt
	$(PACK)  $(TOP).txt $(TOP).bit $(PACKFLAGS)

jtag: $(TOP).bit
	$(OFL) $(OFLFLAGS) -b gatemate_evb_jtag $(TOP).bit

jtag-flash: $(TOP).bit
	$(OFL) $(OFLFLAGS) -b gatemate_evb_jtag -f $(TOP).bit

pgm-jtag: $(TOP).bit
	$(OFL) $(OFLFLAGS) --verbose-level 2 -c gatemate_pgm $(TOP).bit

pgm-jtag-flash: $(TOP).bit
	$(OFL) $(OFLFLAGS) -c gatemate_pgm -f --verify $(TOP).bit

clean:
	$(RM) rm log/*.log
	$(RM) net/*_synth.json
	$(RM) net/*_synth.v
	$(RM) work-obj*.cf
	$(RM) *.txt
	$(RM) *.crf
	$(RM) *.refwire
	$(RM) *.refparam
	$(RM) *.refcomp
	$(RM) *.pos
	$(RM) *.pathes
	$(RM) *.path_struc
	$(RM) *.net
	$(RM) *.id
	$(RM) *.prn
	$(RM) *_00.v
	$(RM) *.used
	$(RM) *.sdf
	$(RM) *.place
	$(RM) *.pin
	$(RM) *.cfg*
	$(RM) *.cdf

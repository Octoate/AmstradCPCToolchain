#
# Makefile to build a simple screenloader with the Amstrad CPC Linux toolchain 
# based on a build script from the CPCSDK by PulkoMandy
#
# 2012 Octoate
#

# path to tools
BIN = ../../bin

all: exscreen.dsk

clean:
	@echo "Cleaning..."
	rm -f *.o
	rm -f *.exo
	rm -f *.dsk
	rm -f *.scr
	rm -f *.bin

exscreen.dsk: exscreen.bin 

exscreen.bin: START = 0x4000
exscreen.bin: exscreen.o deexo.o

logo.scr: SCREENMODE = 1
exscreen.o: logo.exo

# Build the DSK-File (main rule)
%.dsk:
	@echo "Putting files in DSK..."
	$(BIN)/iDSK $@ -n					# create new DSK file
	for i in $^;do $(BIN)/iDSK $@ -i $$i;done;		# add all files

# Link the sources ($^ means "all dependencies", so all of them should be .o 
# files - which is good, since anything else should be incbined somewhere)
%.bin:
	@echo "Linking $@"
	$(BIN)/vlink -b amsdos -Ttext $(START) -M -o $@ $^

# Assemble the sources
%.o: %.z80
	@echo "Assembling $<..."
	$(BIN)/vasmz80_oldstyle -Fvobj -o $@ $<

# convert png to cpc screen format
# SCREENMODE can force the screenmode, otherwise it's guessed from the png 
# bitdepth
%.scr: %.png
	$(call BECHO,"Converting $<...")
	$(BIN)/png2crtc $< $@ 7 $(SCREENMODE)

# Crunch a screen
%.exo: %.scr
	$(call BECHO,"Crunching $<...")
	$(BIN)/exoraw -o $@ $<

#
# Amstrad CPC programming toolchain setup
#
# written 2012 by Octoate
#

BIN = ./bin
BUILD = ./tools
DOWNLOADS = ./downloads
PWD = $(shell pwd)

# VASM related variables
VASM_URL = http://sun.hasenbraten.de/vasm/release/vasm.tar.gz

# VLINK related variables
# currently daily is used, add --continue to wget command if using release version
# and don't forget to remove "rm" line to delete already downloaded version
VLINK_URL = http://sun.hasenbraten.de/vlink/daily/vlink.tar.gz

# Exomizer v3.1.1
EXO_BASE = e131c8695cb5
EXO_FILE = $(EXO_BASE).zip
EXO_URL = https://bitbucket.org/magli143/exomizer/get/$(EXO_FILE)

# libsdk v1.4.2
LIBDSK_VER = libdsk-1.5.20
LIBDSK_FILE = $(LIBDSK_VER).tar.gz
LIBDSK_URL = http://www.seasip.info/Unix/LibDsk/$(LIBDSK_FILE)

#iDSK v0.20
iDSK_DOWNLOAD = master.zip
iDSK_FILE = idsk-v0.20.zip
iDSK_URL = https://github.com/cpcsdk/idsk/archive/refs/heads/$(iDSK_DOWNLOAD)

CAPRICE32_FILE = master.zip

#
all: download vasm vlink exomizer idsk gfx2crtc libdsk

# used to completly rebuild the whole toolchain
distclean: clean
	rm -rf $(DOWNLOADS)/*

clean:
	rm -rf $(BIN)/*
	rm -rf $(BUILD)/vasm
	rm -rf $(BUILD)/vlink
	rm -rf $(BUILD)/exomizer
	rm -rf $(BUILD)/idsk-master
	rm -rf $(BUILD)/caprice32-master
	rm -rf $(BUILD)/$(LIBDSK_VER)
	make -C $(BUILD)/gfx2crtc clean

download:
	wget --continue --directory-prefix=$(DOWNLOADS) $(VASM_URL)
	rm -rf $(DOWNLOADS)/vlink.tar.gz
	wget --directory-prefix=$(DOWNLOADS) $(VLINK_URL)
	wget --continue --directory-prefix=$(DOWNLOADS) $(EXO_URL)
	wget --continue --directory-prefix=$(DOWNLOADS) $(LIBDSK_URL)
	#use iDSK repo because the last release doesn't compile in C++ 17
	wget --continue --directory-prefix=$(DOWNLOADS) $(iDSK_URL)
	mv -v $(DOWNLOADS)/$(iDSK_DOWNLOAD) $(DOWNLOADS)/$(iDSK_FILE)

vasm:
	tar xvfz $(DOWNLOADS)/vasm.tar.gz -C $(BUILD)
	make -C $(BUILD)/vasm CPU=z80 SYNTAX=oldstyle
	cp $(BUILD)/vasm/vasmz80_oldstyle $(BIN)

vlink:
	tar xvfz $(DOWNLOADS)/vlink.tar.gz -C $(BUILD)
	if [ ! -d "$(BUILD)/vlink/objects" ]; then mkdir $(BUILD)/vlink/objects; fi	#workaround: missing directory in tar.gz
	make -C $(BUILD)/vlink
	cp $(BUILD)/vlink/vlink $(BIN)

exomizer:
	if [ ! -d "$(BUILD)/exomizer" ]; then mkdir $(BUILD)/exomizer; fi
	unzip -o $(DOWNLOADS)/$(EXO_FILE) -d $(BUILD)/exomizer
	mv $(BUILD)/exomizer/magli143-exomizer-$(EXO_BASE)/* $(BUILD)/exomizer/
	make -C $(BUILD)/exomizer/src
	cp $(BUILD)/exomizer/src/exomizer $(BIN)

caprice:
	#Original Source (abandoned)
	#cvs -z3 -d:pserver:anonymous@caprice32.cvs.sourceforge.net:/cvsroot/caprice32 co -P $(BUILD)/caprice32
	wget --continue --directory-prefix=$(DOWNLOADS) https://github.com/ColinPitrat/caprice32/archive/refs/heads/master.zip
	unzip -o $(DOWNLOADS)/master.zip -d $(BUILD)
	make -C $(BUILD)/caprice32-master -f makefile install prefix=$(PWD)/$(BIN)/caprice32

idsk:
	unzip -o $(DOWNLOADS)/$(iDSK_FILE) -d $(BUILD)
	cd $(BUILD)/idsk-master && cmake CMakeLists.txt && make
	cp $(BUILD)/idsk-master/iDSK $(BIN)

gfx2crtc:
	make -C $(BUILD)/gfx2crtc
	cp $(BUILD)/gfx2crtc/png2crtc $(BIN)
	cp $(BUILD)/gfx2crtc/raw2crtc $(BIN)

libdsk:
	cd $(BUILD) && tar xvz --file=../downloads/$(LIBDSK_FILE)
	cd $(BUILD) && cd $(LIBDSK_VER) && ./configure --prefix=$(PWD)/$(BUILD)/$(LIBDSK_VER)/build && make && make install

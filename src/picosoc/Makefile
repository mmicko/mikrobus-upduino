RISCV_TOOLS_PREFIX = riscv64-unknown-elf-
CXX = $(RISCV_TOOLS_PREFIX)g++
CC = $(RISCV_TOOLS_PREFIX)gcc
AS = $(RISCV_TOOLS_PREFIX)gcc

ARACHNE = arachne-pnr
ICEPACK = icepack
ICETIME = icetime
ICEPROG = iceprog

all: mikrobus_soc.bin firmware.bin

# ---- iCE40 UP5k Breakout Board ----

mikrobus_soc.blif: mikrobus_soc.v spimemio.v simpleuart.v picosoc.v up_spram.v ip_wrapper.v picorv32.v
	yosys -ql mikrobus_soc.log -p 'synth_ice40 -top mikrobus_soc -blif mikrobus_soc.blif' $^

mikrobus_soc.asc: mikrobus_soc.pcf mikrobus_soc.blif
	$(ARACHNE) -d 5k -o mikrobus_soc.asc -p mikrobus_soc.pcf mikrobus_soc.blif

mikrobus_soc.bin: mikrobus_soc.asc
	$(ICEPACK) mikrobus_soc.asc mikrobus_soc.bin

prog: mikrobus_soc.bin firmware.bin
	$(ICEPROG) mikrobus_soc.bin
	$(ICEPROG) -o 1M firmware.bin

prog_fw: firmware.bin
	$(ICEPROG) -o 1M firmware.bin

# ---- Example Firmware ----

firmware.elf: sections.lds start.s firmware.c sections.c
	$(CC) -O3 -nostartfiles -mabi=ilp32 -march=rv32ic -Wl,-Bstatic,-T,sections.lds,--strip-debug -ffreestanding -o firmware.elf start.s sections.c firmware.c -lgcc

firmware.bin: firmware.elf
	$(RISCV_TOOLS_PREFIX)objcopy  -O binary firmware.elf firmware.bin

# ---- Clean ----

clean:
	rm -f firmware.elf firmware.bin 
	rm -f mikrobus_soc.blif mikrobus_soc.log mikrobus_soc.asc mikrobus_soc.rpt mikrobus_soc.bin

.PHONY: spiflash_tb up5kprog up5kprog_fw up5ksim up5ksynsim clean


# Makefile for compiling ARM Cortex-M0 assembly projects.
OUTPUT = obj/
TARGET = $(OUTPUT)main

# Define the linker script location and chip architecture.
SOURCE = src/
LD_SCRIPT = $(SOURCE)STM32F407VGT6.ld
MCU_SPEC = cortex-m4

# Toolchain definitions (ARM bare metal defaults)
CC = /usr/bin/arm-none-eabi-gcc

# Assembly directives.
ASFLAGS += -c
ASFLAGS += -O0
ASFLAGS += -mcpu=$(MCU_SPEC)
ASFLAGS += -mthumb
ASFLAGS += -Wall
ASFLAGS += -ffreestanding
ASFLAGS += -fno-builtin
ASFLAGS += -nostdlib
ASFLAGS += -nostdinc++

# Linker directives.
LSCRIPT = ./$(LD_SCRIPT)
LFLAGS += -mcpu=$(MCU_SPEC)
LFLAGS += -mthumb
LFLAGS += -Wall
LFLAGS += --specs=nosys.specs
LFLAGS += -nostdlib
LFLAGS += -nostdinc++
LFLAGS += -lgcc
LFLAGS += -ffreestanding
LFLAGS += -fno-builtin
LFLAGS += -nostartfiles
LFLAGS += -T$(LSCRIPT)

AS_SRC += $(SOURCE)core.s

OBJS=$(AS_SRC:.s=.o $(SOURCE)main.o)

.PHONY: all
all: $(TARGET).elf

$(TARGET).elf: $(OBJS)
	$(CC) $^ $(LFLAGS) -o $@

%.o: %.s
	$(CC) $(ASFLAGS) $< -o $@

%.o: %.c
	$(CC) $(ASFLAGS) $< -o $@

.PHONY: clean
clean:
	rm -f $(OBJS)
	rm -f $(TARGET).elf

.PHONY: run
run: $(TARGET).elf
	qemu-system-gnuarmeclipse --verbose --verbose -d unimp,guest_errors -board STM32F4-Discovery -mcu STM32F407VGTx --image $(TARGET).elf

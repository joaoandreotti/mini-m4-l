# Makefile for compiling ARM Cortex-M0 assembly projects.
OUTPUT = obj/
TARGET = $(OUTPUT)main

# Define the linker script location and chip architecture.
SOURCE = src/
LD_SCRIPT = $(SOURCE)STM32F407VGT6.ld
MCU_SPEC = cortex-m4

# Toolchain definitions (ARM bare metal defaults)
CC = /usr/bin/arm-none-eabi-gcc
COPY = /usr/bin/arm-none-eabi-objcopy

# Assembly directives.
ASFLAGS += -c
ASFLAGS += -O0
ASFLAGS += -mcpu=$(MCU_SPEC)
ASFLAGS += -mthumb
ASFLAGS += -Wall
ASFLAGS += -ffreestanding
ASFLAGS += -fno-builtin
ASFLAGS += -nostdlib

# Linker directives.
LSCRIPT = ./$(LD_SCRIPT)
#LFLAGS += -mcpu=$(MCU_SPEC)
#LFLAGS += -mthumb
LFLAGS += -Wall
LFLAGS += --specs=nosys.specs
LFLAGS += -nostdlib
LFLAGS += -lgcc
LFLAGS += -ffreestanding
LFLAGS += -fno-builtin
LFLAGS += -nostartfiles
LFLAGS += -T$(LSCRIPT)
#LFLAGS += -Xlinker --oformat=binary
#LFLAGS += -Xlinker --nmagic

AS_SRC += $(SOURCE)core.s

OBJS=$(AS_SRC:.s=.o $(SOURCE)main.o)

.PHONY: all
all: clean run

$(TARGET).elf: $(OBJS)
	$(CC) $^ $(LFLAGS) -o $@

%.o: %.s
	$(CC) $(ASFLAGS) $< -o $@

%.o: %.c
	$(CC) $(ASFLAGS) $< -o $@

$(TARGET).bin: $(TARGET).elf
	$(COPY) -O binary $(TARGET).elf $(TARGET).bin

.PHONY: clean
clean:
	rm -f obj/*
	rm -f $(OBJS)
	rm -f $(TARGET).elf

.PHONY: run
run: $(TARGET).bin
	st-flash write $(TARGET).bin 0x08000000

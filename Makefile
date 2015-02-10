PRJ_NAME   = Template
CC         = avr-gcc
SRC        = src/main.c
ASRC       = 
OBJ        = $(SRC:.c=.o) $(ASRC:.S=.o)
OBJCOPY    = avr-objcopy
OBJDUMP    = avr-objdump
AVRDUDE    = avrdude
PROGRAMMER = usbasp
DEVICE     = atmega328p
OPTIMIZE   = -O2
FREQ       = 8000000
OPTIONS    = -fpack-struct -fshort-enums
CFLAGS     = -Wall -gdwarf-2 $(OPTIMIZE) -mmcu=$(DEVICE) -DF_CPU=$(FREQ)
ASFLAGS    = -Wall -gstabs -mmcu=$(DEVICE) -DF_CPU=$(FREQ)
LDFLAGS    = -Wl,-Map,$(PRJ_NAME).map
OBJFLAGS   = -R .eeprom -O ihex "$(PRJ_NAME).elf" "$(PRJ_NAME).hex"
DUDEFLAGS  = -c $(PROGRAMMER) -p $(DEVICE) -u -U flash:w:"$(PRJ_NAME).hex"
RSTFLAGS   = -c $(PROGRAMMER) -p $(DEVICE)

all: $(PRJ_NAME).elf $(PRJ_NAME).hex

$(PRJ_NAME).elf: $(OBJ)
	$(CC) $(CFLAGS) $(OBJ) -o $@ $(LDFLAGS)

.c.o:
	$(CC) -c $(CFLAGS) $< -o $@

.S.o:
	$(CC) -c $(ASFLAGS) $< -o $@

$(PRJ_NAME).hex: $(PRJ_NAME).elf
	$(OBJCOPY) $(OBJFLAGS)

clean:
	rm -f $(OBJ) *.map *.elf *.hex

burn:
	$(AVRDUDE) $(DUDEFLAGS)

rst:
	$(AVRDUDE) $(RSTFLAGS)

fast: all burn

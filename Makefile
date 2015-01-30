PRJ_NAME   = Template
CC         = avr-gcc
OBJCOPY    = avr-objcopy
OBJDUMP    = avr-objdump
AVRDUDE    = avrdude
PROGRAMMER = usbasp
DEVICE     = atmega328p
OPTIMIZE   = -O2
FREQ       = 8000000
OPTIONS    = -fpack-struct -fshort-enums
CFLAGS     = -Wall -gdwarf-2 $(OPTIMIZE) -mmcu=$(DEVICE) -DF_CPU=$(FREQ)
LDFLAGS    = -Wl,-Map,main.map -mmcu=atmega328p
OBJFLAGS   = -j .text -j .data -O ihex "$(PRJ_NAME).elf" "$(PRJ_NAME).hex"
DUDEFLAGS  = -c $(PROGRAMMER) -p $(DEVICE) -u -U flash:w:"$(PRJ_NAME).hex"
RSTFLAGS   = -c $(PROGRAMMER) -p $(DEVICE)

all:
	$(CC) $(CFLAGS) -o"main.o" -c "src/main.c"
	
#To add a new source file:
#	$(CC) $(CFLAGS) -o"new_source.o" -c "src/new_source.c"

#Link all object files to produce the final ELF:
	$(CC) $(LDFLAGS) -o"$(PRJ_NAME).elf" "main.o"
	$(OBJCOPY) $(OBJFLAGS)

clean:
	rm -f *.o *.map *.elf *.hex

burn:
	$(AVRDUDE) $(DUDEFLAGS)

rst:
	$(AVRDUDE) $(RSTFLAGS)

fast: all burn

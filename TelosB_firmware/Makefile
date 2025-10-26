# Definizione file sorgente
COMPONENT=EnviroSafeAppC

# Directory librerie esterne
CFLAGS += -I$(TOSDIR)/lib/printf
CFLAGS += -I$(TOSDIR)/chips/msp430/usart

# Directory componenti personalizzati esterni
PFLAGS += -I/opt/tinyos-main/apps/EnviroSafe/Components/Modules/ADC12bit
PFLAGS += -I/opt/tinyos-main/apps/EnviroSafe/Components/Modules/uartConfig
PFLAGS += -I/opt/tinyos-main/apps/EnviroSafe/Components/Interfaces
PFLAGS += -I/opt/tinyos-main/apps/EnviroSafe/Components/Modules

# Definizione costanti
CFLAGS += -DSAMPLING_TIME0=1200
CFLAGS += -DSAMPLING_TIME1=30000+50
CFLAGS += -DACK_DIM=2
CFLAGS += -DSOP=60
CFLAGS += -DEOP=62
CFLAGS += -DLOP_ZERO=6
CFLAGS += -DLOP_ONE=10
CFLAGS += -DUART0_DIM=10
CFLAGS += -DUART1_DIM=14
CFLAGS += -DDIM_CIRC_BUFFER=50
CFLAGS += -DDIM_WINDOW=25
CFLAGS += -DBYTE_SIZE=8

include $(MAKERULES)


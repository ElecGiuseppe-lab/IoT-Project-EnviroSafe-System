import serial.tools.list_ports
import time

#Recupero delle porte seriali USB disponibili
ports = serial.tools.list_ports.comports()
ser = serial.Serial()

portList = []

# Visualizzazione delle porte seriali USB disponibili
for onePort in ports:
    portList.append(str(onePort))
    print(str(onePort))

if not portList:
    print("Nessuna porta seriale disponibile.")
    exit()

# Selezione della porta desiderata su cui avviare la comunicazione
val = input("Seleziona porta seriale: COM")

# Check disponibilitá della porta seriale USB selezionata
portVar = None
for x in range(0,len(portList)):
    if portList[x].startswith("COM" + str(val)):
        portVar = "COM" + str(val)
        print(f"Porta selezionata: {portVar}")

if portVar is None:
    print("Errore: Porta non trovata!")
    exit()

# Configurazione comunicazione seriale e ricezione dati
ser.port = portVar
ser.baudrate = 115200

try:
    ser.open()              # Apertura porta seriale USB
    ser.flushInput()        # Pulisce eventuali dati residui nel buffer
except serial.SerialException as errorPort:
    print(f"Errore nell'apertura della porta: {errorPort}")
    exit()

print("\nInizio lettura, in attesa di ricevere dati...   (Digita 'CTRL+C' per interrompere)\n")

try:
    # Lettura dei dati in un ciclo infinito    
    while True:
        if ser.in_waiting:  # Verifica che ci siano dati disponibili nel buffer di ricezione
            packet = ser.readline()     # Legge una riga di dati da seriale USB
            ack = ser.readline()
            print(packet.decode('utf-8'))   # Stampa i dati ricevuti convertiti in stringa
            print(ack.decode('utf-8'))

except KeyboardInterrupt:
    print("\nInterruzione manuale. Chiudo la porta seriale.\n")
    ser.close()             # Chiusura porta seriale USB     

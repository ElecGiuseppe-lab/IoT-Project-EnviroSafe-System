# IoT-Project-EnviroSafe-System

## English Version
This project addresses the development of an intelligent system based on IoT (Internet of Things) technology for remote monitoring and indoor security in residential settings. It measures environmental parameters such as temperature, humidity, the presence of flames, hazardous gases, and/or toxic substances, such as propane (LPG) and carbon monoxide (CO). This system uses a sensor node, the core of a Wireless Sensor Network (WSN), in combination with other components.

The logic behind this system is primarily comprised of the TelosB mote microcontroller (MSP430) combined with the Arduino central processing unit (ATMega328P) and the Bolt device (Tensilica Xtensa LX106), the latter equipped with an ESP8266 Wi-Fi module. The mote was interfaced with analog/digital sensors to periodically measure environmental parameters, including temperature, relative humidity, LPG (propane gas) concentration, CO (carbon monoxide) concentration, and the presence of flames. These parameters are then processed by the mote, packaged into a packet frame, and sent to the Arduino microcontroller via the UART protocol. The Arduino microcontroller, after reconstructing and saving the data in specific variables, transmits it to the Bolt microcontroller's Wi-Fi module (gateway) via the UART protocol (the data transmission time interval is performed every second). Arduino is also responsible for automatically controlling the actuators based on environmental conditions. These include an audible alarm that sounds when the presence of flames is detected, and a ventilation system that activates when LPG and CO concentrations exceed preset thresholds. Once the Wi-Fi module receives the data stream, it is sent to the Bolt Cloud IoT platform for remote monitoring via a dedicated web application accessible via a web browser. One of the disadvantages of the Bolt cloud platform is that it does not allow real-time data viewing, but imposes a minimum refresh rate of 30 seconds.

#### N.B.
Environmental parameters, including air temperature, relative humidity, LPG concentrations, CO concentrations, and the presence of flames, were selected to determine indoor environmental conditions in a residential setting. Sensors such as the Sensirion SHT11 (temperature and humidity), MQ-6 (LPG), MQ-7 (CO), and KY-026 (flame detector) were used to measure these environmental parameters.
The Sensirion SHT11 sensor is already integrated into the TelosB, while the other external sensors are interfaced with the mote via the 16-pin expansion connector, using the ADC channels.
A voltage divider circuit is used to stabilize the voltage, since the external sensors and the mote they interface with operate at different voltage levels.
The system was also equipped with actuators such as an audible alarm, consisting of a passive buzzer and an LED, which activates when flames are detected, and a ventilation system that activates when LPG and CO concentrations exceed preset thresholds. Due to space constraints, the latter was implemented using a simple LED that simulates its on and off state.

### Documentation
Explore the `docs/` folder for sensor datasheets and the developed system report.

### Source Code
- `src/TelosB_firmware/`: nesC source code for TelosB responsible for data acquisition, processing, and transmission via UART to Arduino.

- `src/Arduino_firmware/`: Arduino source code responsible for data reception, reconstruction, and transmission via UART to the Bolt microcontroller's Wi-Fi module. Arduino is also responsible for automatic actuator control based on environmental conditions.

- `src/Bolt_Cloud_IoT/`: Source code for the Bolt cloud platform for creating a dedicated web application accessible via a web browser for remote monitoring.

- `src/Python_Debug_TelosB/`: Source code to be run using Visual Studio Code with integrated Python to verify proper communication between TelosB and Arduino.



## Versione Italiana
In questo progetto viene affrontato lo sviluppo di un sistema intelligente, basato su tecnologia IoT (Internet of Things), per il monitoraggio da remoto e la sicurezza indoor in ambito residenziale, misurando parametri ambientali quali: temperatura, umidità, presenza di fiamme, gas pericolosi e/o sostanze tossiche quali: gas propano (LPG) e monossido di carbonio (CO), attraverso l’utilizzo di un nodo sensore, elemento principale di una Wireless Sensor Network (WSN), in combinazione con altri componenti.

La logica di tale sistema è costituita principalmente dal microcontrollore del mote TelosB (MSP430) in combinazione con l’unità centrale di Arduino (ATMega328P) e del dispositivo Bolt (Tensilica Xtensa LX106), quest’ultimo equipaggiato di un modulo Wi-Fi ESP8266. Il mote è stato interfacciato con sensori analogici/digitali per misurare periodicamente i parametri ambientali, costituiti da: temperatura, umidità relativa, concentrazione di LPG (gas propano), concentrazione di CO (monossido di carbonio) e presenza di fiamme, i quali vengono successivamente elaborati dal mote, confezionati in un frame di pacchetti e inviati al micro-controllore Arduino tramite protocollo UART, il quale, a sua volta, dopo averli ricostruiti e salvati in apposite variabili, li trasmette al modulo Wi-Fi del micro-controllore Bolt (gateway) sempre tramite protocollo UART (l’intervallo di tempo di trasmissione dati viene eseguito ogni secondo). Arduino, inoltre, è responsabile del controllo automatico degli attuatori in funzione delle condizioni ambientali. Tra questi vi sono: un allarme sonoro che entra in funzione qualora venga rilevata la presenza di fiamme, e un sistema di ventilazione che viene attivato qualora le concentrazioni di LPG e CO superano i valori di soglia impostati. Una volta che il modulo Wi-Fi riceve il flusso di dati, questi vengono inviati alla piattaforma Bolt Cloud IoT per il monitoraggio da remoto attraverso un’apposita applicazione web accessibile per mezzo di un browser web. Uno degli svantaggi della piattaforma cloud Bolt è che non consente una visualizzazione dei dati in tempo reale, ma impone un limite minimo di aggiornamento pari a 30s.

#### N.B.
I parametri ambientali, tra cui temperatura dell’aria, umidità relativa dell’aria, concentrazioni di LPG, concentrazioni di CO e presenza di fiamme, sono stati selezionati per determinare le condizioni ambientali indoor in ambito residenziale. Per misurare questi parametri ambientali sono stati utilizzati sensori quali: Sensirion SHT11 (temperatura e umidità), MQ-6 (LPG), MQ-7 (CO), KY-026 (rilevatore di fiamma).
Il sensore Sensirion SHT11 risulta già integrato sul TelosB, mentre gli altri sensori esterni vengono interfacciati con il mote attraverso il connettore di espansione a 16-pin, sfruttando i canali ADC.
Un circuito partitore di tensione viene utilizzato per stabilizzare la tensione, poiché i sensori esterni ed il mote, con cui questi si interfacciano, operano a diversi livelli di tensione.
Il sistema è stato inoltre dotato di attuatori quali: un allarme sonoro, costituito da un buzzer passivo e un led, che entra in funzione qualora venga rilevata la presenza di fiamme, e un sistema di ventilazione che viene attivato qualora le concentrazioni di LPG e CO superano i valori di soglia impostati. Quest’ultimo, per questioni di indisponibilità e spazio, è stato realizzato attraverso l’utilizzo di un semplice led che ne simula l'accensione e lo spegnimento.

### Documentazione
Esplorare la cartella `docs/` per i datasheets dei sensori e il report del sistema sviluppato.

### Codice sorgente
- `src/TelosB_firmware/`: codice sorgente nesC per TelosB responsabile di acquisizione, elaborazione e trasmissione dei dati via UART ad Arduino.
  
- `src/Arduino_firmware/`: codice sorgente per Arduino responsabile di ricezione, ricostruzione e trasmissione dei dati via UART al modulo Wi-Fi del micro-controllore Bolt. Arduino, inoltre, è responsabile del controllo automatico degli attuatori in funzione delle condizioni ambientali.

- `src/Bolt_Cloud_IoT/`: codice sorgente per la piattaforma cloud Bolt per la realizzazione di un’apposita applicazione web accessibile per mezzo di un browser web che consenta il monitoraggio da remoto.

- `src/Python_Debug_TelosB/`: codice sorgente da eseguire mediante Visual Studio Code con linguaggio Python integrato per verificare la corretta comunicazione tra TelosB e Arduino.

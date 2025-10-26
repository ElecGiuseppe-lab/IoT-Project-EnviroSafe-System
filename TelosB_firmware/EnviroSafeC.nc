#include "Timer.h"
#include "printf.h"
#include "math.h"


module EnviroSafeC {

	/*
	* @uses
	* @desc Interfacce utilizzate dall'applicazione.
	*/
	uses {
		interface Boot;					// Per eseguire azioni quando il sistema si avvia
		interface Leds;
		interface Timer<TMilli> as SamplingTimer0;
	 	interface Timer<TMilli> as SamplingTimer1;
    		interface Read<uint16_t> as RawTemp;		// Interfacce per leggere i valori grezzi delle grandezze
								// fisiche d'interesse
    		interface Read<uint16_t> as RawHumidity;
		interface Read<uint16_t> as RawPropane;
		interface Read<uint16_t> as RawCO;
		interface Read<uint16_t> as RawFlame;
	    	interface CircularBuffer as CB_temp;		// Gestione dei buffer circolari per i dati di temperatura e umidita'
	    	interface CircularBuffer as CB_hum;
	  	interface MQ6Interpolation as ppmPropane;	// Per determinare la concetrazione di gas propano (in ppm)
	  	interface MQ7Interpolation as ppmCO;		// Per determinare la concetrazione di CO (in ppm)

		// Gestione della comunicazione UART
		interface Resource;
        	interface UartStream;

	}

}

implementation {
	
	
	/*
	* @var
	* @desc Dichiarazione di variabili globali.
	*/  
	uint16_t sum, avg_temp, avg_hum;
	uint16_t shiftValue;
	bool firstIteration = TRUE;
	bool sendToUart1Data = FALSE;					// Flag per decidere se inviare i dati a buffer1
	float MQ6_Rs, MQ7_Rs, ratioPROPANE, ratioCO;			// Resistenza sensore e rapporto Rs/R0
	uint16_t MQ6_Rs_int;
	uint16_t MQ6_Rs_frac;
	uint16_t MQ7_Rs_int;
	uint16_t MQ7_Rs_frac;
	uint16_t ArduinoData;
	uint16_t currentUartDataSize;
	uint8_t receivedData[ACK_DIM];


	//Variabili per memorizzare le letture convertite
	uint16_t TempCelsius, RelativeHumidity, ppmPROPANE, ppmMonoOxide, flameValue;
	

	// Array di byte contenente i dati formattati da inviare via UART
	uint8_t *UartData;	
	uint8_t Uart0Data[UART0_DIM];	
	uint8_t Uart1Data[UART1_DIM];
					
	// Arrays contenenti i dati di temperatura e umidita' per il calcolo della media mobile
	uint16_t window_temp[DIM_WINDOW], window_hum[DIM_WINDOW];


	/*
	* @void
	* @desc Funzione utilizzata per il calcolo della media dei dati acquisiti al secondo.
	******* Accetta due parametri: un puntatore all'array che conterra' i dati della grandezza fisica d'interesse
	******* e, un puntatore alla variabile dove la media deve essere salvata.
	******* Permette di riutilizzare la stessa funzione per calcolare la media di diversi array, evitando la duplicazione del codice.
	******* Quando si chiama la funzione, si passa 'window_temp' o 'window_hum' come array di input e l'indirizzo di 'avg_temp' o
	******* 'avg_hum' come variabile di output.
	*/   
	void Average(uint16_t* window, uint16_t* avg) {
		uint8_t i;
		sum = 0;
		for (i=0; i<DIM_WINDOW; i++) {
			sum += window[i];
		}
		*avg = sum/DIM_WINDOW;
	}


	/*
	* @event Boot.booted
	* @desc Evento innescato all'avvio del sistema.
	*/
	event void Boot.booted() {

		/*
		* @call interface.command
		* @desc Inizializzazione dei buffer circolari e avvio di timers periodici.
		*/ 
		call CB_temp.init();
		call CB_hum.init();
		call SamplingTimer0.startPeriodic(SAMPLING_TIME0);
		call SamplingTimer1.startPeriodic(SAMPLING_TIME1);
	}


	/*
	* @event SamplingTimer0.fired
	* @desc Evento innescato quando il timer scade.
	******* Controllo led e lettura del valore grezzo di temperatura.
	*/  
	event void SamplingTimer0.fired() {

		call Leds.led0Off();
		call Leds.led2Off();
		call RawTemp.read();
	}


	/*
	* @event RawTemp.readDone
	* @desc Evento innescato al termine della lettura del valore temperatura.
	*/  
	event void RawTemp.readDone(error_t code, uint16_t value) {

		if(code == SUCCESS) {
			TempCelsius = -43.9+0.01*value;
			call CB_temp.putElem(TempCelsius);
			call RawHumidity.read();
		}
	}


	/*
	* @event RawHumidity.readDone
	* @desc Evento innescato al termine della lettura del valore umidita' relativa.
	*/  
	event void RawHumidity.readDone(error_t code, uint16_t value) {

		if(code == SUCCESS) {
			RelativeHumidity = -2.0468+0.0367*value-(1.5955E-6*value*value);
			call CB_hum.putElem(RelativeHumidity);
			call RawPropane.read();
		}
	}


	/*
	* @event RawPropane.readDone
	* @desc Evento innescato al termine della lettura del valore LPG.
	*/  
	event void RawPropane.readDone(error_t code, uint16_t value) {

		if ( code == SUCCESS ) {

      			// Usa l'interfaccia MQ6Interpolation per calcolare il ppm
      			call ppmPropane.Interpolate(value, &MQ6_Rs, &ratioPROPANE, &ppmPROPANE);

			call RawCO.read();
		}
	}


	/*
	* @event RawCO.readDone
	* @desc Evento innescato al termine della lettura del valore CO.
	*/  
	event void RawCO.readDone(error_t code, uint16_t value) {

		if ( code == SUCCESS ) {

      			// Usa l'interfaccia FermionCOInterpolation per calcolare il ppm
      			call ppmCO.Interpolate(value, &MQ7_Rs, &ratioCO, &ppmMonoOxide);

			call RawFlame.read();
		}
	}


	/*
	* @event RawFlame.readDone
	* @desc Evento innescato al termine della lettura del valore Flame.
	*/  
	event void RawFlame.readDone(error_t code, uint16_t value) {

		if ( code == SUCCESS ) {

			flameValue = (float)value/4095*3.3;

			// Richiesta di accesso al bus UART prima di trasmettere
			call Resource.request();

			// Converti il valore float in intero per la stampa
			MQ6_Rs_int = (uint16_t)MQ6_Rs;
			MQ6_Rs_frac = (uint16_t)((MQ6_Rs - MQ6_Rs_int) * 100);
			MQ7_Rs_int = (uint16_t)MQ7_Rs;
			MQ7_Rs_frac = (uint16_t)((MQ7_Rs - MQ7_Rs_int) * 100);

			//printf("%d.%02d\n", MQ6_Rs_int, MQ6_Rs_frac);
			//printf("%d.%02d\n", MQ7_Rs_int, MQ7_Rs_frac);
			//printfflush();		
		}
	}


	/*
	 * @event Resource.granted
	 * @desc Evento innescato quando il bus UART diventa disponibile per la trasmissione
	 ******* I dati vengono immagazzinati in un array di byte per renderli idonei alla trasmissione via UART.
	 */
	event void Resource.granted() {

		if (sendToUart1Data) {

			// Memorizza i dati nell'array di byte quando si calcolano le medie (ogni 30 secondi)

			Uart1Data[0] = SOP;				// Inizio pacchetto dati
			Uart1Data[1] = LOP_ONE;				// Lunghezza paccheto dati (in byte)		
			Uart1Data[2] = ppmPROPANE & 0xFF;		//LSB
			Uart1Data[3] = ppmPROPANE >> 8; 		//MSB	
			Uart1Data[4] = ppmMonoOxide & 0xFF;
			Uart1Data[5] = ppmMonoOxide >> 8;
			Uart1Data[6] = flameValue & 0xFF;
			Uart1Data[7] = flameValue >> 8;
			Uart1Data[12] = EOP;				// Fine pacchetto dati

			UartData = Uart1Data;
			currentUartDataSize = UART1_DIM;

			sendToUart1Data = FALSE;  // Resetta la flag

			printf("data_to_arduino = LPG: %d ppm, CO: %d ppm, Flame: %dV, Temp(avg): %d C, RH(avg): %d%%\n",
				ppmPROPANE, ppmMonoOxide,flameValue, avg_temp, avg_hum);

			// Ricezione acknowledgment trasmesso da Arduino
			ArduinoData = receivedData[1] << 8 | receivedData[0];
			printf("ack = %d\n", ArduinoData);
			printfflush();
		} else {

			// Memorizza i dati nell'array di byte per l'invio ogni secondo

			Uart0Data[0] = SOP;
			Uart0Data[1] = LOP_ZERO;
			Uart0Data[2] = ppmPROPANE & 0xFF;
			Uart0Data[3] = ppmPROPANE >> 8; 
			Uart0Data[4] = ppmMonoOxide & 0xFF;
			Uart0Data[5] = ppmMonoOxide >> 8;
			Uart0Data[6] = flameValue & 0xFF;
			Uart0Data[7] = flameValue >> 8;
			Uart0Data[8] = EOP;
			
			UartData = Uart0Data;
			currentUartDataSize = UART0_DIM;

			printf("data_to_arduino = LPG: %d ppm, CO: %d ppm, Flame: %dV\n", ppmPROPANE, ppmMonoOxide, flameValue);

			// Ricezione acknowledgment trasmesso da Arduino
			ArduinoData = receivedData[1] << 8 | receivedData[0];
			printf("ack = %d\n", ArduinoData);
			printfflush();
		}

		// Transmissione: Invio array di byte via UartStream da telosB ad Arduino
		if(call UartStream.send(UartData, currentUartDataSize) == SUCCESS) {
			call Leds.led0On();
		}

		// Ricezione: Invio ack via UartStream da Arduino a telosB
		if(call UartStream.receive(receivedData, ACK_DIM) == SUCCESS) {
			call Leds.led2On();
		}
	}


	/*
	 * @async_event UartStream.sendDone
	 * @desc Evento asincrono innescato quando l'operazione di trasmissione é completata.
	 */
	async event void UartStream.sendDone(uint8_t* buf, uint16_t len, error_t error) {

		// Rilascia il bus UART dopo aver trasmesso il pacchetto dati
		call Resource.release();
	}


	/*
	 * @async_event UartStream.receivedByte
	 * @desc Evento asincrono innescato quando la trasmssione di un byte é completata.
	 */
	async event void UartStream.receivedByte(uint8_t byte) {

		// Rilascia il bus UART dopo aver trasmesso un byte
		call Resource.release();
	}


	/*
	 * @async_event UartStream.receiveDone
	 * @desc Evento asincrono innescato quando l'operazione di ricezione é completata.
	 */
	async event void UartStream.receiveDone(uint8_t* buf, uint16_t len, error_t error) {

		// Rilascia il bus UART dopo aver ricevuto l'ack
		call Resource.release();
	}


	/*
	* @event SamplingTimer1.fired
	* @desc Evento innescato quando il timer scade per calcolare la media dei valori di temperatura e umidita' relativa
	******* Successivamente, i dati vengono formattati per renderli idonei alla trasmissione via UART.
	*/
	event void SamplingTimer1.fired() {

		if (firstIteration) {
			shiftValue = 0;   		// Nessun shift nella prima iterazione
			firstIteration = FALSE;  	// Cambia lo stato per le iterazioni successive
		} else {
			shiftValue = DIM_WINDOW;  	// Shift completo nelle iterazioni successive
		}

		call CB_temp.getWindow(window_temp, DIM_WINDOW, shiftValue);
		call CB_hum.getWindow(window_hum, DIM_WINDOW, shiftValue);
		Average(window_temp, &avg_temp);
		Average(window_hum, &avg_hum);

		Uart1Data[8] = avg_temp & 0xFF;
		Uart1Data[9] = avg_temp >> 8;
		Uart1Data[10] = avg_hum & 0xFF;
		Uart1Data[11] = avg_hum >> 8;

		sendToUart1Data = TRUE;
	}
}


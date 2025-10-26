
// Librerie per la gestione delle comunicazioni seriali UART
#include <SoftwareSerial.h>
#include <AltSoftSerial.h>
#include <boltiot.h>

#define SOP '<'
#define EOP '>'
#define MAX_LENGTH 18   // Lunghezza massima del payload, può essere aumentata se necessario
#define Tens_Pin A3     // Utilizzato come ack
#define Buzzer_Pin 3    // Pin per il controllo del buzzer sonoro
#define Led_Pin 4       // Pin per il controllo del led associato al buzzer sonoro
#define Fun_Pin 5       // Pin per il controllo del sistema di ventilazione

AltSoftSerial telosbSerial;               // Sfrutta i pin 8-RX, 9-TX per la comunicazione seriale UART
//SoftwareSerial boltSerial(10,11);       // Permette di creare una porta seriale su qualsiasi coppia di pin digitali

unsigned long previousMillis = 0;         // Memorizza l'ultimo tempo in cui è stato cambiato lo stato del buzzer
const long interval = 300;                // Intervallo di tempo per alternare suono acceso/spento (300 ms)

bool buzzerState = false;                 // Mantiene lo stato del buzzer (acceso/spento)

byte Transmit_Data[2];
uint16_t ack;

// Variabili globali per temperatura e umidità inizializzate a zero
uint16_t Temperature = 0;
uint16_t humidity = 0;

void setup() {

  // Interfaccia seriale hardware
  Serial.begin(38400);                             // Comunicazione con monitor seriale (pc)

  // Instanza di interfacce seriali software
  telosbSerial.begin(38400);                       // Comunicazione con telosB
  //boltSerial.begin(9600);
  boltiot.begin(10,11);                           // (10-RX, 11-TX) Comunicazione con il modulo Bolt a 9600 baud

  pinMode(Buzzer_Pin, OUTPUT);                        
  pinMode(Led_Pin, OUTPUT);
  pinMode(Fun_Pin, OUTPUT);
  digitalWrite(Buzzer_Pin, LOW);                      
  digitalWrite(Led_Pin, LOW);                         
  digitalWrite(Fun_Pin, LOW);                       
}

void loop() {
  // Flag per inizio e fine pacchetto
  bool started = false;
  bool ended = false;
  
  uint8_t inData[MAX_LENGTH];
  byte index = 0;
  uint8_t packetLength = 0;     // Variabile per memorizzare la lunghezza del payload

  // Lettura pacchetto dati dal bus UART
  while (telosbSerial.available() > 0) {
    uint8_t inChar = telosbSerial.read();

    if (inChar == SOP) {
      index = 0;
      started = true;
      ended = false;
    } else if (inChar == EOP) {
        ended = true;
        break;
    } else {
        if (started) {
          if (index == 0) {
            packetLength = inChar;
            // Memorizzazione dati nel buffer
          } else if (index < packetLength + 1 && index < MAX_LENGTH) {
              inData[index - 1] = inChar;
          }
          index++;
        }
    }
  }

  if (started && ended && index == packetLength + 1) {

    // Processo i dati ricevuti
    Serial.println("");
    Serial.println("");
    Serial.println("Pacchetto completo ricevuto, elaborazione dei dati...");
    uint16_t Propane = word(byte(inData[1]), byte(inData[0]));  // I primi 2 byte sono relativi all'LPG
    uint16_t CO_ppm = word(byte(inData[3]), byte(inData[2]));
    uint16_t flame = word(byte(inData[5]), byte(inData[4]));
    Serial.print("LPG: ");
    Serial.print(Propane);
    Serial.print(" ppm, CO: ");
    Serial.print(CO_ppm);
    Serial.print(" ppm, Flame: ");
    Serial.print(flame);
    Serial.print("V");

    // Gestione Buzzer sonoro
    if (flame < 3) {
      handleBuzzer();
    } else {
      digitalWrite(Buzzer_Pin, LOW);
      digitalWrite(Led_Pin, LOW);
    }

    // Gestione sistema di ventilazione
    if (Propane >= 1000 || CO_ppm >= 500) {
      digitalWrite(Fun_Pin, HIGH);
    } else {
        digitalWrite(Fun_Pin, LOW);
    }

    if (packetLength > 6) {
      Temperature = word(byte(inData[7]), byte(inData[6]));
      humidity = word(byte(inData[9]), byte(inData[8]));
      Serial.print(", Temp(avg): ");
      Serial.print(Temperature);   
      Serial.print(" C, RH(avg): ");
      Serial.print(humidity);
      Serial.print("%");
    }

    // Invia i dati al modulo Bolt IoT per la visualizzazione in cloud
    boltiot.processPushDataCommand(Propane, CO_ppm, Temperature, humidity, flame);
    
    // Reset per il prossimo pacchetto
    started = false;
    ended = false;
    index = 0;
    packetLength = 0;

    // Trasmissione segnale di acknowledgement a TelosB
    ack = 1;
    successfullyUART();
  } else {
      ack = 0;
      failureUART();
  }

  delay(1200);

}

// Funzione per alternare lo stato del buzzer sonoro e del led
void handleBuzzer() {
  if (millis() - previousMillis >= interval) {
    previousMillis = millis();                            // Aggiorna il tempo dell'ultimo cambiamento
    buzzerState = !buzzerState;                           // Inverti lo stato del buzzer
    digitalWrite(Buzzer_Pin, buzzerState ? HIGH : LOW);   // Modo compatto di scrivere una condizione booleana if-else
    digitalWrite(Led_Pin, buzzerState ? HIGH : LOW);
  }
}

// Invia un messaggio di ACK positivo al trasmettitore
void successfullyUART() {
  Transmit_Data[0] = ack & 0xff;
  Transmit_Data[1] = ack >> 8;
  telosbSerial.write(Transmit_Data,2);
  Serial.println(" ");
  Serial.print("ACK: ");
  Serial.print(ack);
}

// Invia un messaggio di ACK negativo al trasmettitore
void failureUART() {
  Transmit_Data[0] = ack & 0xff;
  Transmit_Data[1] = ack >> 8;
  telosbSerial.write(Transmit_Data,2);
  Serial.println(" ");
  Serial.print("ACK: ");
  Serial.print(ack);
}

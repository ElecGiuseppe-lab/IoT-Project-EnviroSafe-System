#include "MQ7Constants.h"


/*
 * @module MQ7InterpolationC
 * @desc Implementa un algoritmo di interpolazione lineare per il sensore MQ7, con l'obiettivo di determinare
 ******* la concentrazione di CO (in ppm), in funzione del rapporto Rs/R0, a partire dal dato grezzo dell'ADC e dai
 ******* parametri specificidel sensore.
 */
module MQ7InterpolationC {


  /*
  * @provides
  * @desc Interfacce fornite dal modulo.
  */
  provides interface MQ7Interpolation;

}


implementation {


  /*
  * @command MQ7Interpolation.monoOxideInterpolate
  * @desc E' il comando utilizzato per eseguire l'interpolazione.
  */  
  command void MQ7Interpolation.Interpolate(uint16_t ADCdata, float* Rs, float* ratio, uint16_t* ppm) {

    uint16_t i;
    float MQ7_Vout;
    float ppm_float;

    MQ7_Vout = (float)ADCdata/4095 * MQ7_Vcc; 			// Conversione del valore ADC in tensione
    *Rs = MQ7_RL * ((MQ7_Vcc/MQ7_Vout)-1); 			// Calcolo Rs (con RL ~ 10kΩ)
    *ratio = *Rs/MQ7_R0;					// Calcolo rapporto Rs/R0

    // Implementazione dell'interpolazione lineare sulla curva di sensibilita' del sensore per calcolare la concentrazione
    // di CO. Per ogni intervallo di due punti successivi sulla curva, viene verificato se il rapporto 'ratio' calcolato
    // si trova all'interno dell'intervallo. Se sì, viene eseguita l'interpolazione lineare per calcolare 'ppm_float',
    // che è poi convertito in un intero e assegnato a ppm.

    for (i = 0; i < (MQ7_NUM_POINTS-1); i++) {
      if (*ratio >= MQ7SensitivityCurveCO[i+1][1] && *ratio <= MQ7SensitivityCurveCO[i][1]) {
        ppm_float = MQ7SensitivityCurveCO[i][0] + 
                    (MQ7SensitivityCurveCO[i+1][0] - MQ7SensitivityCurveCO[i][0]) * 
                    (*ratio - MQ7SensitivityCurveCO[i][1]) / 
                    (MQ7SensitivityCurveCO[i+1][1] - MQ7SensitivityCurveCO[i][1]);

        *ppm = (uint16_t) ppm_float;	// Restituisce solo la parte intera

      }
    }

    // Se ratio fuori dal range, restituisci il valore limite
    // Se il valore di 'ratio' è superiore al massimo o inferiore al minimo nella curva definita, la funzione restituisce 
    // il valore di ppm associato al massimo o minimo della curva

    if (*ratio > MQ7SensitivityCurveCO[0][1]) {

	ppm_float = MQ7SensitivityCurveCO[0][0];
    	*ppm = (uint16_t) ppm_float;
    }

    if (*ratio < MQ7SensitivityCurveCO[MQ7_NUM_POINTS - 1][1]) {
	ppm_float = MQ7SensitivityCurveCO[MQ7_NUM_POINTS - 1][0];
        *ppm = (uint16_t) ppm_float;
    }

  }

}

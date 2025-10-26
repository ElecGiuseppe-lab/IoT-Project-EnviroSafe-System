#include "MQ6Constants.h"


/*
 * @module MQ6InterpolationC
 * @desc Implementa un algoritmo di interpolazione lineare per il sensore MQ6, con l'obiettivo di determinare la concentrazione
 ******* di LPG (in ppm), in funzione del rapporto Rs/R0, a partire dal dato grezzo dell'ADC e dai parametri specifici
 ******* del sensore.
 */
module MQ6InterpolationC {


  /*
  * @provides
  * @desc Interfacce fornite dal modulo.
  */
  provides interface MQ6Interpolation;

}


implementation {


  /*
  * @command MQ6Interpolation.propaneInterpolate
  * @desc E' il comando utilizzato per eseguire l'interpolazione.
  */  
  command void MQ6Interpolation.Interpolate(uint16_t ADCdata, float* Rs, float* ratio, uint16_t* ppm) {

    uint16_t i;
    float MQ6_Vout;
    float ppm_float;

    MQ6_Vout = (float)ADCdata/4095 * MQ6_Vcc; 			// Conversione del valore ADC in tensione
    *Rs = MQ6_RL * ((MQ6_Vcc/MQ6_Vout)-1); 			// Calcolo Rs (con RL ~ 10kΩ)
    *ratio = *Rs/MQ6_R0;					// Calcolo rapporto Rs/R0

    // Implementazione dell'interpolazione lineare sulla curva di sensibilita' del sensore per calcolare la concentrazione
    // di LPG. Per ogni intervallo di due punti successivi sulla curva, viene verificato se il rapporto 'ratio' calcolato
    // si trova all'interno dell'intervallo. Se sì, viene eseguita l'interpolazione lineare per calcolare 'ppm_float',
    // che è poi convertito in un intero e assegnato a ppm.

    for (i = 0; i < (MQ6_NUM_POINTS-1); i++) {
      if (*ratio >= MQ6sensitivityCurvePROPANE[i+1][1] && *ratio <= MQ6sensitivityCurvePROPANE[i][1]) {
        ppm_float = MQ6sensitivityCurvePROPANE[i][0] + 
                    (MQ6sensitivityCurvePROPANE[i+1][0] - MQ6sensitivityCurvePROPANE[i][0]) * 
                    (*ratio - MQ6sensitivityCurvePROPANE[i][1]) / 
                    (MQ6sensitivityCurvePROPANE[i+1][1] - MQ6sensitivityCurvePROPANE[i][1]);

        *ppm = (uint16_t) ppm_float;	// Restituisce solo la parte intera

      }
    }

    // Se ratio fuori dal range, restituisci il valore limite
    // Se il valore di 'ratio' è superiore al massimo o inferiore al minimo nella curva definita, la funzione restituisce 
    // il valore di ppm associato al massimo o minimo della curva

    if (*ratio > MQ6sensitivityCurvePROPANE[0][1]) {

	ppm_float = MQ6sensitivityCurvePROPANE[0][0];
    	*ppm = (uint16_t) ppm_float;
    }

    if (*ratio < MQ6sensitivityCurvePROPANE[MQ6_NUM_POINTS - 1][1]) {
	ppm_float = MQ6sensitivityCurvePROPANE[MQ6_NUM_POINTS - 1][0];
        *ppm = (uint16_t) ppm_float;
    }

  }

}

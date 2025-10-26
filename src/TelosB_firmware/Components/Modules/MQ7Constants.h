  /**
  * @header
  * @desc Contiene le costanti necessarie per l'algoritmo di interpolazione.
  */

#ifndef MQ7CONSTANTS_H
#define MQ7CONSTANTS_H

#define MQ7_NUM_POINTS 18


   const float MQ7_Vcc = 3.3;
   const float MQ7_RL = 10;		// Resistenza di carico [kΩ]
   const float MQ7_R0 = 99.5;		// Resistenza sensore Rs in aria pulita determinata durante la calibrazione [kΩ]
						// R0 = Rs/(rapporto Rs/R0 a 50 ppm)


  // Punti noti sulla curva di sensibilità (CO) per l'interpolazione
  const float MQ7SensitivityCurveCO[MQ7_NUM_POINTS][2] = {

      {50, 1.4}, 	// 50 ppm -> Rs/R0 ~ 1.4
      {60, 1.2},   
      {70, 1},  
      {80, 0.9},   
      {90, 0.85},  
      {100, 0.8},
      {200, 0.48},   
      {300, 0.35},
      {400, 0.29},  
      {500, 0.24},    
      {600, 0.2},  
      {700, 0.18},
      {800, 0.17},   
      {900, 0.16},
      {1000, 0.15},   
      {2000, 0.09},   
      {3000, 0.07},  
      {4000, 0.05}  
  };

#endif

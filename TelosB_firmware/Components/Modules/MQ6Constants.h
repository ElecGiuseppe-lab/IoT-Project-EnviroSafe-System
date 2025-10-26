  /**
  * @header
  * @desc Contiene le costanti necessarie per l'algoritmo di interpolazione.
  */

#ifndef MQ6CONSTANTS_H
#define MQ6CONSTANTS_H

#define MQ6_NUM_POINTS 18


   const float MQ6_Vcc = 3.3;
   const float MQ6_RL = 10;		// Resistenza di carico [kΩ]
   const float MQ6_R0 = 39;		// Resistenza sensore Rs in aria pulita determinata durante la calibrazione [kΩ]
					// R0 = Rs/(rapporto Rs/R0 a 200 ppm)


  // Punti noti sulla curva di sensibilità (propane/LPG) per l'interpolazione
  const float MQ6sensitivityCurvePROPANE[MQ6_NUM_POINTS][2] = {

      {200, 2},   // 200 ppm -> Rs/R0 ~ 2
      {300, 1.8},
      {400, 1.6},  
      {500, 1.45},    
      {600, 1.4},  
      {700, 1.3},
      {800, 1.2},   
      {900, 1.1},
      {1000, 1},   
      {2000, 0.73},   
      {3000, 0.64},  
      {4000, 0.58},  
      {5000, 0.5}, 
      {6000, 0.48},   
      {7000, 0.45},  
      {8000, 0.42},   
      {9000, 0.4},  
      {10000, 0.39}   
  };

#endif

/*
 * @interface MQ6Interpolation
 * @desc Definizione di un'interfaccia che dichiara un comando per eseguire l'interpolazione lineare sulla curva di sensibilita'
 ******* del sensore e ricavare la concentrazione di LPG, espressa in ppm, in funzione del rapporto Rs/R0.
 */
interface MQ6Interpolation {

	command void Interpolate(uint16_t ADCdata, float* Rs, float* ratio, uint16_t* ppm);

}

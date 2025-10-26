/*
 * @interface MQ7Interpolation
 * @desc Definizione di un'interfaccia che dichiara un comando per eseguire l'interpolazione lineare sulla curva di sensibilita'
 ******* del sensore e ricavare la concentrazione di CO, espressa in ppm, in funzione del rapporto Rs/R0.
 */
interface MQ7Interpolation {

	command void Interpolate(uint16_t ADCdata, float* Rs, float* ratio, uint16_t* ppm);

}

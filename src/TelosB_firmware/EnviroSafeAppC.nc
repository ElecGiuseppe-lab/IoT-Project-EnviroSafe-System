configuration EnviroSafeAppC {
}


implementation {

	components uartConfigC, EnviroSafeC, SerialPrintfC;

	components MainC;
	EnviroSafeC.Boot -> MainC;  

	components new TimerMilliC() as Timer0;
	components new TimerMilliC() as Timer1;
	EnviroSafeC.SamplingTimer0 -> Timer0;
	EnviroSafeC.SamplingTimer1 -> Timer1;

	components LedsC;
	EnviroSafeC.Leds -> LedsC;

	components new CircularBufferC(DIM_CIRC_BUFFER) as CB_temperature;
	components new CircularBufferC(DIM_CIRC_BUFFER) as CB_humidity;
	EnviroSafeC.CB_temp -> CB_temperature;
	EnviroSafeC.CB_hum -> CB_humidity;

	components MQ6InterpolationC;
	components MQ7InterpolationC;
	EnviroSafeC.ppmPropane -> MQ6InterpolationC;
	EnviroSafeC.ppmCO -> MQ7InterpolationC;

	components new SensirionSht11C() as TemperatureDriver; 
	components new SensirionSht11C() as HumidityDriver;
	components new Msp430adc0C() as ADC0;
	components new Msp430adc1C() as ADC1;
	components new Msp430adc2C() as ADC2;
	EnviroSafeC.RawPropane -> ADC0;
	EnviroSafeC.RawCO -> ADC1;
	EnviroSafeC.RawFlame -> ADC2;
	EnviroSafeC.RawTemp -> TemperatureDriver.Temperature;
	EnviroSafeC.RawHumidity -> HumidityDriver.Humidity;

	components new Msp430Uart0C();
	Msp430Uart0C.Msp430UartConfigure -> uartConfigC;
	EnviroSafeC.Resource -> Msp430Uart0C;
	EnviroSafeC.UartStream -> Msp430Uart0C;

}


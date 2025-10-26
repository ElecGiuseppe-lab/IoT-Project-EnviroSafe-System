generic configuration Msp430adc1C() {

  provides interface Read<uint16_t>;

}


implementation {

  components new AdcReadClientC();
  Read = AdcReadClientC;

  components Msp430adc1P;
  AdcReadClientC.AdcConfigure -> Msp430adc1P;

}

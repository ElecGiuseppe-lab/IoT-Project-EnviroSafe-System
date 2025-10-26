generic configuration Msp430adc2C() {

  provides interface Read<uint16_t>;

}


implementation {

  components new AdcReadClientC();
  Read = AdcReadClientC;

  components Msp430adc2P;
  AdcReadClientC.AdcConfigure -> Msp430adc2P;

}

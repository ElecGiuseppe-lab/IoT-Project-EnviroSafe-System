generic configuration Msp430adc0C() {

  provides interface Read<uint16_t>;

}


implementation {

  components new AdcReadClientC();
  Read = AdcReadClientC;

  components Msp430adc0P;
  AdcReadClientC.AdcConfigure -> Msp430adc0P;

}

configuration uartConfigC {

  provides interface Msp430UartConfigure;

}


implementation {

  components uartConfigP;
  Msp430UartConfigure = uartConfigP;

}

generic configuration Msp430SensorsAdcC() {
  provides interface Read<uint16_t> as rawLPG;
  provides interface Read<uint16_t> as rawCO;
  provides interface Read<uint16_t> as rawFlame;
}
implementation {
  components new AdcReadClientC() as ClientLPG;
  components new AdcReadClientC() as ClientCO;
  components new AdcReadClientC() as ClientFlame;
  rawLPG = ClientLPG;
  rawCO = ClientCO;
  rawFlame = ClientFlame;

  components Msp430SensorsAdcP;
  ClientLPG.AdcConfigure -> Msp430SensorsAdcP.configADC0;
  ClientCO.AdcConfigure -> Msp430SensorsAdcP.configADC1;
  ClientFlame.AdcConfigure -> Msp430SensorsAdcP.configADC2;
}
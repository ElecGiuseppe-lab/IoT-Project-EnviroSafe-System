#include <Msp430Adc12.h>

module Msp430SensorsAdcP {
  provides interface AdcConfigure<const msp430adc12_channel_config_t*> as ADC0;
  provides interface AdcConfigure<const msp430adc12_channel_config_t*> as ADC1;
  provides interface AdcConfigure<const msp430adc12_channel_config_t*> as ADC2;
}
implementation {

  const msp430adc12_channel_config_t configADC0 = {
      inch: INPUT_CHANNEL_A0,
      sref: REFERENCE_AVcc_AVss,
      ref2_5v: REFVOLT_LEVEL_NONE,
      adc12ssel: SHT_SOURCE_ACLK,
      adc12div: SHT_CLOCK_DIV_1,
      sht: SAMPLE_HOLD_4_CYCLES,
      sampcon_ssel: SAMPCON_SOURCE_SMCLK,
      sampcon_id: SAMPCON_CLOCK_DIV_1
  };
  
  const msp430adc12_channel_config_t configADC1 = {
      inch: INPUT_CHANNEL_A1,
      sref: REFERENCE_AVcc_AVss,
      ref2_5v: REFVOLT_LEVEL_NONE,
      adc12ssel: SHT_SOURCE_ACLK,
      adc12div: SHT_CLOCK_DIV_1,
      sht: SAMPLE_HOLD_4_CYCLES,
      sampcon_ssel: SAMPCON_SOURCE_SMCLK,
      sampcon_id: SAMPCON_CLOCK_DIV_1
	  
  const msp430adc12_channel_config_t configADC2 = {
      inch: INPUT_CHANNEL_A2,
      sref: REFERENCE_AVcc_AVss,
      ref2_5v: REFVOLT_LEVEL_NONE,
      adc12ssel: SHT_SOURCE_ACLK,
      adc12div: SHT_CLOCK_DIV_1,
      sht: SAMPLE_HOLD_4_CYCLES,
      sampcon_ssel: SAMPCON_SOURCE_SMCLK,
      sampcon_id: SAMPCON_CLOCK_DIV_1
  };
  
  async command const msp430adc12_channel_config_t* ADC0.getConfiguration() {
    return &configADC0;
  }
  
  async command const msp430adc12_channel_config_t* ADC1.getConfiguration() {
    return &configADC1;
  }
  
  async command const msp430adc12_channel_config_t* ADC2.getConfiguration() {
    return &configADC2;
  }
}
generic module CircularBufferC(uint16_t dim_buffer ) {

  //Dichiarazione interfacce fornite ed utilizzate dal componente (in questo caso il componente non fa uso di interfacce)

  provides interface CircularBuffer ;

}

//implementazione dei comdandi dichiarati nell'interfaccia fornita dal componente

implementation {

  uint16_t buffer[dim_buffer];
  uint16_t free_pos = 0;
  uint16_t i_wStart = 0;
  uint16_t i;

  command uint16_t CircularBuffer.size() {

	return dim_buffer;
  }

  command void CircularBuffer.init() {

	memset(buffer, 0, sizeof(buffer));
	free_pos = 0;
	i_wStart = 0;
  }

  //Ragioniamo in termini dell'ultima posizione libera, quindi l'elemento nella posizione precedente rappresenta l'ultimo elemento
  //inserito

  command uint16_t CircularBuffer.latestElem() {

	if (free_pos == 0)
	   return buffer[dim_buffer-1];	
	else
	   return buffer[free_pos-1];
  }

  command void CircularBuffer.putElem(uint16_t value) {

	buffer[free_pos] = value;
	free_pos = (free_pos + 1) % dim_buffer;
  }

  command void CircularBuffer.getWindow(uint16_t* window, uint16_t wSize, uint16_t shiftSize) {

	i_wStart = (i_wStart + shiftSize) % dim_buffer;

	if (wSize > dim_buffer) {
           wSize = dim_buffer; // Limita wSize alla dimensione del buffer
    	}

	for (i=0; i<wSize; i++) {
	    window[i] = buffer[(i_wStart + i) % dim_buffer];
	}

  }

}

interface CircularBuffer {

  command uint16_t size();

  command void init();

  command void putElem(uint16_t value);

  command uint16_t latestElem();

  command void getWindow(uint16_t* window, uint16_t wSize, uint16_t shiftSize); //uint16_t* window passa il riferimento
                                                                                //alla variabile (array), precedentemente
                                                                                //dichiarata, in cui allocare i valori della
                                                                                //finestra. Cioe' l'area di memoria dove devono
                                                                                //essere copiati i valori della finestra glielo
                                                                                //passiamo noi come riferimento.

}

#include <iostream>
#include <math.h>
#include <fstream>
#include <string>
#include <sysinfoapi.h>
#include <thread>
#include <chrono>
using namespace std;

struct MyStruct {
  WORD wYear;
  WORD wMonth;
  WORD wDayOfWeek;
  WORD wDay;
  WORD wHour;
  WORD wMinute;
  WORD wSecond;
  WORD wMilliseconds;
};

void hexdump(void *ptr, int buflen) {
  unsigned char *buf = (unsigned char*)ptr;
  int i, j;
  for (i=0; i<buflen; i+=16) {
    printf("%06x: ", i);
    for (j=0; j<16; j++) 
      if (i+j < buflen)
        printf("%02x ", buf[i+j]);
      else
        printf("   ");
    printf(" ");
    for (j=0; j<16; j++) 
      if (i+j < buflen)

        printf("%c", isprint(buf[i+j]) ? buf[i+j] : '.');
    printf("\n");
  }
}

int main() {
    SYSTEMTIME john;
    SYSTEMTIME *johnAddress = &john;

    john.wYear = 1;
    john.wMonth = 1;
    john.wDayOfWeek = 1;
    john. wDay = 1;
    john.wHour = 1;
    john.wMinute = 1;
    john. wMilliseconds = 1;
    
    

    hexdump(johnAddress,128);

    int n = 0;
    cin >> n;
    return 0;
}



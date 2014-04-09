#include <stdio.h>
#include <string.h>
int main(int argc, char* argv[]) {
  int a = atoi(argv[1]);
  int b = atoi(argv[2]);
  int s = 0;
  long ss = 0;
  int v;
  long t = 1;
  if (a >= 0) {
    if (a < 50) {
      for (int i = 0; i < 50; i++) {
        v = 4*i;
        s = s+v;
      }
      ss = ss+s;
    }
  }
  if ((b >= 0) && (b <= 50)) {
    int j = 0;
    s = 1;
    while (j < b) {
      j+=2;
      s = s + 6;
    }
    ss = ss+s+t;;
  }
  printf("%ld\n", ss);
  return ss;
}

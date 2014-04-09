#include <klee/klee.h>

int main() {

  int a;
  klee_make_symbolic(&a, sizeof(a), "a");
  int s = 0;
  long ss = 0;
  int v;
  if (a >= 0) {
    if (a < 50) {
      for (int i = 0; i < 50; i++) {
        v = 4*i;
        s = s+v;
      }
      ss = ss+s;
    }
  }
  return ss;
}

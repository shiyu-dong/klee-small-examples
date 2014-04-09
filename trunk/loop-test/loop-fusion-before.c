#include <klee/klee.h>

int main() {
  int a;
  klee_make_symbolic(&a, sizeof(a), "a");
  int x = 0;
  int y = 0;
  int i;
  if ((a >= 0) && (a < 10)){
    for (i = 0; i < a; i++)
      x = x + 3;
    for (i = 0; i < a; i++)
      y = y + 4;
  }
  return x + y;
}

#include <klee/klee.h>

int main() {
  int a;
  klee_make_symbolic(&a, sizeof(a), "a");
  if (a > 0){
   
  for (int i = 0; i < 3;) {
    i = i + a;
    }
  }
  return a;
}

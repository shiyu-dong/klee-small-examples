int main() {
  int a;
  klee_make_symbolic(&a, sizeof(a), "a");
  klee_assume(a > 0);
  klee_assume(a < 51);
  int x = 0;
  int y = 0;
  int i;
  for (i = 0; i < a + 1; i++) {
    x = x + 3;
    y = y + 4;
  }
  return x + y;
}

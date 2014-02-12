int main() {

  int i,j;
  int n=1000;
  int x;
  klee_make_symbolic(&x, sizeof(x),"x");
  klee_assume(x>0);
  klee_assume(x<10);
  //int y = x + 1;
  //int z = y + 1;
  int z = x + 2;
  for (i = 0; i < x; i++) {
    z = z << 2;
  }
  if (z == x + 2)
    return 0;
  else
    return z;
}

int main() {

  int i,j;
  int n=1000;
  int x;
  //klee_make_symbolic(&x, sizeof(x),"x");
  //klee_assume(x>0);
  //klee_assume(x<1000);
  int a[n];
  //for(i=0;i<1000;++i)
  //  a[i]=x;
  for(i=0,j=0;i*i<1000,j<1000;++i,++j)
    a[i]+=i*j;

  return a[50];

}

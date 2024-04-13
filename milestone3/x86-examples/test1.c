long proc2(long);

long proc1(long x, long y) {
  long u = proc2(y);
  long v = proc2(x);
  return u + v;
}

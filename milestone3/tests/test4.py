# Python program to display the Fibonacci sequence

def recur_fibo(n : int) -> int:
   if n <= 1:
       return n
   else:
       return(recur_fibo(n-1) + recur_fibo(n-2))

def iter_fibo(n : int) -> int:
  if n <= 1:
    return n
  else:
    a : int = 1
    b : int = 0
    i : int = 0
    for i in range(1, n):
      a = a + b
      b = a - b
    return a

def catalan(n : int) -> int:  
  #negative value
  if n <=1 :
    return 1
  # Catalan(n) = catalan(i)*catalan(n-i-1)
  res:int = 0
  i:int = 0
  for i in range(n):
    res = res + catalan(i) * catalan(n-i-1)
  return res

def main():
  nterms : int = 10
  # check if the number of terms is valid
  if nterms <= 0:
    print("Plese enter a positive integer")
  else:
    print("Fibonacci sequence:")
    i : int = 0
    print("Recursive function")
    while i < nterms:
      print(recur_fibo(i))
      i = i + 1
    i = 0
    print("Iterative function")
    while i < nterms:
      print(iter_fibo(i))
      i = i + 1
    print("Catalan sequence:")
    i = 0
    while i < nterms:
      print(catalan(i))
      i = i + 1

if __name__ == "__main__":
  main()

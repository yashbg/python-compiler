def foo(s: str):
  print(s)


def main():
  s: str = "Hello, World!"
  foo(s)

  s1: str = "cde"
  s2: str = "abc"

  print("String 1:")
  foo(s1)

  print("String 2:")
  foo(s2)
  
  print("== != check:")
  if s1 == s2:
    foo("Strings are equal")
  elif s1 != s2:
    foo("Strings are not equal")
  
  print("< > check:")
  if s1 < s2:
    foo("String 1 is less than String 2")
  elif s1 > s2:
    foo("String 1 is greater than String 2")
  
  print("<= >= check:")
  if s1 <= s2:
    foo("String 1 is less than or equal to String 2") 
  elif s1 >= s2:  
    foo("String 1 is greater than or equal to String 2")


if __name__ == '__main__':
  main()

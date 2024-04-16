class A:

  def __init__(self):
    self.x: int = 1
    self.y: int = 3


class B(A):

  def __init__(self):
    self.x = 1
    self.y = 3
    self.z: int = 5


def main():
  a: A = A()
  b: B = B()
  x: int = a.x
  y: int = a.y
  print(x)
  print(y)


if __name__ == '__main__':
  main()

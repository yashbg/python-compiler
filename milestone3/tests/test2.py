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
  print(a.x)
  print(a.y)


if __name__ == '__main__':
  main()

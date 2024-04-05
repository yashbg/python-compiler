class A:

  def __init__(self):
    self.x: int = 1
    self.y: float = 3.14


class B(A):

  def __init__(self):
    self.x = 1
    self.y = 3.14
    self.z: str = "I am new"


def main():
  a: A = A()
  b: B = B()


if __name__ == '__main__':
  main()

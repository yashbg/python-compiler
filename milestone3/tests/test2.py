class ShiftReduceParser:

  def __init__(self, name_: str):
    self.srname: str = name_
  
  def update_name(self, name_: str):
    self.srname = name_


class CLRParser(ShiftReduceParser):

  def __init__(self, myname_: str, srname_: str):
    self.srname = srname_
    self.clrname: str = myname_


class LALRParser(CLRParser):

  def __init__(self, myname_: str, clrname_: str, srname_: str):
    self.srname = srname_
    self.clrname = clrname_
    self.lalrname: str = myname_

  def print_name(self):
    print("SLR name:")
    print(self.srname)
    print("CLR name:")
    print(self.clrname)
    print("LALR name:")
    print(self.lalrname)


def main():
  parser: LALRParser = LALRParser("LALR", "CLR", "SR")
  parser.update_name("Shift-Reduce")
  parser.print_name()


if __name__ == "__main__":
  main()

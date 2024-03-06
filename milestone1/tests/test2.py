def add(x, y):
  return x + y

def subtract(x, y):
  return x - y

def multiply(x, y):
  return x * y

def divide(x, y):
  if y == 0:
    print("Cannot divide by zero!")
  else:
    return x / y

def power(x, y):
  return x ** y

def modulo(x, y):
  return x % y

if __name__ == "__main__":
  while True:
    print("Select operation:")
    print("1. Add")
    print("2. Subtract")
    print("3. Multiply")
    print("4. Divide")
    print("5. Power")
    print("6. Modulo")

    choice = input("Enter choice (1/2/3/4/5/6): ")

    if choice in ('1', '2', '3', '4','5','6'):
      num1 = float(input("Enter first number: "))
      num2 = float(input("Enter second number: "))

      if choice == '1':
        print("Result:", add(num1, num2))
      elif choice == '2':
        print("Result:", subtract(num1, num2))
      elif choice == '3':
        print("Result:", multiply(num1, num2))
      elif choice == '4':
        print("Result:", divide(num1, num2))
      elif choice == '5':
        print("Result:", power(num1, num2))
      elif choice == '6':
        print("Result:", modulo(num1, num2))
      else:
        print("Invalid input")
    else:
      print("Invalid input")

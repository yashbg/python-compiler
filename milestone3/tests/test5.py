def binarySearch(array: list[int], x: int, low: int, high: int) -> int:
  while low <= high:
    mid: int = low + (high - low) / 2
    # if mid == 1:
    #   low = high +1
    if array[mid] == x:
      return mid
    elif array[mid] < x:
      low = mid + 1
    else:
      high = mid - 1
  return -1


def linearSearch(array: list[int], x: int) -> int:
  i: int = 0
  for i in range(len(array)):
    if array[i] == x:
      return i
  return -1


def main():
  array: list[int] = [3, 4, 5, 6, 7, 8, 9, 10]
  l : int = 8
  result1: int = binarySearch(array, 4, 0, l - 1)
  # result1 : int =4/2
  if result1 != -1:
    print("Binary search: element is present at index:")
    print(result1)
  else:
    print("Binary search: element is not present")
  result2: int = linearSearch(array, 4)
  print("")
  if result2 != -1:
    print("Linear search: element is present at index:")
    print(result2)
  else:
    print("Linear search: element is not present")


if __name__ == "__main__":
  main()

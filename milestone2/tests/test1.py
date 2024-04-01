def bubbleSort(array: list[int], n: int) -> None:
  i: int = 0
  for i in range(n):
    swapped: bool = False
    j: int = 0
    for j in range(0, n - i - 1):
      if array[j] > array[j + 1]:
        temp: int = array[j]
        array[j] = array[j + 1]
        array[j + 1] = temp
        swapped = True
    if not swapped:
      break


def insertionSort(arr: list[int], n: int) -> None:
  i: int = 0
  for i in range(1, n):
    key: int = arr[i] 
    j: int = i - 1
    while j >= 0 and key < arr[j]:
      arr[j + 1] = arr[j]
      j -= 1
    arr[j + 1] = key


def main():
  data1: list[int] = [-2, 45, 0, 11, -9]
  data2: list[int] = [-2, 45, 0, 11, -9]

  bubbleSort(data1, 5)
  insertionSort(data2, 5)

  print('Sorted array using bubble sort:')
  i: int = 0
  for i in range(n):
    print(data1[i])
  
  print('Sorted array using insertion sort:')
  for i in range(n):
    print(data2[i])


if __name__ == "__main__":
  main()

# Iterative control flow

Since variables in Daml are immutable, we can't use loop-constructs such as
while or for-loops because the variables can't change their value iteratively

Daml has three ways to iterate
- Recursion
- Map functions
- Folds

## Recursion
In a recursive function, the function call itself with an argument value different from what it was called with previously

```haskell
fibonacci: Int -> Int
fibonacci n
    | n <= 2 = 1
    | otherwise = fibonacci (n - 2) + fibonacci (n - 1)


testFibonacci : Script()
testFibonacci = script do
    debug $ fibonacci 7 -- trace: 13 ?
```

## Map functions
takes two inputs, a function and a list, and returns a new list
```haskell
map: (a -> b) -> [a] -> [b]
```
an example
```haskell
modulusUsingMap: [Int] -> Int -> [Int]
modulusUsingMap x y = map (% y) x

doubleUsingMap: [Int] -> [Int]
doubleUsingMap x = map (* 2) x

testModulusUsingMap : Script()
testModulusUsingMap = script do
    debug $ modulusUsingMap [14, 15, 19, 20] 3
    debug $ 14 % 3 -- return the reminder after dividing 14 / 3
    debug $ doubleUsingMap [6, 12, 1]
```

## Folds
Folds are similar to the map function, but with an accumulator
With each iteration it stores the result in the accumulator and then use it in the following iteration
```haskell
sumList: [Int] -> Int
sumList x = foldl (+) 0 x
-- takes:
-- '(+)' is the binary function
-- '0' is the starting value
-- 'x' is the list
-- then:
-- applies the binary function to the starting value and to each element of the list until is finishes with all the list
```

`foldl` iterate from left to right
`foldr` iterate from right to left

### foldl
Left to right
```haskell
listToText: [Int] -> Text
listToText x = foldl (\acc y -> acc <> show y) "leftToRight: " x
```
`\acc y -> acc <> show y` lambda function
in the lambda function:
- takes two parameters `acc y`, where:
    - `acc` is the accumulator
    - `y` is an element
- returns (`-> acc <> show y`) a concatenation between the accumulator and the element
- uses `show` to convert the Int to Text

### foldr
Right to left
Switches position between the accumulator and the element
```haskell
reverseListToText: [Int] -> Text
reverseListToText x = foldr (\y acc -> acc <> show y) "rightToLeft: " x
```

### example
```haskell
-- Folds
sumList: [Int] -> Int
sumList x = foldl (+) 0 x

multiplyThem: [Int] -> Int
multiplyThem x = foldl (*) 1 x 

listToText: [Int] -> Text
listToText x = foldl (\acc y -> acc <> show y) "leftToRight: " x

reverseListToText: [Int] -> Text
reverseListToText x = foldr (\y acc -> acc <> show y) "rightToLeft: " x

testSumList : Script()
testSumList = script do
    debug $ sumList [1, 2, 4] -- trace: 7
    debug $ multiplyThem [2, 3] -- trace: 6

    debug $ listToText [1, 2, 3] -- trace: "leftToRight: 123"
    debug $ reverseListToText [1, 2, 3] -- trace: "rightToLeft: 321"

```


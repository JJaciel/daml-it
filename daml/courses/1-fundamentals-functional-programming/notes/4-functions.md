## Left and right associativity
Associativity is a property of binary operations or functions
If a function is associative, it means that rearranging the order of the expressions won't change the results
e.g.
```
2 + (3 + 4) = (2 + 3) + 4
-- these can be read from left and from right and are the same
```

Left Associative, as `substraction` and `division`
needs to be read from left to right
```
(2 - 3) - 4 ≠ (4 - 3) - 2
```

Right Associative, as `exponentials`
needs to be read from right to left
```text
-- given x raise to y raise to z
x^y^z = x^ (y^z) x^ (y^z) 
```

In the language
```haskell
add x y = (add x) y
```
`(add x)` is an **intermediate function** to which y is supplied as the argument
But, when parsing a function signature, we go from right to left, this means that can be 
```haskell
f: Int -> Int -> Int -> Int
or...
f: Int -> (Int -> Int -> Int)
```
interpreted as a function that takes one argument and returns another function that take the rest of the arguments

In Daml the function application is **Left association**

### Intermediate function

-- where `(add x)` is an intermediate function which receives argument `y`
add x y = (add x) y


## Currying
Currying is the process of converting a function with multiple arguments to a function that takes a single argument and returns another function
- All functions in Daml are curried
- All Daml functions can be viewed as taking one argument and returning a function
`f: Int -> (Int -> (Int -> Int))`
## Infix notation
given:
add: Int -> Int -> Int
-- add function's infix notation is the plus symbol between the two operands
add a b = a + b

For named functions like `add` and `increment`, Daml supports writing functions using `infix` notation by enclosing the function in `back ticks` (`)
```haskell
infix_add x y = x `add` y
```

Since any function can be applied with the infix notation, can also be applied prefix notation
```haskell
(+) a b = a + b
```

## Lambda functions
- uses inline notation
- don't have a name
- used only once in the place where they're written

Since are anonymous, they can't be called later or reused
```haskell
-- the backslash "\" is the lambda indicator
-- the "n" after the backslash would be the arguments
-- n + 1 would be the function definition
(\n -> n + 1)
```

## Exercises
```haskell
module Exercise1 where

import Daml.Script

-- Problem Statement 1
quadFunction : Int -> Int -> Int -> Int
quadFunction x y z = (3 * x ^ 2) + (2 * y) + z

testQuadFunction: Script()
testQuadFunction = script do
    debug $ quadFunction 1 2 3

testLambda: Script()
testLambda = script do
    debug $ (\ (x: Int) (y: Int) (z: Int)  -> (3 * x ^ 2) + (2 * y) + z) 1 2 3
    

-- Problem Statement 2
doubleMe: Int -> Int
doubleMe a = a * 2

doubleUs: Int -> Int -> Int
doubleUs a b = (doubleMe a) + (doubleMe b)



testDouble: Script()
testDouble = script do
    debug $ doubleMe 3
    debug $ doubleUs 3 4
    debug $ 3 `doubleUs` 4 -- prefix function used with infix notation


```



# Type Variables
`Type Variables` or `Type Parameters` help us define functions and data structures at a level of abstraction above the concrete data types
Allows to:
- help define functions and data structures
- allow for generic functions
- enable wider support for a range of data-types

Built-in data types that have type variables defines

This example have concrete data types
```haskell
add: Int -> Int -> Int
add x y = x + y
```

This built-in function hasn't concrete data types, instead have `type variables`
so it can be substituted with any data type
```haskell
sort: Ord a => [a] -> [a]
```
- `a` represents any data type
- `Ord` is a type constraint, it means that `a` represents any data type that belongs to the ord typeclass

other exaple is the function `map`
```haskell
map:: (a -> b) -> [a] -> [b]
```
- `(a -> b)` function maps `a` to `b`
-  `[a]` takes an array of type `a`
- `-> [b]` returns an array of type `b`


Custom example
```haskell
hello: Show a => a -> Text
hello a = "Hello " <> show a
```
signature:
- (type constraing) take a type a, that must be an instance of the `Show` typeclass
- takes an argument of type a and returns something of type Text

## Optional type
encapsulates an optional value
is used when a variable may either hold a specific value or may not hold anything

```haskell
data Optional a
    = None
    | Some a
        deriving (Eq, Show)
```
- Optional `a` can be either `None` or some `a`


Example 
```haskell
notSafeDiv: Int -> Int -> Int
notSafeDiv x y = x / y

safeDiv: Int -> Int -> Optional Int
safeDiv _ 0 = None -- has divided as underscore, indicating a catchall and divisor as zero
safeDiv x y = Some (x / y) -- this second pattern match will return some value of type Int


testOptional = script do
    debug $ notSafeDiv 6 2 -- trace: 3
    -- debug $ notSafeDiv 6 0 -- throws "DA.Exception.ArithmeticError" since a number cannot be divided by 0
    
    debug $ safeDiv 6 0 -- trace: None
    debug $ safeDiv 6 3 -- trace: Some 2
```
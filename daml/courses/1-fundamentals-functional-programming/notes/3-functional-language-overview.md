# Functional Language Overview
Daml as a programming language uses a functional programing paradigm

## Functional vs Imperative programming
### Imperative
Imperative languages: C, Java, Javascript
addition
```java
int x = 2
int y = 2
int add = x + y
```
increment
```java
int x = 5
x = x + 1
```

### Functional
Functional languages: Haskell
addition
```haskell
add x y = x + y
add 2 3
```
increment
```haskell
increment x = x + 1
increment 5
Trace: 6
```
- The variable doesn't change value once it's assigned, is stateles

### Some features of functional languages
- Functions are composable
- Functions are first class citizens -> They can be used and passed along as arguments to other functions
- Enables to create higher order functions
- Is atomic, it succeed or fail completely
- immutable variables
- stateles functions


## Haskell and Daml
Daml is built upon haskell

## Daml standard library
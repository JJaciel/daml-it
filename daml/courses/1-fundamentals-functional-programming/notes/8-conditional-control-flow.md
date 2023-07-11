# Conditional control flow
- if-then-else statements
- case statements
- guards
- conditional return types

```haskell
module ControlFlowExample where

import Daml.Script

-- If-then-else
-- uses boolean to test
ifOddOrEven: Int -> Text
ifOddOrEven x =
    if (x % 2 == 0) then "even"
    else "odd"

testOddOrEven: Script()
testOddOrEven = script do
    debug $ ifOddOrEven 5


-- Guards
-- many lines to test
-- uses boolean to test
findBmi: Decimal -> Decimal -> Text
findBmi height weight
    | weight / (height ^ 2) <= 18.5 = "Underweight"
    | weight / (height ^ 2) <= 25.0 = "Normal"
    | weight / (height ^ 2) <= 30.0 = "Overweight"
    | otherwise = "Obese"

findBmiTest: Script()
findBmiTest = script do
    debug $ findBmi 1.8 80.0

-- Guards with where binding
-- many lines to test
findBmi2: Decimal -> Decimal -> Text
findBmi2 height weight
    | bmi <= 18.5 = "Underweight"
    | bmi <= 25.0 = "Normal"
    | bmi <= 30.0 = "Overweight"
    | otherwise = "Obese"
    where bmi = weight / (height ^ 2)

findBmi2Test: Script()
findBmi2Test = script do
    debug $ findBmi 1.8 80.0

-- case
-- uses pattern matching to evaluate
caseOddOrEven: Int -> Text
caseOddOrEven x = case (x % 2) of
    0 -> "even"
    1 -> "odd"
    _ -> "unknown" -- catch all case

testCaseOddOrEven: Script()
testCaseOddOrEven = script do
    debug $ caseOddOrEven 4



-- Either
-- represents a type with values of two possible data types
-- Either a b <= either a value of type A or a value of type B
-- would return a different value type depending on evaluation
someFunc: Int -> Either Text Int
someFunc x =
    if (x < 0) then 
        Left "Error"
    else Right (x + 2)
-- is commonly used in error handling, by convention the Left side is for the error

someFuncTest: Script()
someFuncTest = script do
    debug $ someFunc (-2)
    debug $ someFunc 4

```

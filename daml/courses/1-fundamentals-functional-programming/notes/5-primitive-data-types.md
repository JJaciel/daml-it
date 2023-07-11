```haskell
module DataTypesExample where
import Daml.Script
import DA.Time
import DA.Date

-- Numeric types
datatype_test : Script()
datatype_test = script do
    -- let allows to bind values to variables locally, inside a block
    let 
        amount1 : Int
        amount1 = 10
    debug amount1

    -- the number of digits is set, it gets error if is more or less
    -- cannot be more that 38 digits before and after the decimal point.
    let 
        amount2 : Numeric 4
        amount2 = 10.9999
    debug amount2

    -- can deal with more than 38 digits before and after the decimal point. limit is on 2^15
    let 
        amount3 : BigNumeric
        amount3 = 10.99998888
    debug amount3

    return()

-- Time types
timedatatype_test : Script()
timedatatype_test = script do
    now1 <- getTime -- gets the ledger time
    -- "<>" Angle brackets is the string concatenation operator
    -- "show" converts non string variable to be printable
    debug $ "Time: " <> show now1

    let
        dateOfBirth: Date -- requires import of 'import DA.Date'
        dateOfBirth = date 1990 Oct 15

        timeOfBirth: Time 
        timeOfBirth = time dateOfBirth 23 59 59

        -- type for diferences in time
        age1: RelTime -- requires import of 'import DA.Time'
        -- subTime extracts time from now1
        age1 = subTime now1 timeOfBirth

    debug $ "DOB: " <> show dateOfBirth
    debug $ "Time: " <> show timeOfBirth
    debug $ "Age: " <> show age1


    now2 <- getTime
    debug $ "----------------------------------------------------"
    debug $ "Now 2 Time: " <> show now2

    let
        dateOfBirth2: Date -- requires import of 'import DA.Date'
        dateOfBirth2 = date 1990 Oct 15

        timeOfBirth2: Time 
        timeOfBirth2 = time dateOfBirth2 23 59 59

        today: Date
        today = date 2023 Jun 26

        now3: Time
        now3 = time today 11 55 0

    setTime now3
    debug $ "Now3: " <> show now3

    let 
        age2 : RelTime
        age2 = subTime now3 timeOfBirth2

    debug $ "age2: " <> show age2
```
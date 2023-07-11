# Typeclasses

Typeclasses are classes or categories of data types.
A typeclass is like an interface for a function that a data type can implement

Some built-in Typeclasses are:
- Show, it's a typeclass that Daml data types have implemented
- Eq

When a data type implements a function defined by a typeclass, it's say that the data type is an instance of that typeclass
So the `Int` data type is an instance of the show typeclass because it is implemented the show function of the typeclass show

```haskell
-- "class" is the reserved word to declare a typeclass
-- "Class_type" is the name of the typeclass
-- i is the input
-- o is the output
-- func_name: i -> o is the signature of the function
class Class_type i o where
    func_name: i -> o
```

then it has to be instantiated
```haskell
instance Class_type [Text] Int where
    func_name local_var_name = length local_var_name
```

## Data record
A data record is a data structure that contains one or more named fields of different data types

```haskell
-- "data" is the reserved word to declare a data type
-- the "Data_type" before the equal sign is the name of the data type
-- the "Data_type" after the equal sign is the constructor name and must be the same as the data type name
data Data_type = Data_type with
    field_name_1: Text
    field_name_2: Int
```

```haskell
module TypeclassExample where

import Daml.Script

data PersonalRecord = PersonalRecord with
    name: Text
    id: Int

testTypeclass : Script()
testTypeclass = script do
    let 
        somePerson = PersonalRecord with
            name = "Jac"
            id = 0
    -- would throw an error "No instance for (Show PersonalRecord) arising from a use of ‘debug’" due to this data type is not instance of the Show typeclass
    debug $ somePerson
```

Correct version
```haskell
module TypeclassExample where

import Daml.Script

data PersonalRecord = PersonalRecord with
    name: Text
    id: Int
        deriving (Show) -- making it an instance of the Show typeclass

testTypeclass : Script()
testTypeclass = script do
    let 
        somePerson = PersonalRecord with
            name = "Jac"
            id = 0
    debug $ somePerson

```
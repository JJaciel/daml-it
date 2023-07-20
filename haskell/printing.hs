

biggestInt, smallestInt :: Int -- data typing (not required)
biggestInt  = maxBound -- standard way to declare variables
smallestInt = minBound

anyOtherVariable = 5 -- is possible to declare without typing since type is infered

anString :: String
anString = "any string"

aChar :: Char
aChar = 'b'

aCharArray :: [Char]
aCharArray = ['h', 'o', 'l', 'a']

main = do -- main function
    -- declare this way inside a function
    let biggest = biggestInt -- different way to declare
    let zero = 0 -- define a new variable 
    let simpleString2 = "Another string"
    putStrLn "Simple string"
    putStrLn simpleString2
    putStrLn (show biggestInt) -- requires "show" since biggestInt is not an string
    print smallestInt -- use "print" to print anything that is not an string
    putStrLn (show 100)
    -- "++" concatenates two strings
    putStrLn ("Biggest Int is: " ++ show biggestInt ++ " and is given by the computer capabilities")
    putStrLn (show zero ++ " to " ++ show biggest)
    print anyOtherVariable
    putStrLn anString
    -- putStrLn aChar -- invalid since aChar is not an string or a Char Array
    print aChar -- this is valid
    putStrLn ("a char: " ++ show aChar) -- this is valid
    putStrLn aCharArray

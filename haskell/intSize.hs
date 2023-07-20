
biggestInt, smallestInt :: Int
biggestInt  = maxBound
smallestInt = minBound

main = do
    putStrLn (show biggestInt)
    putStrLn (show smallestInt)
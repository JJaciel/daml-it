# Learning Haskell
[Getting Started](https://www.haskell.org/get-started/)

## Installation
- Install GHCup, the Haskell universal installer [ghcup](https://www.haskell.org/ghcup/#)
```sh
curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh

Welcome to Haskell!

This script can download and install the following binaries:
  * ghcup - The Haskell toolchain installer
  * ghc   - The Glasgow Haskell Compiler
  * cabal - The Cabal build tool for managing Haskell software
  * stack - A cross-platform program for developing Haskell projects (similar to cabal)
  * hls   - (optional) A language server for developers to integrate with their editor/IDE

ghcup installs only into the following directory,
which can be removed anytime:
  /Users/jaciel/.ghcup

Press ENTER to proceed or ctrl-c to abort.
Note that this script can be re-run at any given time.

-------------------------------------------------------------------------------

Detected zsh shell on your system...
Do you want ghcup to automatically add the required PATH variable to "/Users/jaciel/.zshrc"?

[P] Yes, prepend  [A] Yes, append  [N] No  [?] Help (default is "P").

P
-------------------------------------------------------------------------------
Do you want to install haskell-language-server (HLS)?
HLS is a language-server that provides IDE-like functionality
and can integrate with different editors, such as Vim, Emacs, VS Code, Atom, ...
Also see https://haskell-language-server.readthedocs.io/en/stable/

[Y] Yes  [N] No  [?] Help (default is "N").

Y
-------------------------------------------------------------------------------
Do you want to enable better integration of stack with GHCup?
This means that stack won't install its own GHC versions, but uses GHCup's.
For more information see:
  https://docs.haskellstack.org/en/stable/yaml_configuration/#ghc-installation-customisation-experimental
If you want to keep stacks vanilla behavior, answer 'No'.

[Y] Yes  [N] No  [?] Help (default is "Y").

Y
-------------------------------------------------------------------------------
[ Info  ] downloading: https://raw.githubusercontent.com/haskell/ghcup-metadata/master/ghcup-0.0.7.yaml as file /Users/jaciel/.ghcup/cache/ghcup-0.0.7.yaml
[ Info  ] Upgrading GHCup...
[ Warn  ] No GHCup update available

System requirements 
Note: On OS X, in the course of running ghcup you will be given a dialog box to install the command line tools. Accept and the requirements will be installed for you. You will then need to run the command again.
On Darwin M1 you might also need a working llvm installed (e.g. via brew) and have the toolchain exposed in PATH.
Press ENTER to proceed or ctrl-c to abort.
Installation may take a while.

[ Info  ] GHC installation successful
[ Info  ] GHC 9.2.8 successfully set as default version
[ Info  ] Cabal installation successful
Config file /Users/jaciel/.cabal/config not found.
Writing default configuration to /Users/jaciel/.cabal/config
[ Info  ] HLS installation successful
[ Info  ] Stack manages GHC versions internally by default. To improve integration, please visit:
[ ...   ]   https://www.haskell.org/ghcup/guide/#stack-integration
[ ...   ] Also check out:
[ ...   ]   https://docs.haskellstack.org/en/stable/yaml_configuration

All done!

To start a simple repl, run:
  ghci

To start a new haskell project in the current directory, run:
  cabal init --interactive

To install other GHC versions and tools, run:
  ghcup tui

If you are new to Haskell, check out https://www.haskell.org/ghcup/steps/

```

- Install the Haskell extension on VSCode. [Haskell](https://marketplace.visualstudio.com/items?itemName=haskell.haskell)

## Using the REPL
To start a simple `repl`, run:
```sh
ghci
```

Then use it as:
```sh
ghci> 6 + 3^2 * 4
42
ghci> take 10 (filter even [43..])
[44,46,48,50,52,54,56,58,60,62]
ghci> sum it
530
```

Exit the `repl` presing `ctrl + d`

## Compiling a file
First create a haskell file (`.hs` file extension)
```haskell
-- hello.hs
main = do
  putStrLn "Hello, everybody!"
```
You can now compile it with ghc to produce an executable called hello that we will then run:
```haskell
ghc hello.hs
```
Then run it with
```haskell
./hello
-- outputs "Hello, everybody!"
```

## Resources
- [Haskell Documentation](https://www.haskell.org/documentation/)
- [Introductory Haskell course of the University of Pennsylvania (CIS194)](https://www.seas.upenn.edu/~cis1940/spring13/lectures.html)

# Haskell
## What is Haskell?
Haskell is a lazy, functional programming language created in the late 1980’s by a committee of academics. There were a plethora of lazy functional languages around, everyone had their favorite, and it was hard to communicate ideas. So a bunch of people got together and designed a new language, taking some of the best ideas from existing languages (and a few new ideas of their own). Haskell was born.

### Functional
<img src="https://www.seas.upenn.edu/~cis1940/spring13/images/function-machine.png" alt="functional programming haskell" width="600">
Haskell is a functional language, have two things:

- Functions are first-class, that is, functions are values which can be used in exactly the same ways as any other sort of value.

- The meaning of Haskell programs is centered around evaluating expressions rather than executing instructions.

### Pure
Haskell expressions are always referentially transparent, that is:

- No mutation! Everything (variables, data structures…) is immutable.

- Expressions never have “side effects” (like updating global variables or printing to the screen).

- Calling the same function with the same arguments results in the same output every time.

benefits:

- Equational reasoning and refactoring: In Haskell one can always “replace equals by equals”, just like you learned in algebra class.

- Parallelism: Evaluating expressions in parallel is easy when they are guaranteed not to affect one another.

- Fewer headaches: Simply put, unrestricted effects and action-at-a-distance makes for programs that are hard to debug, maintain, and reason about.

### Lazy
In Haskell, expressions are not evaluated until their results are actually needed. 

- It is easy to define a new control structure just by defining a function.

- It is possible to define and work with infinite data structures.

- It enables a more compositional programming style (see wholemeal programming).

- One major downside, however, is that reasoning about time and space usage becomes much more complicated!

### Statically typed
Every Haskell expression has a type, and types are all checked at compile-time. Programs with type errors will not even compile, much less run.

## Language Syntax
### Declarations and variables
Declarations and variables
Here is some Haskell code:

```haskell
x :: Int -- "::" means "has type"
x = 3

-- Note that normal (non-literate) comments are preceded by two hyphens
{- or enclosed
   in curly brace/hyphen pairs. -}
```

The above code declares a variable x with type Int (:: is pronounced “has type”) and declares the value of x to be 3. Note that this will be the value of x forever (at least, in this particular program). The value of x cannot be changed later.

**=** does not denotes *assignment*, it denotes *definition* 
```haskell
x = 4 -- "x is defined to be 4"
```

### Basic Types
Haskell has Machine-sized integers, it means that Ints are guaranteed by the Haskell language standard to accommodate values at least up to `\(\pm 2^{29}\)`, but the exact size depends on your architecture.

You can find the range on your machine by evaluating the following:
```haskell
biggestInt, smallestInt :: Int
biggestInt  = maxBound
smallestInt = minBound
```



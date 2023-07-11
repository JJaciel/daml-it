# Functor, Applicative, and Action 

functors, applicatives, and actions are critical to understand how transactions are submitted and perform in ledgers. An important point to keep in mind when working with the Canton Ledger is the difference between a pure expression and an action. 

## Pure Expressions

Pure expressions can be computed from the values of its arguments. You could write a pure expression down on a piece of paper without any context or side effects. For example, adding two numbers or sorting a list of integers doesn't require any contextual information and doesn't have any external side effects. The result of these operations is always the same for the same value of the same arguments.

## Actions

Actions, on the other hand, take place within a context. For example, the state of the ledger. The same action, an update to the ledger, can result in two different outcomes depending on when it's executed. Create contract action based on a template with a contract key may succeed or fail depending on whether an active contract with the same value of the key already exists on the ledger.

To understand how actions work, we first need to understand a few new type classes. The first of which is called a Functor. 

## Functor

Functor is a typeclass that's used for data types that can be mapped over for this purpose, an instance of a function typeclass must implement fmap functions. When we look at its signature, it takes a function, A maps to B, and F A, which means functor with values of type A.

It then maps it to a functor with values of type B. Note that F here means functor and not function. The function that a functor data type must implement is called fmap. An example of such a type is a list. The list data type implements the fmap in what we call a map. As you can see in the signature, it takes a function that maps values of type A to values of type B and A list containing values of type A.

The map function applies the function to each element in the list and returns the list containing values of type B. In this example, if X is a list of integers and we apply a map function with raise to the power of two to the list, the result in each element in the list will be raised to the power of two.

You'll often find fmap being denoted as a dollar sign between two angle brackets in the documentation. This notation is fmap's synonym where fmap is used in a prefix notation and the function name is followed by its input arguments. The dollar notation is used as an infix notation. The parenthetical plus two function here means we take another argument and add to it.

So parenthetical plus two x means x plus. The plus two function applied to the list will be applied to each element resulting in a list with three, four, and five as its elements. Taking the idea of functors a step further, we have another typeclass called Applicative. 

## Applicative

Applicative takes a functor that contains one or more functors and applies those functors to values in another function. The function for this typeclass is denoted as a star enclosed in angle brackets, and simply called the applicative function. The applicative function takes a functor value that has a function in it, and another functor and extracts the function from the first functor and maps it over the second one in the definition shown here.

F denotes the functor and an A maps to B denotes a function. So we can read this as an applicative function, takes a functor F that contains functions, that map values of type A to values of type B. It takes a functor containing values of Type A and it returns of functor containing values of type B. Let's take a look at some examples to see how this works.

In the first statement, we have three functors in a list. Multiply by zero, add 100, and raise to the power of two. So this is the first input, which is a functor with functions in it. The second input is another functor containing some values. For example, one, two, and three. The applicative function, shown as infix, function will apply the functors from the first functor on the left, one by one, to the values in the second functor on the right, giving us the output as shown here. In the second example, the function is given without one of the operands, and as these are binary functions, they'll need two operands.

So the first multiplication function is taken from the first functor and applied to the value one, which will give a partial application of the function. Then the second applicative function will apply this partial function to the first value in the third functor, making it one times three resulting in the value three as shown in the output.

In the same way, each function is applied to each value in the functors from left to right to produce the final answer. The third example is a combination of functor and applicative operations. It starts with a multiplication function applied to all three elements in the first list. This allows for partial functors, which are then applied to the second list producing nine values in the output.

As you can see, the basic essence of an applicative function is applying the functions in a functor to values in another functor. It's this idea which is applied to perform actions on the ledger. And for that we need to look at one more typeclass called action.

 

## Action Typeclass

Action typeclass is an applicative type that sequentially composes actions passing any value returned by the first action as an argument to the next. Its function is represented as the bind operator, which is two right angle brackets and an equal sign. This bind operator pipes the result of one action into the next.

The definition shows that the bind operator. Action M, that returns a value of type A. 

 A function that maps values of type A to an action that returns a value of type B. And finally, it returns the action that returns a value of type B. Here's our example that demonstrates how the bind operator works.

Let's say we have a function safeDiv that takes two ints, X and Y and returns an optional int. If Y is zero, then it returns none. Else it computes X divided by Y and returns the result as some int. We have another function reduce that takes an int X and returns an optional int. If X is zero or negative, then it returns none. Else it computes X minus one and returns it as some int. 

We want to pipe these functions in a sequence. In the first statement, we have safe div four two, which gives us some two. In the second statement, we have safeDiv four zero, which gives us none. In the third statement, we have safeDiv 4 2, which is then piped into reduce and we get some 1. And in the fourth statement, we have safeDiv four piped into reduce giving us none.

In this way, the bind operator allows sequencing a series of functions. An alternative to using the bind operator is the do-block that we've used in Daml several times. If we define a function, say binding actions, that takes two ins and then performs safeDiv, followed by reduce in a sequence, we can represent the same functionality by using a do-block where we first bind the results of safeDiv to a variable name Z, and then feed it into reduce.

The left arrow indicates binding that is specifically used when the expression on the right side is an action. Do blocks enable sequencing multiple actions together in this way. 

## Review

So let's summarize. 

When we perform actions on the ledger, such as exercising a choice or fetching a contract, we need to know that these actions are different from executing pure expressions. The two differences are that actions on the ledger have a context which changes their outcomes, and they have side effects on the ledger to understand how actions work. 

We first looked at functors and then applicatives. Functor is a typeclass that has a function fmap. It takes a function that maps A to B and applies to a functor containing A and returns a functor containing B. A good example for a functor is a list. 

Applicative is a typeclass that starts with a functor F that contains a function that maps A to B. It also takes a functor containing A and returns a functor containing B. We can think of this as a first functor containing functions and a second functor containing some values. The functions from the first functor are applied sequentially to the values in the second functor.

The third concept is an action typeclass, which has a binding operator that allows us to pipe the output of one function into the next in a sequence. The sequential execution of functors can be put into a do-block, making it easier to read and write actions.
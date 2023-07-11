# Actions and loops

We're going to look at actions and how they apply to the ledger. We'll also explore how to perform actions iteratively in things like loops. 

## Actions

Let's first review what an action typeclass is. It's an applicative type in which an actions output can be passed to the next action as an input. This typeclass gives us the bind operator that takes two things.

An action that produces a value of type A and a function that maps a value of type A to an action that produces a value of type B. It then results in an action that produces a value of type B. This bank service module has one template bank account. It has bank and account owner as two parties that are also the signatories. With this simple template, let's write a script that can help us look at how actions work. 

In this script, we allocate two parties as Alice and bank. Then we create an account with Alice as the owner with a balance as 100. With this, we query the ledger for bank account contracts visible to Alice. The query command, if you recall, returns a tuple with the contract ID and the contract payload as its first and second elements.

The next line prints the tuple, which you can see in the script output. If we look at these two statements, the second statement uses the output of the previous action as an input parameter. We can then pipe these outputs where the query output is fed into debug as an input. This example is the same way the do-block enables sequencing actions that are linked.

Now let's extend this example one step further with multiple accounts. We'll create three accounts, two for Alice and one for Bob, and then we'll use query to query all the bank account contracts visible to the bank. If we use debug on the accounts, we'll see a long list of tuples with all the contracts included.

Now, instead of doing it this way, what if we wanted to print one account at a time? We'd probably need to loop through the accounts list. This brings us to using loops in the context of an action that takes place in the context of a ledger. 

## Map function for loops

The map function takes a function and a list, and then applies the function to each element in the list to return another list of results. The example here shows my list with 1, 2, 3. We then use map to apply the function, multiply by two to the list. This will result in another list with 2, 4, 6. However, we can't apply the map function to the bank account example where we want to map the debug function over the accounts in the list.

If we do that, the compiler gives an error message pointing out a type mismatch. Daml is expecting a pure function and not an action here. So to deal with this issue, we have a special function called mapA, where A stands for action. 

## MapA

The basic signature for this function is similar to map, where it takes a function that returns an applicative function and a list.

The example here uses a Lambda function to print its arguments using the debug function. Since the return type of the debug function, and therefore our Lambda function is update, it's an instance of the action typeclass. That means it's an applicative func, and we can use map A to map this function over the accounts list.

Going back to the script, if we update the last two lines here, we'll see that the script fails. It gives an error message saying that it expects a script with no return value, but it's getting a script with some kind of list. 

## Do-blocks

This brings us to two important points. The first point is about how do-block work. A do-block returns the value from the last expression in the block.

In our example, the last line is the mapA function which returns a list. Our script signature at the top expects us to return a script with nothing. Daml doesn't like it when return types are mismatched. There are two ways to fix this. Change the return type from the script, from empty parentheses to square brackets, enclosing the parentheses.

This indicates that it's returning a list of tuples. Or, write a return statement at the end of the block with empty parentheses. In this solution, you'll notice that the linter will suggest changing mapA to mapA_. MapA_ works the same as mapA, but the difference is it does not return any value.

And so we can use mapA_ instead of mapA. However, there's a few things that we need to do... 

To use mapA, you'll need to import it from the DA.Foldable library because it's not part of the Prelude library that gets imported by default. 

## Return statement in Daml

The second consideration involves the return statement. Unlike other programming languages where return is a statement that returns the control to the calling function, return in Daml is actually an action in itself.

Let's take a closer look at that. 

Since the do-block returns the result of the last expression in the block, whatever the last statement evaluates becomes the return value for that block if there's no explicit return statement. That final return value must type match with the script signature at top. If you look at the signature of the return function, it shows that the function takes a value of Type A and injects it into an action M.

So effectively, the return with empty parentheses is injecting an empty value into the script action. 

Let's look at how do-block and return statement work in the case of a choice in a template. Let's say we have my choice in the bank account template that's supposed to return a contract ID for a bank account contract.

The return type shown in the signature is a syntactic sugar for an update action that takes it value of type, contract id, bank account. Now in the do-block, in that choice, we're doing multiple things. The first is creating a bank account that will return a contract id, which we bind to the account c i d variable.

Let's say that this is the value we want to return at the end. However, we may have to perform other actions like creating a contract, exercising a choice, and so on before returning. So at the end we say return account c i d as the last statement, which takes account c i d, and plugs it into the update action, thereby matching the return type of the choice.

While in practical terms, you can think of return like any other programming language and it won't pose any problem. Knowing how return behaves like an applicative and is actually an action on the ledger helps us troubleshoot at times. So now let's go to our example of using mapA to perform actions on the ledger in a loop.

The first working example here shows the script signature returning the type as script with a list of tuples and the last statement in the do-block as mapA function. The second working example lets the script signature show an empty parenthesis indicating nothing. The last statement in the do-block is the mapA underscore function that returns nothing.

And yes, you'll need to import the mapA underscore function from DA.Foldable. 

Another function, which is similar to mapA, is forA, which is often referred to as a for-each loop. 

Let's take a look at that. 

## forA

forA is similar to mapA, but its arguments are flipped. That is the first argument is the list, and the second argument is the function.

The for-each function will apply the given function to each element in the list to return another list. In our bank account example, there are two ways to use the for-each loop in our script. The first example shows us using forA as the last statement, which we know returns a list. So we can change the return type in the script signature at the top.

The second example shows using forA_, which like mapA_ returns nothing. And, you'll need to import four a underscore from the DA.Foldable library. 

Here's a review. 

## Review

We looked at how to use the action typeclass, which is an applicative that allows sequentially composing actions and passing the value returned by the first action as an input into the next.

While the action typeclass provides a binding operator, it's easier to use a do-block to sequence the actions together. Since actions are different from pure expresions, we saw that if we want to perform actions in a loop, we can't use looping functions like a map. We need special functions and we looked at two examples, mapA and forA. 

Both functions are available from the Prelude library, which is always imported in any Daml module, so you don't have to import it explicitly. If we don't need the values returned by mapA and forA, then we should use their counterparts mapA_, and forA_. These two functions aren't in prelude and need to be imported from the DA.Foldable library.
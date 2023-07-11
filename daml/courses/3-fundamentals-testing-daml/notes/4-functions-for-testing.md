# Functions for testing - transcript

Daml applications run in some of the most adversarial environments under certain conditions. It's possible for participants to act maliciously if they so choose. Daml applications define all valid transactions that can be committed to the ledger. This means when developing Daml apps, we must pay particular attention to identifying which transaction should be invalid and putting safeguards against them in our code. So let's look at how to establish conditions for creating contracts and transactions in case a user attempts to either create a contract or exercise a choice with invalid inputs. 

## Code Example

Here's the template for a social network user contract. Once a party creates a contract, the party can exercise the follow choice to follow another party.

A user can't follow themselves or follow the same party twice. Once the follow choice gets exercised, the newly followed party gets added to the following field, which is a list of parties. Our goal is to upgrade this template so that every party has an alias. We'll make sure that the alias can't be an empty string, and if the new alias provided by the party is invalid, we need the transaction to fail with an error. 

Also, we'll take a closer look at the assertions and explore some other ways we can print error messages. 

Let's start by tackling our first task. 

Adding an extra alias field to a template is as simple as adding alias text to the with block of the template to make sure the alias can't be an empty string.

## Ensure

We can use the ensure statement. 

Ensure allows us to specify the pre-condition for creating a contract. It takes a boolean expression as an argument so we can use this, which evaluates to a boolean. Using the ensure function this way safeguards against creating a contract with an empty string as the value for the alias field.

When the expression in the ensure clause evaluates false, the creation of the contract will fail. In our example, any transaction that attempts to create a social network user contract with the value of the alias field set to an empty string will fail. 

So let's go ahead and test it out. First, we'll attempt to create a contract with an empty string for the alias field, and we get an error saying that the template precondition we set up with the ensure statement is violated.

Now, if we try again with a valid input, DamlBeginner, we can see that a contract has been created successfully. Our ensure statement is working properly. Let's take a look at what we have before the final create statement. We have two assert message statements for checking some conditions. First, we'll make sure that a party can't follow themselves, and then we'll also make sure that a party can't follow the same party twice.

## AssertMsg

Assert message is a function that takes two arguments, an error message, and a boolean condition. The assert message checks the condition, and if it evaluates to false, it aborts the transaction with the message. This way, if a party tries to follow themselves or tries to follow someone twice, the transaction gets aborted.

## Assert

There's a similar function called assert that takes one argument, a boolean condition. Assert is similar to assert message in a sense that they both take a bullying condition as an argument, but unlike assert message, assert does not take a message. So the error thrown by assert is not as descriptive or helpful as assert message you can use either.

But assert message is recommended. Let's remove the comment for the assert and comment out the first assert message statement. We're replacing the first assert message statement with the assert statement to check how the error looks. When we use the assert function, we get a vague error message that says, assertion failed.

Thankfully, we only have two assertions written in this choice, but in a real world application, there may be hundreds of assertions and we'd have no idea where this error originated from. It does say the script execution failed on commit at social network user, but that's the line number of the test script, which has nothing to do with which assertion it is or where this assertion is located in the project directory. 

It's still unclear why the test failed. On the other hand, when we use the assertMsg function instead of the assert function, we can make the error message a lot more helpful. We can say, "you cannot follow yourself". Reading this message, we can immediately identify which assertion test failed.

## Abort

In addition to assert and assert message, there is another way that can fail a transaction, abort. Abort is a function that takes one argument, an error message, and text. Abort should be used carefully because it fails the current action unconditionally with an error message. We won't need it for the purpose of our demo.

But if we were to disable the follow choice indefinitely by making it error out, instead of completely deleting it, we could add an abort statement in the body of the follow choice. This way, every time someone tries to exercise this choice, the transaction will fail and they'll get an error message.

Depending on our business logic, we could also handle this error in various ways. We'll look at that in a future lesson. 

## Debug and Trace

Finally, let's talk about debug and trace. By now you're probably familiar with the debug statement, which prints text, but there's also trace that has a similar effect as debug. Debug takes one argument, which is text, and although it doesn't look like it's returning anything, it returns an empty update action and prints the text as a side effect.

Unlike debug, trace takes two arguments, text and a type parameter, a. Trace returns whatever a evaluates to and prints the text as a side effect. In the function signature of trace, it shows that trace takes text and an A and returns a. What this essentially means is that a can be of any type and that's what gets evaluated to be returned. So we can pass in any set of operations that evaluates to something in the place of A.

This is helpful since we can pass a message as the first argument and create a statement which evaluates to an update as the second argument of trace. As it returns what gets evaluated from the second arguement, it'll print the message "adding a new follower". 

One thing to note is that we called trace as the last statement in our choice body.

We were able to do this because we initially set our choice signature to return an update of contract id social network user, we're able to match the return type by passing the create statement, which evaluates to an update as the second argument of trace. If we were to write a debug statement as the last line of our choice body, we'd have to make sure that our choice signature also indicates the final return type to be an empty update, which is empty parentheses instead of contract id, social network user. Otherwise, we'll get a type check error. 

As a result, every time the follow choice is exercised, a message that says "Adding a new follower" gets printed. The last part of the test script where Alice exercises the follow choice on aliceCid to follow Bob shows in the transaction tree as TX one. In the last line of the transaction, we can see Bob in Alice's follow list in the last part of transaction zero.

Alice's following list was empty, so we can confirm that Bob was added to Alice's following list successfully. Since we wrote the command using trace, if we look at the bottom of the transaction tree where it says trace, we can see the message that we added using debug and trace, and they're printed in the exact order they're written in our choice. 

## Table view walkthrough

Let's walk through our workflow based on the final table view. First, Alice creates a new social network user contract, and initially she's following no one. Her alias is DamlBeginner, which is a valid input for the alias. In the next row, she follows Bob, where Bob gets access to viewing the contract.

As the new contract gets created, the old contract gets archived. As a reminder, since we added the debug and trace statements inside the follow choice body, as the choice gets exercised, messages are printed. These messages aren't visible in the table view, but they are in the transaction view where it says, trace. 

## Review

Let's review

We looked at how to define preconditions and assertions by using ensure, assert, and the assertMsg functions. We also learned how to unconditionally fail a transaction. 

By using the Debug and Trace functors, we were able to print messages as a side effect of returning something. 

Debug returns, an empty update, which makes it look like it isn't returning anything.

Trace prints a message as a side effect of returning whatever the second argument evaluates to. 

Challenge

Now it's your. 

Try and tweak the following choice to have additional preconditions and assertions. Defining preconditions for templates and assertions for choices is crucial for protecting a ledger from malicious users and keeping it sanitized.
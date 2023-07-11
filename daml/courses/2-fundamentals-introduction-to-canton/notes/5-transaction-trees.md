# Transaction Trees (video transcript)

Let's go over transaction trees and understand how actions on the ledger are performed. 

## Transactions

- A transaction is a list of actions submitted to the ledger automatically. 
- If any action in the transaction fails, the whole transaction fails. 
- A transaction tree is a way to visualize how each of these actions is processed by the ledger.

Each transaction is a tree with the action at its top node or the root and its consequences at its children. As shown in this illustration, TX zero is one transaction that starts with one action that leads to a consequence action one, which in turn leads to consequence action two. Transaction TX one has an action with one consequence.

Some actions may not have any consequences at all. 

A transaction tree captures four types of actions. 

Create, exercise, fetch, and key assertion

First, creating a new contract and setting its status to active. Second, exercising a choice on a contract resulting in consequences. One of the consequences of a choice if it's a consuming choice is the archival of the contract, but note that it's not recorded explicitly on a transaction tree because it's considered an implicit consequence of the choice.

Third fetch, which checks the existence and whether a contract is active. We can fetch a contract by its contract ID or its key. And fourth key assertion, which is an assertion that the given key is not assigned to any active contract on the ledger. So let's look at an example of a transaction tree. Here is the bank service module with two templates, bank account and bank service.

Bank account has one choice deposit, which creates a new account with the updated balance amount. Bank service has a choice, find account by id, which uses the fetch function to fetch the contract with the same ID as the one passed to it. 

On the script side, we allocate two parties, Alice and Bank, and then we submit a command to create an account that gives us the contract ID as Alice account c i d.

We then exercise the deposit choice with the amount as 20. Next we create a contract from the bank service template and then use its contract ID to exercise the find account by ID choice. Passing it the contract ID we got when we exercised deposit choice on Alice's account. So there are four things that we did.

We created Alice's account, deposited the amount of 20, created the bank service contract, and then exercised the find account by id. 

## Visualizing the transaction tree

Let's take a look at the visual representation of these four actions on the ledger. The first submit statement has the bank and Alice creating a bank account with an initial deposit of 100.

Note the root of this transaction with the id, zero colon zero. The number before the colon is the commit number, and the number after the colon is the action number. The root has one node for the create action that creates the account. The create nodes do not have consequences and do not have children nodes.

The second transaction has two actions. One action is the exercised deposit choice, and the second action is the creation of a new account. The creation of a new account happens automatically because the deposit choice is a consuming choice and will archive the contract it uses. And so after the deposit, a new account needs to be created.

Note that the archival is not shown as an action in this tree, as it's an implicit part of the exercise action.  This example shows us two types of nodes in a tree. Let's look at the third type that's fetch. TX two shows the creation of the bank service contract. Then TX three shows the choice Find account by ID, exercise, and within that it shows the fetch function being called.

## Key Assertion Demo

So far, we've seen how to create exercise and fetch actions as they're recorded in a transaction tree. The last type of action recorded in the tree is key assertion. A key assertion records the assertion that the given contract key is not assigned to any active contract on the ledger. So in a way, it's the negative outcome of a look up by key in the ledger.

The function, which helps us do this, is look up by key. And if the key isn't found, then it's recorded as key not found; that is as a key assert. The function signature shows that the function takes a key K as an input and results in an update that returns a value of type optional. This function signature also contains either a some contract ID if there's an active contract for the given template with the given key or none if no active contract with the given key exists.

So if we were to make a key assertion that a key K is not assigned to any active bank account contract on the ledger. Then we would say, look up by key at bank account. K. 

Let's look at an example. 

Continuing with the bank service example, let's make a few changes. First in the bank account template, let's add a key with bank and account owner as the two components and bank as its maintainer.

Second, in the bank service, let's add a choice check key, which takes a key as input and calls the lookup function to check if the key is being used. Lastly, in the script, we'll change three things. First, we create a new party, Bob. Second, we submit a command to exercise the check key choice, passing in the key as bank and Alice.

And third, we submit another command to exercise the check key. Passing it. The key as bank Bob. As you can see, transaction tree TX four has the root node as first check key choice exercise for Alice's account. It has a child node showing look up by key, which is the key assertion being logged in the ledger.

The second transaction is TX five with the root key as check key and the child as look up by key for Bob's account. This fails as we did not create an account for bob.  This shows the fourth type of action that gets logged in the ledger, that is the key assertion. 

## Review

So let's go over what we've covered. There are four types of actions that are recorded in a tree, create exercise, fetch, and key assertion.

At the root level, there are transactions which are broken down into actions. Each action is a node of a tree that may or may not have child nodes, depending on whether the action has any consequences. Three of the four actions create, fetch and key assertion, don't have consequences, and will not have child nodes.

Only exercise has consequences and would have child nodes.
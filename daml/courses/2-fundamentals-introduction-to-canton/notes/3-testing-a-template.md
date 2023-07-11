# Testing a template (video transcript)
You might have heard this mentioned before, but testing is integral to Daml. But before we go deeper into testing, let's review some context. 

## Daml and Canton

When building an application, we analyze the business process workflow. From that workflow, we capture the contractual logic for business agreements in Daml templates.

These templates are compiled into DAR files. That is a Daml archive file, and then uploaded to the Daml application backend or participant node. These DAR files are used by external client applications through the ledger APIs or through scripts by submitting commands. Through these APIs and scripts, we submit commands to create or archive contracts, exercise choices, and search for contracts.

A useful analogy is to think of the ledger as a database, and the code written in Daml template as SQL queries that directly interact with the database. However, any external application when it needs to interact with the database needs to use some kind of interface such as a driver or an API to connect with and then read and write to the database.

This analogy helps us think about the code we write in Daml templates as on ledger. Whereas what we write in scripts or external commands as off ledger. These commands are then submitted to the Daml backend services that process, validate, and carry out the commands on the ledger in the form of ledger update actions.

Understanding what is off ledger, on ledger and what update actions do helps us understand what and how we're testing. 

## Actions on the ledger

Let's dig in a little more into actions. The update actions written in templates versus the script. Actions in test scripts are both instances of the action typeclass. Type classes are like an interface for a function that a data type can implement.

So update a means a recipe to update to the ledger, which will return a value of type A. In a similar way, script A is a recipe for a test that returns a value of type A. And, as we just saw, script is just another Canton Ledger client using the same backend services that would be used by any other external client application.

This is what makes scripts a powerful tool to simulate and test out our workflows. 

## Example code

Let's take a look at some code. 

In this template, we define a choice where we use a do-block to wrap the create command. The result of the last expression in a do-block is the return value of that do-block. So in this last expression is a create statement which will create a new contract.

Here, the return value is contract ID of a bank account. But we know that the create action actually returns an update to the ledge. So saying that the return type is contract id, bank account is a syntactic sugar for saying that the choice will return an update action on the ledger that will return contract ID bank account.

## Writing a test script

Now, to test out this template, we need to write a script that can simulate this scenario. We'll create a new Daml module and call it test bank service and place it next to our bank account. Let's say our test scenario is that the party first creates an account with some initial amount and then exercises the deposit choice.

## Parties

So we first need to create two parties for our test. We'll start with this. Now, let's unpack this a little bit. First, bank and Alice on the left side of the arrow in the two statements are the names of the variables of type party. The left arrow is a way to bind the outcome of an action on the right side to the variable on the left.

It's different from an equal sign in the sense that what comes on the right of this arrow is not a pure expression, but an action that is carried out in the context of a ledger. This means the action is carried out against a specific ledger with a given state, which includes the Daml application running on the ledger, an active contract stored on it.

Parties are assigned a unique ID that are identified by the ledger, so this creation of parties is happening in the context of the ledger. The name Bank and Alice are strings that are displayed wherever needed for these parties. 

## Create command

Now we need to create an account for Alice, and for that we need to submit a create command to the ledger.

Creating an account here means creating a contract from the bank account template. When creating a contract using a script, we use the command create command wrapped inside a do-block, and submit it as a transaction. Notice that the command is create command, not create that was used in the template.

When a command requires authorization from one party, we use the keyword submit, followed by the name of the party. If we need more than one, then we use submit Multi. Submit multi takes two lists as arguments. The first list containing parties that have the act as authority, and the second one has parties that have read as authority.

Remember that parties are roles that are given specific permissions to either act as or read as, or both When templates are created, the command we're submitting creates the bank account contract, which requires act as authorization from the contract signatories, the bank and Alice.  In this example, we don't need read as authorization, so we'll leave the second list empty.

## SubmitMulti

An important note here about Submit multi. Submit multi is a useful shortcut in tests that allows you to create a setup for a unit test faster. But in client applications, submitting a command with authority from multiple parties is rare. When the authority from multiple parties is required, the workflows in Daml are designed to collect this authority using design patterns that we need to cover later.

For now, we'll work with Submit Multi to simulate a scenario where we have the necessary authorization from multiple parties. We then put the commands inside a do-block. The contract ID of the account created is bound to the Alice account, c i d variable through a left arrow. We can then use Alice account c i d to submit another transaction and deposit money in the account associated with the contract id. This time Alice will exercise her choice to deposit the money. For that, we say submit alice do exercise command, followed by the contract ID and the name of the choice. Then inside the with block, we provide the amount 20.

## Running a test script

As you can see, the way to send actions to the ledger is a little different in a script than a template. If everything compiles well, we'll see the link for script results, and when you click on it, you'll see the script result tab with some output. 

There are two types of views in the output tab that can be toggled by this button.

It shows the transaction view and the table view. The table view has the option to show archived and show detailed disclosure. The detailed disclosure option shows the roles each party has in the contract. Without that, we can only see if the contract is visible to the party or not by an X. The transaction view shows what is called a transaction tree, which is a tree of actions.

Our script has two types of actions, create and exercise. The starting route of the transaction tree is here at TX zero. The zero zero is an ID that refers to a Subtransaction. It consists of a commit number followed by a colon and a Subtransaction. In this commit, there's a create command for the bank account contract with these parameters.

At the top of this transaction it says, consumed by, and then points to the Subtransaction one zero created in transaction one. In transaction one, which is the second commit alice exercises the deposit choice. And within that exercise there's a child node in the tree with a new create. 

At the end, you can see the active contract section that has just one contract listed.

## Review

Okay, we've covered a lot in this lesson. Let's summarize. Daml templates implement multi-party smart contracts stored on the Canton Ledger that can then be accessed through front-end applications, test scripts, or integrations with other systems. We looked at submitting commands through a script where we saw the use of submit and submitMulti.

Submit Multi is a useful shortcut to simulate a scenario where we need to have authorization for more than one party. We also saw how to create contracts and exercise choices using create command and exercise command. These commands are processed and executed by the Daml backend to update the Canton Ledger.

When working with scripts, we can view their outcomes in a table view or a transaction tree view.
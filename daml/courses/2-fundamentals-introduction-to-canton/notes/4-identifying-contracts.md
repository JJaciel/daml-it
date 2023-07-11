# Identifying Contracts (video transcript)

Contracts are the smallest unit of work with a Daml ledger. So let's start with how to identify contracts with contract IDs and keys. 

## Contract IDs

Daml signs a unique contract ID to every contract that it creates. The contract ID is an inbuilt data type that is associated with a contract and can be used to access a contract.

However, contract IDs are not stable references as contract IDs are immutable. The only way to make a change in a contract is to archive the old one and create a new one. This means the old contract ID is no longer valid as now we have a new contract id. If we need a stable reference, then we can use the second method, which is to define contract keys within the template.

## Contract Keys 

A contract key can be created using a combination of parameters such as parties to create a unique, stable reference. For example, we can define a bank account as a contract between a bank and the account owner. Both of them are required to authorize the creation of the account. And they're  And they're both designated as signatories.

When the account is created, let's say it gets contract ID as zero one, let's say the template has been defined by the contract key made up of the bank and account owner's party IDs. When the account owner deposits $50, the old account is archived and the new one is created. The contract ID changes to zero two, but the contract key remains the same as its parties have not changed.

## Code Demo

Let's see how it's done in code. A key is defined in the where block as shown here. There are two statements to define a key. The first one tells what the key is made of. This key has a tuple that contains two parties, bank and the account owner. The components of the key are written within parentheses on the left of the colon.

On the right is provided their data types in the parentheses. The key can be an arbitrary serializable expression. However, the key can't contain contract IDs, and the key must include at least one party that is a signatory on the template. The second statement has the maintainer of the key, which must be one of the signatories that are part of the key.

The maintainer in this example is the first element of the tuple, which is the bank. The maintainers own the key in the same way the signatories own a contract. Just like signatories of contracts, prevent double spends or use of false contract data. Maintainers of keys prevent double allocation or incorrect lookups.

Also note that we need to be careful in designing contract keys. The way it's designed in this example, one account owner can only hold one account with a bank. If we need more than one account for each account holder, then we need to put some additional parameters in the key, for example, an account number to make the account.

## Fetch Action

Contract IDs and keys are very useful when we want to search for contracts. There are several ways to do that, but for now, we'll look at just one approach, and this is by using the fetch Action. Fetch allows us to check the existence and whether or not a contract is active. There are two ways that we can use fetch.

We can fetch by contract id, or we can fetch by a key. When fetching a contract id, we need to provide two arguments. First, the template name prefixed with an @ symbol to tell the compiler the type of contract needs to be fetched. However, this argument is optional. And second, the contract ID of the contract we want to fetch.

Note the return type in the signature of the fetch function. It's an updated action which returns T, which means the fetch results in an update in the ledger and returns the contract payload. Fetching by a contract key returns, both the contract ID and the contract payload. This time we use fetch by key, followed by the @ notation and the template name, and then the key defined in the template.

In this case, the template name is not optional. 

## Fetch code demo

Let's try this out in code. We've been working with the bank service module with one template bank account. Let's say the bank now needs a choice to be able to search for a bank account using its id, or its key. For that, let's introduce another template called bank service.

It has only one party, the bank, which is also the signatory.   The first choice we add is to find account by id, which should return the bank account. It takes one parameter, the contract id, and then in the do-block, we say fetch bank account id. All we want from this choice is that it should give us the account associated with a contract id. 

Note that we would normally use the fetch function as just one step in the larger, more complex process. Here we write a function just demonstrating how to use the fetch function. Now let's go to our script and test this choice. First, we need to create a contract out of the bank service template to be able to call its choice.

Here's how we do that. We had Alice account c i d from the previous submit, so we can use it to pass it to the find account buy ID choice. So we say this to check if we got it right. Let's write a debug statement like this. You'll be able to see the trace shows 100. Now let's take a look at how to fetch a contract by its key.

We have the contract key defined in the bank account. As such, now in the bank service, we create another choice, find account by key. This also returns a bank account. It takes the key as input, which in this case of bank account is a tuple containing two parties. Then in the do-block, we say this... 

Notice that fetch by key returns a tuple comprising two elements, contract ID and the contract payload. We're interested only in the payload, so we extract the second element from the tuple and return that. 

Now let's test this out in the script. 

Here's how we'll fetch it by the key. Now, when you write this, submit the script fails and shows an error.

This is because just before calling this, We had called the find account by ID Choice. And since all choices by default are consuming, the bank service contract was consumed and we're not able to call any other choice on it. So we need to go to the bank service template and make the find account by ID and find account by key choices as nonconsuming.

As soon as you do that, the script runs fine and the second debug statement also prints the value as 100. 

## Review

Let's review what we've covered. 

Contracts can be identified by contract ID and key contract IDs are assigned automatically to the contract when it's created. When a contract is archived and a new contract is created in its place, the contract ID changes, which makes contract IDs unstable references.

If you need a stable reference for a contract, then you need to specify a contract key that must have at least one signatory in it, along with any other parameter that can help uniquely identify a contract. Contract keys are specified in the where block of a template. They must also have at least one signatory as a maintainer of the key contract.

IDs and keys can be used to search for contracts, and for that we used fetch as one of the Functors that can be used in the choices for the template.
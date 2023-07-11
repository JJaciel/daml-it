# Retrieving Contracts (video transcript)

There are several ways to retrieve contracts from a ledger. To start with, there are two places where you would need to retrieve contracts in your code. One is within a choice, and the other is in a script. When retrieving contracts within a choice, we have two functions; Fetch, which fetches a contract for a given contract ID and fetched by key, which fetches a contract id and the contract payload for a given key.

The fetch functions and fetch by key when executed are logged in the transaction tree as a fetch action. However, the functions on the script side are query functions, which work differently from fetch. Let's go over these functions one by one. 

## Query 

The first function is a query which takes a party P and returns the list of tuples containing the contract ID and contract payload.

We need to be mindful of type constraints for templates and IsParty to make sure that we pass the correct data type to this function. 

Let's look at an example to understand how it works. Continuing with our bank service module, we have the bank account template. In another module named test queries, we'll write a script where we allocate three parties, bank, Alice and Bob, and then have two submit statements to create one account for Alice and one for Bob.

Now we want to query the ledger to see which bank accounts are visible to each of the three parties. In the first query statement, we say query at bank account, Alice, which means querying the ledger for active contracts of type bank account that are visible to Alice. The query function returns a list of tuples.

The first element is the contract ID and the second is the payload. We can also get the return list in a single variable of type list as the next query statement shows. The Bob list returned from the second query statement when printed shows, Bob's bank accounts, contract ID and payload. In the third query statement, we have two contracts that are visible to the bank.

## QueryContractId

A common use case is to query the ledger for a payload using a contract id. For that we can use the query contract ID function. It takes a party and the contract id, and if there is a contract with that ID that is visible to the party, then it is returned. Notice that the return type is optional. The query may return none if there's no active contract visible to the party p. 

Let's look at an example. Continuing with our bank account example, we have Alice as a party and have created an account with Alice, account c i d as the contract id. If we say query contract id, Alice, Alice account, c i d, we get Alice account as the. However, if we query for the same contract id, but with Bob as the party, the query returns none.

## QueryContractKey

A very similar query function is query contract key where the function takes the party and the key is inputs and returns an optional value with the contract payload. If there's an active contract with this key that's visible to the parties, it's returned. 

So let's look at an example. In our bank service module, let's say we have the bank account template with its key defined as a tuple using the bank and the account owner.

If we query the ledger with the statement as shown here with query contract key, we can pass it as the type at bank account followed by the party as Alice and the key as a tuple. We need to also include the two parties, bank and Alice. This will return the contract payload. When the debug statement prints Alice's account, you can see that it's Alice's account we created earlier. For the same query, if we change the party to Bob without changing the key, then the function returns none. 

## QueryFilter

The next type of query is when we want to filter out the query results based on a predicate, which is a boolean condition the contract must fulfill to be selected. The function is query filter to which we pass the template, the party, and the predicate.

It returns the set of active contracts of the template that are visible to the party and match the given predicate. In this example, we want to filter out those accounts that have a balance equal to or larger than 100. The query filter will take the template bank account and party as bank. We can then use a Lambda expression, which takes an account and checks for the predicate account balance and whether it's greater than or equal to 100. 

As shown in the script output, if we print just the return value, large accounts, we can see it as a list of tuples with the contract ID and contract payload. The second debug statement takes the first tuple and extracts its second element to print. 

## Review

Let's review. 

We looked at various ways to retrieve contracts from a ledger. When we perform retrieval as part of a choice in a template, we can use two functions fetch or fetch by key.

Both of them are recorded on the ledger as fetch actions and become part of the transaction tree. The retrieval performed from outside the ledger or off ledger are queries. We saw four different ways to query the ledger 

First, we queried for all active contracts that are visible to Party P, which returns a list of tuples with the contract ID and payload.

Second query contract id, which takes a party, P and a contract id. And if there is an active contract with the ID visible to the party P, then it returns the contract's payload. Third query contract key takes a party P, the template type T, and the key. And looks in the active contract set for contracts with key K visible to the party P.

If it's found, it returns the tuple with contract ID and the payload. 

And fourth, query filter, which takes the template T, party P and a predicate C, and then returns a list of tuples comprising contract IDs and the payloads if they match the predicate and are visible to the party.
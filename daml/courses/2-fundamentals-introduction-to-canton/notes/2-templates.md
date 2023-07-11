# Templates (video transcript)
Daml templates are the building blocks of a Daml application. To understand templates, we first need to understand the common structure of a .Daml file. 

## Module
A Daml file has a module, and the module name is the same as the file name. It then has all the import statements it needs, including other modules that you may create for your application.

## Templates
Templates are defined in modules. A template definition starts with a template keyword followed by the name of the template. Like modules, its name must start with a capital letter. The first thing inside a template is the with block that lists the parameters or the values needed when you create a contract out of this template. For each parameter in the template, the with block contains the name of the parameter and its type separated by a colon.

## Party
An important parameter type in this section is party. A template must have at least one party. A party is a special data type used in the ledger to represent an individual or an entity that participates in the contractual agreement defined in the template. Then there is the where block that contains several important components defining what parties can do in the form of choices.

## Creating a template
Let's create a simple template for a bank account to demonstrate how a template works. In a module called bank service, we'll write template, bank account, and then inside it start the with block. daml.yaml is a white space aware language, so consistent formatting and indentation is required. As you can see, everything below the template declaration forms the body of the template and must be indented.

Our bank account template needs two parties. Bank and account owner. Notice that we need to put the bank in here as a party because the account owners should not be able to create or archive accounts on their own. The bank is required to authorize all those bank related transactions. The third argument in this template is balance declared as a numeric two, which means a decimal value with two places after decimal.

Something to note here is that while we're using numeric two, in many of the examples, decimal is a more common data type used in Daml real world applications. Our use of numeric two is mainly to get a more readable output to be displayed when we're demonstrating the code in the lessons. 

Next comes the where block.

##  Signatories

The first thing we need to specify is the role parties will play. In this template, we'll make the bank and the account owner both signatories as both must authorize the creation of a bank account in the owner's name. In this model, we don't wanna make the data inside a bank account contract visible to anyone other than the signatories of the contract that is the bank and the account owner.

But if we did, we could specify the parties that would be able to view the data inside the contract as template observers. 

## Choices

Now we want to create a choice. Think of choices as methods or functions in a program that can take parameters, perform some task, and return a value. We want to create a choice to deposit money in this account.

So we say choice, deposit. A choice name must start with a capital letter. Then followed by a colon we have the return type. If we want to write a choice that does not return any value, then we can put empty parentheses.  But in this case, we want the choice to return some reference to the contract that's been updated.

## Contract ID

At this point, it's a good time to introduce a unique data type to Daml, and that's contract id. Daml assigns a unique contract ID to every contract that is created. The contract ID is an inbuilt data type that's automatically assigned to a contract and can be used to access it. It's associated with the template from which the contract was.

So the data type of the contract ID for the contract created from the bank account template will be contract ID bank account. Coming back to the deposit choice, if we want the choice to carry some parameters, then we create another with block this time for the choice variables. In this example, we want the amount to be deposited as the variable, so we specify that as amount numeric two.

An important decision we have to make at this time is how should we be able to exercise this choice? We have just two parties here, and for all practical purposes, we think it is the account owner who should make deposits. So we then write controller. Account owner. As you may recall, a controller is a party that is able to exercise a particular choice on a particular contract. Controllers must be an observer, otherwise they can't see the contract to exercise the choice.  

## Consuming and Nonconsuming choices

Let's look at what needs to be done when the choice is exercised. The actions in a choice are written inside a do-block. In our example, we want the amount passed to the choice to be deposited to the account. In other words, we want to change the balance amount in the account.

Now, if you recall, everything in the ledger is immutable, which means we can't simply change the balance value in the ledge. The only way to make that change is to archive the old entry and create a new account entry with the new value. Before we go any further, this is probably a good time to talk about types of choices.

There are two types of choices; consuming and nonconsuming. Choices by default are consuming. When a consuming choice is exercised, the contract on which it is exercised is archived. If you visualize a ledger as a table, a contract is a row in that table. The deposit choice that we are creating in our bank service template is currently defined as consuming by default.

So when Alice first creates an account with an initial deposit of a hundred dollars, it's stored as a row in the transaction table. When she exercises the deposit choice to add $20 to her account, there are three things that happen. First, the older row in the table is marked archived. This archival happens automatically when the type of choice is consuming.

Second, a new row is created, marked as active. And third, the new contract gets a new contract id. If we want to make the deposit choice as nonconsuming, then we need to use the keyword nonconsuming in the choice definition. In that case, when Alice exercises this choice, the older row will not be marked as an active, and a new row will be added with a new balance.

This isn't really what we want in this case, because now Alice's account has two active rows, which means she has two bank accounts, one with the balance of a hundred dollars, the other with the balance of $120. So we should keep the deposit as a consuming choice. There are situations where having many active records is exactly what we want, and we'll look at those later.

So all we need to do is create a new contract with a new balance. We say create bank account with, followed by all the variables it needs. Bank, account owner and balance. If we had written the choices as returning nothing by giving empty parentheses above, we would have to provide an explicit return statement with empty parentheses.

Instead, we choose to have it returned the contract id, so we don't need to specify the return type. Remember, the due blocks always return the result of the last expression. Our last statement is create, so we'll return the result of Create, which is contract id. Now, before we go any further, you might be thinking there has to be a better way of writing this.

## Code conventions

Well, there is, although the code here is readable and fairly easy to understand, we can make two changes to make it more concise. First, instead of saying create bank account, we can say, create this. Since we're creating something out of the same template, we're in. The keyword this refers to the data in a contract. It's also referred to as the payload. 

Second, we also see the variables bank and account owner are the same variables on both sides, so we can conveniently skip them, and Daml will understand the parameters that have the same name as the local variables and can be assigned their value. We've now written a simple template that has two parties and one choice for one of those parties.

# Navigator - transcript

Navigator is a front end application that comes bundled with the Daml SDK. Navigator can be used to connect to any Daml ledger and inspect and modify the ledger. It's a great tool to explore the flow and behavior of applications built in Daml. 

## "daml start"

To start navigator, use the Daml assistant by typing in "Daml start". 

This command compiles and builds the DAR files, starts the Canton Sandbox, uploads DAR files, and uses the initialization script specified in the daml.yaml file to set up parties, user IDs, and user rights. Based on these rights, the user will then be able to log into the application and view templates, view active and archived contracts and exercise choices.

## Example Daml Contract

To see these steps in action, let's first set up the scenario with a Daml template. Here's a module named Bank that has a template bank account. It has bank and account owner as parties, and a balance as numeric two. Bank is the signatory and account owner is the observer. The account has a key with bank and account owner parties as its two components, which will ensure that an account owner can only have one account.

There's only one choice deposit for which account owner is the conroller. This choice takes an amount as an argument and then creates a new account contract. With the balance updated with the amount, there's another template called bank service that has the bank as one party and a list of parties called customers.

This list will contain those parties that have an account. Bank is the signatory and customers are observers. There are two choices here. First is open account, which takes account owner as the argument and returns a tuple containing contract IDs of bank service and bank account. 

Bank is the controller for this choice. When this choice is exercised, two things happen. First, a new bank service contract is created with the account owner added to the customer list, and second, a bank account is created for the account owner. The contract IDs of both these new contracts are then returned. The second choice in this template is pay reward, which takes accountCid, and a reward amount.

It fetches the account payload with the given contract ID and archives the account, and then creates a new account contract with a balance that has the old balance plus the reward. So in this setup, you can see that the bank can open new accounts for customers and pay them some reward. Once an account is created, the account owners can deposit money into the account.

## Initialization script

With this setup, let's write out the initialization script. In Main.daml, there are three steps required to set up users. 

Step one, allocate parties. We'll create two parties, bank and customer. Now, you may have seen the allocateParty function before. The allocatePartyWithHint is a similar function that attaches the party ID hint string with the party ID string. It helps in readability as you'll see. 

Step two, create user IDs from the strings provided. We need two users, one for the bank and one for the customer. Let's say our customer's name is Alice, so we use that name to create her id. 

Step three, using the parties and user IDs created, we map the two using the create user function, which takes a user ID party name, and then the authority to act as or read.

So the first statement says that the user with bank ID is mapped to the bank party and it can act as bank in a similar way. A user with Alice ID is mapped to the customer party and can act as customer. Finally, to get the entire scenario started, we created our first contract for bank service. Notice that the customer's list in the argument is empty to start with.

## Run Navigator

This script runs before navigator is started. Navigator looks at daml.yaml to find the initialization. So let's open the daml.yaml file and change the init script variable to point to the main initialized user script we just created. With all this set up, let's go to the terminal and type Daml start.

Once the sandbox is up and running, the Navigator page will open in the browser and you'll see a drop town list with two users. The opening page shows the list of contracts visible to the primary party of this user, and you can see the bank service contract that was created in the script. The choice icon on the right shows the choices available in this contract as open account pay, reward, and archive. Although we didn't write a choice named archive, it's implicit in the contract. 

Let's start with the open account choice first to create a contract for a customer. This will open the choice page, which allows us to set the values for the choice arguments. On the left side, you see the signatories, which is just Acme Bank and contract details with bank as the party and customers as an empty list.

The open account choice requires the account owner, and when you click on the space, you'll see the parties in this contract. We'll choose cust as the party. And here you can see how the text that we provided as a hint when allocating parties comes in handy. We'll click on submit and then click on contract from the left panel to get back to the list of contracts.

We'll now see two contracts. One is bank bank service from before, and one is bank, bank account, which we just created. If you click on the bank service contract again, you'll see that this time the customer list isn't empty and has one customer, which is also shown in the observer's list. Back to the contracts list, let's check out the new bank account contract.

Here you see the contract key having two parties, Acme Bank and customer in a tuple. The balance is zero, so let's exercise the choice to deposit some amount. You can see the available choices in this contract up at the top, but if you recall, the deposit choice is available only for the account owner.

So even though the UI shows the choice, since we're logged in as the bank, we can't make a deposit. However, we know that the bank can exercise the pay reward choice from the bank service. So let's go back to the contracts one more time. We'll choose the PayReward choice. Enter the accountCid by choosing the bank account and enter the reward amount as 10.

Once you submit and go back to the contracts list, check the include archived box. At the top, you'll see that the old bank account contract was archived and a new one is created. Click on the new one and you'll see the balance is now 10. Now you can see how we can log in as a user, carry out the choices that are available to the party to which the user is mapped, and then examine how old contracts are archived and new ones created.

Knowing this, you should be able to log in as Alice as the customer, and then exercise the deposit choice to see what happens. 

## Review

So let's Review. Navigator is a front end web application that comes bundled with the SDK. It can then connect to a Daml ledger and helps in exploring and testing Daml. You can run it using the Daml assistant tool as Daml start.

Before using Navigator, you want to create the initialization script to perform initial setup activities on the ledger, such as allocating parties, creating users, and initial sets of contracts. Once Navigator is up and running, we can use its UI to log in as different users exercise choices available to those users and examine the contracts and workflow.
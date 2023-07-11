# Understanding Daml

## Study material/resources
- Official Daml video series [-> Daml 101](https://www.youtube.com/playlist?list=PLjLGVUzUMRxUqUXUGltc85HkB7CxsIYR4)

## Daml Architecture
<img src="https://docs.daml.com/_images/arch-intro-1.png" alt="Virtual Shared System of Record" width="600">

## More resources
- [Learn Daml](https://www.digitalasset.com/developers/learn/olde)
- [Docs](https://docs.daml.com/)
- [Questions](https://discuss.daml.com/)
- [Glossary](https://docs.daml.com/concepts/glossary.html)

## Re-engineering a template [source](https://www.youtube.com/watch?v=UlBs3F5DjfQ&list=PLjLGVUzUMRxUqUXUGltc85HkB7CxsIYR4&index=8&t=155s)

```haskell
module Main where -- defines the entire module, is required to be imported from another file

import Daml.Script -- helps to test the Daml

type AssetId = ContractId Asset -- defines the type of the output when we call the choices below

template Asset -- template name, can be more than one template in a module
  with -- below are listed the input parameters
    issuer : Party
    owner  : Party
    name   : Text
  where
    ensure name /= "" -- ensures that the name is not empty
    signatory issuer -- signatory is the party that can authorize the creation
    observer owner  -- observer is the party allowed to see this instance and all the information about it. it does NOT have to consent the creation.
    choice Give : AssetId -- "Give" is the choice name, and it would produce an "AssetId" type
      with
        newOwner : Party -- parameter necessary to exercise the choice
      controller owner -- controller is the party that can take the action
      do -- when the choice is exercised, it will trigger the create command
        create this with -- "this" is scoped to the template, in this case it refers to the asset
           owner = newOwner

setup : Script AssetId
setup = script do
-- user_setup_begin
  alice <- allocatePartyWithHint "Alice" (PartyIdHint "Alice")
  bob <- allocatePartyWithHint "Bob" (PartyIdHint "Bob")
  aliceId <- validateUserId "alice"
  bobId <- validateUserId "bob"
  createUser (User aliceId (Some alice)) [CanActAs alice]
  createUser (User bobId (Some bob)) [CanActAs bob]
-- user_setup_end

  aliceTV <- submit alice do
    createCmd Asset with
      issuer = alice
      owner = alice
      name = "TV"

  bobTV <- submit alice do
    exerciseCmd aliceTV Give with newOwner = bob

  submit bob do
    exerciseCmd bobTV Give with newOwner = alice
```

## Initiate & Accept pattern
multiple signatories
This excercise is to create a smart contract between a parent and its kid for paid chores
- asset: money
- people (parties): Me and my kid
- data: the list of chores and if are completed or not
- logic: for the work that is done correctly, its awarded.

- kid
  - propose 
  - revise
- parent
  - reject => it becomes an agreement (a contract) with both signatories authorizing it
  - accept


## Parties
- authorization - who can do what
- privacy - who can see what

Signatory
- party type
- required
- can be more than one, if > one parties listed are "AND".
- authorize creation and archival of contract

Observer
- party type
- optional
- can see the contract and transactions

Controller
- party type
- required
- can exercise choices

## JSON API
What can be done
- Creating Contracts
- Exercising Choices on Contracts
- Querying Current Active Contract Set
- Retrieving Known Parties

What can NOT be done
- Inspecting transactions
- Asynchronous submit/completion workflows
- Temporal queries

Flow
- frontEnd --> API --> Backend
- FE needs an access token to comunicate with the API, it can be provided by any jwt token
- 

Testing the API with postman
1. Run the sandbox
```sh
cd src/<project-name>
daml start
```
2. Open postman
3. Create a new collection exclusively for gPRC
4. use File → New… to create a new “gRPC Request”
5. For “Enter Server URL” use `localhost:6865`. Postman’s service reflection will automatically list the available methods.
6. Test the connection selecting the `GetLedgerIdentity` method. Should return something like:
```json
{
    "ledger_id": "sandbox"
}
```
7. List the users selecting the `ListUsers` methods, it should display the users as:
```json
{
    "users": [
        {
            "id": "alice",
            "primary_party": "Alice::1220afd6208c410588f7d0a48531b9b2c2d1cba9e78113168560c4db116abebf1205",
            "is_deactivated": false,
            "metadata": {
                "annotations": [],
                "resource_version": "0"
            },
            "identity_provider_id": ""
        },
        ...
    ],
    ...
}
```
8. Create a `JWT token` using [jwt io](https://jwt.io/) setting the `payload` providing the previously queried `ledgerId` and the party id of the user you want to authenticate.
```json
{
  "https://daml.com/ledger-api": {
     "ledgerId": "sandbox",
     "applicationId": "any",
     "actAs": ["Alice::1220afd6208c410588f7d0a48531b9b2c2d1cba9e78113168560c4db116abebf1205"]
  }
}
```
9. Create a new collection for the http methods to test the JSON api, and set the authentication as `Bearer Token` and provide the previously created token.
10. Create a `POST` method for url `http://localhost:7575/v1/create`, set the body as `raw` and content-type `JSON` and set the body as:
  - use the party id from previous `ListUsers` method to set the parties on the request
```json
{
    "templateId": "Main:Asset",
    "payload": {
        "issuer": "Alice::1220afd6208c410588f7d0a48531b9b2c2d1cba9e78113168560c4db116abebf1205",
        "owner": "Alice::1220afd6208c410588f7d0a48531b9b2c2d1cba9e78113168560c4db116abebf1205",
        "name": "Car"
    }
    
}
```
10. The reponse body should be something like:
```json
{
    "result": {
        "agreementText": "",
        "completionOffset": "00000000000000000a",
        "contractId": "00201c2e2fbcbacd2621fbbba4b4d5d5c374f7abe9ba374d66c3c34e08a2081389ca0112205f54a6eacf1d54ec8b616b5573ddeaa5e043b02c61dcb7193626fd2daca9e214",
        "observers": [],
        "payload": {
            "issuer": "Alice::1220afd6208c410588f7d0a48531b9b2c2d1cba9e78113168560c4db116abebf1205",
            "owner": "Alice::1220afd6208c410588f7d0a48531b9b2c2d1cba9e78113168560c4db116abebf1205",
            "name": "Car"
        },
        "signatories": [
            "Alice::1220afd6208c410588f7d0a48531b9b2c2d1cba9e78113168560c4db116abebf1205"
        ],
        "templateId": "a028458ec78ad5698675b4899131b8e90d06d8b4f1d02f3741301f9fc257c878:Main:Asset"
    },
    "status": 200
}
```
11. Confirm creating a new `gPCR`request using the method `GetEventsByContractId` setting a message with the returned `contractId` and user 
```json
{
    "contract_id": "00201c2e2fbcbacd2621fbbba4b4d5d5c374f7abe9ba374d66c3c34e08a2081389ca0112205f54a6eacf1d54ec8b616b5573ddeaa5e043b02c61dcb7193626fd2daca9e214",
    "requesting_parties": ["Alice::1220afd6208c410588f7d0a48531b9b2c2d1cba9e78113168560c4db116abebf1205"]
}
```
It should return something like:
```json
{
    "create_event": {
        "witness_parties": [
            "Alice::1220afd6208c410588f7d0a48531b9b2c2d1cba9e78113168560c4db116abebf1205"
        ],
        "signatories": [
            "Alice::1220afd6208c410588f7d0a48531b9b2c2d1cba9e78113168560c4db116abebf1205"
        ],
        "observers": [],
        "interface_views": [],
        "event_id": "#12209e94e4462575def4ae8fcb971559f7f18c6cc55f740269145094b1f4d6941371:0",
        "contract_id": "00201c2e2fbcbacd2621fbbba4b4d5d5c374f7abe9ba374d66c3c34e08a2081389ca0112205f54a6eacf1d54ec8b616b5573ddeaa5e043b02c61dcb7193626fd2daca9e214",
        "template_id": {
            "package_id": "a028458ec78ad5698675b4899131b8e90d06d8b4f1d02f3741301f9fc257c878",
            "module_name": "Main",
            "entity_name": "Asset"
        },
        ...
    },
    ...
}
```

- For more info refer to the [Ledger Api Reference](https://docs.daml.com/app-dev/grpc/proto-docs.html#)




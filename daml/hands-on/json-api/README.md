
Testing the API with postman
1. Run the sandbox
```sh
cd src/daml-json-api
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




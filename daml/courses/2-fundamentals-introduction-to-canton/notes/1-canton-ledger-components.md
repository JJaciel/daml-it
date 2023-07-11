# Canton ledger model components
The Canton ecosystem is built on the Canton Network lying at the level of the persistence layer

## Components
1. Canton Network -> Persistence Layer
The underlying infrastructure runs Daml Smart Contracts stored in the Canton Ledger

2. Nodes -> Participants Nodes
Where the DAR files are uploaded.
DAR files are Daml archive files that are created when the Daml templates are compiled

At this level is where Parties are hosted, identified, and authenticated

The participant node exposes the Daml ledger API, so the client application can interact with

3. Client -> Access to the Ledger API as needed

## Users is the system
How user using Daml applications interact with the ledger

### The relationship betweeen `Parties` and `Users`
- In a template, a Party has certain authority to Create contracts with other parties and exercise choices on those contracts. 
- Parties represent legal entities, such as individuals and institutions
`Party` = Authority to act and see
- The client application maps Users to Parties in two capacities
    - Act As => enables users to do what a party has been athorized to do. For example: Create contracts and exercise choices
    - Read As => enables users to have visibility into the contracts as observers.
    
### Authorization and privacy
Are enabled by the `Act as` and `Read as`
- Authorization is about who can do what enabled by the act as clause
- Privacy is about who can see what enabled by the read as clause

A user can act as and read as more than one party, and one party can be maped to more than one user

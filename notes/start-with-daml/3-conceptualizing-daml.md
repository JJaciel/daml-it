# Conceptualizing Daml
_source_ [youtube series](https://www.youtube.com/playlist?list=PLjLGVUzUMRxUuNGL4-Vyec4ppuV-hlC7c)

## What is the Daml ledger model
The Daml model is a conceptual model that makes it that the developer, the operator, and the users of Daml applications reason about the application and feel like if they're using a Virtual Shared Ledger, though the application may be a distributed runtime. 
- Daml ledger -> Virtual Shared Ledger -> acts as a single ledger -> a ledger can be a database as postgres
- Distributed Ledger technology -> could be blockchain
- Daml ledger can run over different db technologies using the Daml drivers:
    - corda
    - hyperledger fabric
    - vmware blockchain
    - amazon quantum ledger database
    - hyperledger besu
    - postgreSQL

- Daml ledger attributes:
    - consistency
    - privacy
    - authorization
    - data archival (since daml ledger is an inmutable blockchain)
- [Docs](https://docs.daml.com/)
- [Questions](https://discuss.daml.com/)

## State Management
Daml creates an event sourced integration accross organizational boundaries (parties)
### Event sourcing
The architectural pattern (Software design pattern) of storing all of the events that led up to a certain state. Captures all of the events that happended in an event log
- Event sourcing is useful for:
    - Full audit log: Point-in-time queries, how we got the current state.
    - Rehydrate data from event log: high availability, Disaster recovery, Synchronization.
    - Clean separation between write and read: High performance.
- Three time horizons
    - Past - all the events that have happended => Daml Events
    - Present - active state, it is the application of all the past events => Daml Active Contract Set (ACS)
    - Future - the commands request to make a change => Daml Commands (submitted trough the api)
- Daml Events: two types:
    - Contract Created => addition to the Active Contract Set
    - Contract Archived => removal from the Active Contract Set
- Daml Commands: Two types:
    - Create Contract:
    - Exercise Choice (On a contract that already exists): Choices can Archive already existing contracts or Create new contracts.

## Daml performance scaling
### Data flow
Follows two Architectural Design Patters, **Command Query Responsability Segregation (CQRS)** and **Event-Sourced Architecture**
1. Writing to the ledger (Command) is a first data flow, a sequence of transactions.
2. The ledger is a long log of transactions and is the source of true for all data.
3. Reading from the ledger (Query) is a second, segregated data flow.
4. in Daml, all interactions between the write and read path is through the inmutable ledger, there are no _out-of-bounds_ workflows
### Horizontal Scaling
Scaling - How the system behave when we add more resources.
horizontal scale - A means to increase throughput by adding resources, which process in parallel.
Which parts are trivial to scale horizontally?:
1. Serving the API
2. Read path, by duplicating the read stream and creating multiple copies (caches). The ledger is an inmutable stream of events, so no synchronization between these is necessary
3. Write path - not so trivial because we need to ensure we're not writing conflicting transactions to the ledger.
**Write Path** (a.k.a. Concensus)
Has to validate three things about the transaction being written to the ledger:
1. Conform to the rules of Daml <= Highest need for computing resources (CPU and memory)
2. Is authorized bu someone who is allowed to write it
3. Doesn't conflict with any previous transaction.
    Implements a *compare-and-swap* logic
    - "If contracts A, B, C are on the ledger, archive them and write contracts D, E, F"
    - "Id A, B, C are not in the ledger or already archived, reject the transaction"
### Scaling writes to the ledger
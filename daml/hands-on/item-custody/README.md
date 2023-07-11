created with
```sh
daml new daml-with-skeleton-template --template empty-skeleton
cd daml-with-skeleton-template
daml studio
```

video exercise
```haskell
module Deprecated where

import Daml.Script

type ItemCustodyId = ContractId ItemCustody

-- tracks chain of custody of my property
template ItemCustody
    with
        owner : Party
        custodian : Party
        itemName : Text
    where
        signatory owner

        -- This code is deprecated in current Daml version, instead should use Choice and Observer
        controller owner can
            ReleaseItemTo : ItemCustodyId
                with 
                    friend : Party
                do 
                    create this with
                        custodian = friend

        controller custodian can
            ReturnItemTo : ItemCustodyId
                with 
                    rightfulOwner : Party
                do 
                    create this with
                        owner = rightfulOwner

-- test
setup : Script ItemCustodyId
setup = script do
    jerry <- allocateParty "Jerry"
    elaine <- allocateParty "Elaine"

    brandNewCamera <- submit jerry do
        createCmd ItemCustody with
            owner = jerry
            custodian = jerry
            itemName = "Really expensive cammera"

    elaineHasCamera <- submit jerry do
        exerciseCmd brandNewCamera ReleaseItemTo with friend = elaine

    submit elaine do
        exerciseCmd elaineHasCamera ReturnItemTo with rightfulOwner = jerry
```
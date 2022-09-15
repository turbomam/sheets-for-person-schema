# PersonStatus

None

URI: PersonStatus

## Permissible Values

| Value | Meaning | Description | Info |
| --- | --- | --- | --- |
| ALIVE | PATO:0001421 | the person is living | |
| DEAD | PATO:0001422 | the person is deceased | |
| UNKNOWN | None | the vital status is not known | |



## Identifier and Mapping Information







### Schema Source


* from schema: https://w3id.org/turbomam/sheets-for-person-schema




## Schema

<details>
```yaml
name: PersonStatus
from_schema: https://w3id.org/turbomam/sheets-for-person-schema
rank: 1000
permissible_values:
  ALIVE:
    text: ALIVE
    description: the person is living
    meaning: PATO:0001421
  DEAD:
    text: DEAD
    description: the person is deceased
    meaning: PATO:0001422
  UNKNOWN:
    text: UNKNOWN
    description: the vital status is not known
    todos:
    - map this to an ontology

```
</details>

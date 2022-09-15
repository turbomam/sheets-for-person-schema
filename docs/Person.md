# Class: Person
_Represents a Person:_





URI: [sheets_for_person_schema:Person](https://w3id.org/turbomam/sheets-for-person-schema/Person)




```mermaid
 classDiagram
      NamedThing <|-- Person
      
      Person : age_in_years
      Person : birth_date
      Person : description
      Person : id
      Person : name
      Person : primary_email
      Person : vital_status
      

```





## Inheritance
* [NamedThing](NamedThing.md)
    * **Person**



## Slots

| Name | Cardinality and Range  | Description  |
| ---  | ---  | --- |
| [primary_email](primary_email.md) | 0..1 <br/> [xsd:string](xsd:string)  | The main email address of a person  |
| [birth_date](birth_date.md) | 0..1 <br/> [xsd:date](xsd:date)  | Date on which a person is born  |
| [age_in_years](age_in_years.md) | 0..1 <br/> [xsd:integer](xsd:integer)  | Number of years since birth  |
| [vital_status](vital_status.md) | 0..1 <br/> [PersonStatus](PersonStatus.md)  | living or dead status  |
| [id](id.md) | 1..1 <br/> [xsd:anyURI](xsd:anyURI)  | A unique identifier for a thing  |
| [name](name.md) | 0..1 <br/> [xsd:string](xsd:string)  | A human-readable name for a thing  |
| [description](description.md) | 0..1 <br/> [xsd:string](xsd:string)  | A human-readable description for a thing  |


## Usages


| used by | used in | type | used |
| ---  | --- | --- | --- |
| [PersonCollection](PersonCollection.md) | [entries](entries.md) | range | Person |



## Identifier and Mapping Information







### Schema Source


* from schema: https://w3id.org/turbomam/sheets-for-person-schema







## Mappings

| Mapping Type | Mapped Value |
| ---  | ---  |
| self | ['sheets_for_person_schema:Person'] |
| native | ['sheets_for_person_schema:Person'] |


## LinkML Specification

<!-- TODO: investigate https://stackoverflow.com/questions/37606292/how-to-create-tabbed-code-blocks-in-mkdocs-or-sphinx -->

### Direct

<details>
```yaml
name: Person
description: 'Represents a Person:'
from_schema: https://w3id.org/turbomam/sheets-for-person-schema
rank: 1000
is_a: NamedThing
slots:
- primary_email
- birth_date
- age_in_years
- vital_status
slot_usage:
  primary_email:
    name: primary_email
    domain_of:
    - Person
    - Person
    pattern: ^\S+@[\S+\.]+\S+

```
</details>

### Induced

<details>
```yaml
name: Person
description: 'Represents a Person:'
from_schema: https://w3id.org/turbomam/sheets-for-person-schema
rank: 1000
is_a: NamedThing
slot_usage:
  primary_email:
    name: primary_email
    domain_of:
    - Person
    - Person
    pattern: ^\S+@[\S+\.]+\S+
attributes:
  primary_email:
    name: primary_email
    description: The main email address of a person
    from_schema: https://w3id.org/turbomam/sheets-for-person-schema
    rank: 1000
    slot_uri: schema:email
    alias: primary_email
    owner: Person
    domain_of:
    - Person
    - Person
    range: string
    pattern: ^\S+@[\S+\.]+\S+
  birth_date:
    name: birth_date
    description: Date on which a person is born
    from_schema: https://w3id.org/turbomam/sheets-for-person-schema
    rank: 1000
    slot_uri: schema:birthDate
    alias: birth_date
    owner: Person
    domain_of:
    - Person
    range: date
  age_in_years:
    name: age_in_years
    description: Number of years since birth
    from_schema: https://w3id.org/turbomam/sheets-for-person-schema
    rank: 1000
    alias: age_in_years
    owner: Person
    domain_of:
    - Person
    range: integer
  vital_status:
    name: vital_status
    description: living or dead status
    from_schema: https://w3id.org/turbomam/sheets-for-person-schema
    rank: 1000
    alias: vital_status
    owner: Person
    domain_of:
    - Person
    range: PersonStatus
  id:
    name: id
    description: A unique identifier for a thing
    from_schema: https://w3id.org/turbomam/sheets-for-person-schema
    rank: 1000
    slot_uri: schema:identifier
    identifier: true
    alias: id
    owner: Person
    domain_of:
    - NamedThing
    range: uriorcurie
  name:
    name: name
    description: A human-readable name for a thing
    from_schema: https://w3id.org/turbomam/sheets-for-person-schema
    rank: 1000
    slot_uri: schema:name
    alias: name
    owner: Person
    domain_of:
    - NamedThing
    range: string
  description:
    name: description
    description: A human-readable description for a thing
    from_schema: https://w3id.org/turbomam/sheets-for-person-schema
    rank: 1000
    slot_uri: schema:description
    alias: description
    owner: Person
    domain_of:
    - NamedThing
    range: string

```
</details>
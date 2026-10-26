# Where Everyone Was

*People move. Sometimes twice in a month. How do you remember where everyone was, and when?*

[Data Modeling · Easy · on DataDriven](https://datadriven.io/problems/where_everyone_was)

## How it went

| | |
|---|---|
| Solved | 2026-10-26 |
| Accepted | on the 6th submission |
| Hints | none |
| Concepts | Attributes, Entities, Foreign Keys, Junction Tables, Many-to-Many, One-to-Many, Primary Keys, SCD Strategy, SCD Type 2, Surrogate Keys |

## The design

```mermaid
erDiagram
    customer {
        BIGINT customer_sk PK
        BIGINT customer_id
        TEXT name
        INT age
        TEXT customeraddress
        TIMESTAMP valid_from_timestamp
        TIMESTAMP valid_to_timestamp
        BOOLEAN is_valid
    }
```

The accepted design is in [`schema.sql`](./schema.sql) as DDL and in [`schema.json`](./schema.json) as JSON.

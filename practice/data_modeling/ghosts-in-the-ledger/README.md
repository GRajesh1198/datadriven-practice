# Ghosts in the Ledger

*Invoices go out, partial payments trickle in, and some customers are three months overdue.*

[Data Modeling · Easy · on DataDriven](https://datadriven.io/problems/ghosts_in_the_ledger)

## How it went

| | |
|---|---|
| Solved | 2026-07-06 |
| Accepted | on the 3rd submission |
| Time | 6 min |
| Hints | none |
| Concepts | Constraints, Data Types, Denormalization, Dimension Tables, Entities, Fact Tables, 1NF, Foreign Keys, Grain Definition, Indexing, Junction Tables, Many-to-Many, Metric Additivity, One-to-Many, Pre-Aggregation, Primary Keys, 2NF, Star Schema, Surrogate Keys, 3NF |

## The design

The accepted design, as it was graded:

```text
TABLE invoices
  [PK] invoice_id BIGINT
  [FK] customer_id INT
  issue_date DATE
  due_date DATE
  status TEXT
  total_amount FLOAT
  billing_period_start
  billing_period_end
  subtotal
  tax_amount

TABLE invoice_line_items
  [PK] line_id BIGINT
  [FK] invoice_id BIGINT
  [FK] product_id INT
  quantity INT
  unit_price FLOAT
  line_total FLOAT

TABLE customers
  billing_address
  [PK] customer_id INT
  legal_name TEXT
  billing_email TEXT
  paymentZ_terms_days FLOAT
  created_at
  
  

TABLE products
  [PK] product_id
  sku
  product_name
  list_price
  is_subscription

TABLE payments
  [PK] payment_id
  [FK] customer_id
  [FK] invoice_id
  amount
  payment_date
  method

Relationships:
products.product_id -> invoice_line_items.product_id (many to one)
invoices.customer_id -> customers.customer_id
invoice_line_items.invoice_id -> invoices.invoice_id (one to many)
```

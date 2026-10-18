# Tokopee — E-Commerce Relational Database

A **Database Technology group project** at BINUS University (2025–2026). We analyzed a flat online-retail transaction dataset and designed a normalized relational model for customer orders, returns, and sales reporting.

> **Repository status:** Documentation and the original ERD have been added from the project report. The **original SQL and Python scripts are not yet included** in this starter. Add and test the original source files before calling this a runnable project. This is an academic database demonstration, not a production platform.

## Overview

The source `online_retail_data.csv` contains invoices, stock codes, descriptions, quantities, dates, prices, customer IDs, and countries. Its flat structure repeats product and transaction information, leading to update, insertion, and deletion anomalies.

The project redesigned the data into **eight related tables**, documented as a 3NF model, with explicit keys and referential integrity constraints.

| Table | Purpose |
| --- | --- |
| `Country`, `Province`, `City` | Geographic reference hierarchy |
| `Customer` | Customer profiles |
| `CustomerAddress` | Customers' addresses and city links |
| `Product` | Product codes, names, current prices, and stock |
| `Invoice` | Order/return headers and statuses |
| `InvoiceDetail` | Invoice line items and historical unit prices |

## Features documented in the original report

**Data preprocessing (Python / Pandas)**
- Remove records missing essential customer or product information.
- Standardize customer IDs, invoice dates, and text fields.
- Merge repeated `(InvoiceID, StockCode)` entries by summing quantities.
- Remove records with zero quantities.
- Generate sample address/region values with Faker for the teaching dataset.

**Database design and SQL**
- Normalize the original flat-file structure into separate entities, following **3NF**.
- Create tables with primary keys, foreign keys, `NOT NULL`, `DEFAULT`, and `CHECK` constraints.
- Use `(InvoiceID, StockCode)` as the composite primary key for invoice line items.
- Store historical `UnitPrice` in invoice details independently of a product's current price.

**Queries and automation**
- Add new products; record purchases and customer returns.
- Report the top 10 customers by completed-order spend and the highest-revenue month in 2011.
- Update current product stock through an `AFTER INSERT` trigger on invoice details.
- Retrieve a customer's invoice history with a stored procedure.

See [database design and review notes](docs/database-design.md) for more detail.

## Repository structure

```text
.
├── README.md
├── .gitignore
├── data/
│   └── README.md                 # Full 90 MB source data is not included
├── docs/
│   ├── erd.png                   # ERD extracted from the original report
│   ├── erd.md                    # Text description of relationships
│   └── database-design.md       # Design and engineering notes
├── python/
│   └── README.md                 # Add original preprocessing scripts here
└── sql/
    └── README.md                 # Add original SQL files here
```

## How to reproduce (after adding original code)

1. Obtain the source dataset from its authorized source; **do not assume the 90 MB CSV may be redistributed**.
2. Run the original Python preprocessing script to generate normalized import files.
3. Create the database using the original SQL schema script.
4. Import the cleaned data in foreign-key dependency order.
5. Execute the transaction examples, analytics queries, trigger, and stored procedure.

The exact commands, supported MySQL/MariaDB version, and dependencies still need to be verified from the original scripts. The screenshots in the report use MySQL-style SQL syntax.

## Production considerations

This was coursework. Before using these ideas in a real application, consider stricter transaction atomicity, historical order retention (the report describes widespread `ON DELETE CASCADE`), safe stock updates under concurrency, and separation of purchase versus return accounting.

## Acknowledgments

This is a **group project**, not a solo project. Include attribution to the other group members with their permission, and clarify which parts you personally implemented when describing it on your CV. The submitted class report has intentionally not been included in this public starter because it contains names and course administration details.

## Data policy

The original 90 MB data file is intentionally excluded. Publish only small, properly licensed, non-sensitive examples if you choose to include sample data. Never upload credentials, private customer details, or unlicensed source datasets.

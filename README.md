# Tokopee — Relational E-Commerce Database

A **university group project** for BINUS University's Database Technology course (2025–2026). The project explores how a flat online-retail transaction dataset can be transformed into a normalized relational database and used for order processing and sales reporting.

> **Repository status:** This is a documentation starter prepared from the original project report. **The original Python and SQL source files are not included yet.** Add and verify those files before presenting this repository as a complete runnable implementation. This is an academic demonstration, not a production commerce system.

## Project highlights

- Identified redundancy and insert, update, and delete anomalies in flat transaction data.
- Designed a relational schema normalized through **third normal form (3NF)**.
- Modeled customers, customer addresses, geographic data, products, invoices, and invoice line items.
- Used **Python and Pandas** for data cleaning and deduplication; the report describes using **Faker** to generate synthetic address data.
- Implemented SQL DDL/DML and analytical queries, including top customers by spending and monthly sales revenue.
- Explored a stock-update trigger and a stored procedure to retrieve a customer's invoices.

## Data model

The design describes eight entities:

| Entity | Purpose |
| --- | --- |
| `Country` | Country reference data |
| `Province` | Provinces belonging to countries |
| `City` | Cities belonging to provinces |
| `Customer` | Customer identity |
| `CustomerAddress` | Customer-address and city associations |
| `Product` | Product metadata, current price, and stock |
| `Invoice` | Order or return header, customer, address, date, status, totals |
| `InvoiceDetail` | Per-product line item; stores historical unit price |

See [entity relationships](docs/erd.md) and [design notes](docs/database-design.md).

## Processing workflow

1. **Input:** a retail transactions CSV with invoice, product, quantity, price, date, customer, and country fields.
2. **Cleaning:** standardize identifiers and dates, remove missing essential values and zero-quantity records, deduplicate invoice/product pairs, and produce normalized import data.
3. **Schema:** create entity tables and define keys and integrity constraints.
4. **Operations:** insert products, represent purchases and returns, and calculate invoice amounts.
5. **Reporting:** analyze customer spend and monthly sales.
6. **Automation:** demonstrate stock-update and invoice-history database routines.

The original source files are needed to reproduce these steps. Do not use the descriptions alone as proof that this repository is runnable.

## Repository structure

```text
tokopee-relational-database/
├── README.md
├── .gitignore
├── docs/
│   ├── erd.md
│   └── database-design.md
├── python/
│   └── README.md          # Replace/add the original cleaning script
└── sql/
    └── README.md          # Add original schema, queries, trigger, procedure
```

## Technology

**SQL**, **relational database design / 3NF**, **Python**, **Pandas**, and **Faker** (as described in the original coursework report). The SQL database engine and supported version should be documented after adding and testing the original SQL scripts.

## Engineering considerations

This project was created for learning. A production implementation would need stronger control over transaction atomicity, historical order retention, secure data handling, and stock consistency. In particular, applying `ON DELETE CASCADE` indiscriminately to order-related tables can erase historical transaction records.

## Attribution and sharing

This was a **group project**, not an individual-only project. Credit the other contributors with their permission and describe your own contributions accurately. The original class report contains other people's names and coursework details; it is deliberately excluded from this public-ready template. Only publish project assets you have permission to share, and ensure any uploaded dataset is properly licensed and de-identified.

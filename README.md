# Property Tax Analytics

## Overview

This project implements a production-style analytics pipeline for a Property Tax system.

The system ingests data from normalized transactional tables in PostgreSQL, transforms it into an analytical STAR schema, and loads it into reporting tables using an Apache Airflow ETL pipeline.

The solution demonstrates:

* Dimensional data modeling
* SCD Type-2 implementation
* Incremental fact loading
* Airflow orchestration
* Production-ready design patterns

---

## Objectives

Build an analytics platform that supports:

* Time-based analysis
* Zone / ward / usage-based slicing
* Demand vs collection reporting
* Historical tracking of property attributes
* Efficient reporting performance

---

## Source System (Transactional Schema)

The source system is a normalized OLTP schema (read-only).

### property

Stores master data for properties.

| Column         | Description                      |
| -------------- | -------------------------------- |
| property_id    | Unique property identifier       |
| zone           | Geographic zone                  |
| ward           | Administrative ward              |
| usage_type     | Residential / Commercial         |
| ownership_type | Private / Government / Corporate |
| status         | ACTIVE / INACTIVE                |
| created_at     | Record creation timestamp        |
| updated_at     | Last update timestamp            |

---

### demand

Stores tax demands raised for properties.

| Column        | Description                    |
| ------------- | ------------------------------ |
| demand_id     | Unique demand identifier       |
| property_id   | Reference to property          |
| tax_period    | Financial year (e.g., 2023-24) |
| demand_amount | Amount demanded                |
| status        | ACTIVE / CANCELLED             |
| created_at    | Record creation timestamp      |
| updated_at    | Last update timestamp          |

---

### payment

Stores payments made against demands.

| Column         | Description               |
| -------------- | ------------------------- |
| payment_id     | Unique payment identifier |
| demand_id      | Reference to demand       |
| payment_amount | Amount paid               |
| payment_date   | Payment date              |
| status         | SUCCESS / FAILED          |
| created_at     | Record creation timestamp |

---

## Analytical Data Model (STAR Schema)

A STAR schema is designed to optimize analytical queries.

### Why STAR Schema?

* Fast aggregations
* Simplified joins
* BI tool friendly
* Scalable for large datasets

---

## Dimension Tables

### dim_property (SCD Type-2)

Tracks historical changes in property attributes.

| Column         | Description             |
| -------------- | ----------------------- |
| property_key   | Surrogate primary key   |
| property_id    | Business key            |
| zone           | Geographic zone         |
| ward           | Administrative ward     |
| usage_type     | Usage category          |
| ownership_type | Ownership category      |
| status         | Active/Inactive         |
| effective_from | Start timestamp         |
| effective_to   | End timestamp           |
| is_current     | Indicates active record |

 Enables historical analysis of property changes.

---

### dim_time

Represents financial tax periods.

| Column     | Description                    |
| ---------- | ------------------------------ |
| time_key   | Surrogate key                  |
| tax_period | Financial year (e.g., 2023-24) |
| year_start | Start year                     |
| year_end   | End year                       |

---

## Fact Table

### fact_property_tax

Stores measurable metrics.

| Column             | Description                        |
| ------------------ | ---------------------------------- |
| fact_key           | Surrogate key                      |
| property_key       | FK to dim_property                 |
| time_key           | FK to dim_time                     |
| demand_id          | Business key for incremental loads |
| demand_amount      | Amount demanded                    |
| collected_amount   | Successful payments                |
| outstanding_amount | Remaining balance                  |

---

## Supported Analytical Use Cases

The model enables:

* Revenue collection trends over time
* Outstanding tax analysis
* Zone/ward performance comparison
* Usage-type analysis (Residential vs Commercial)
* Historical property attribute tracking
* Payment efficiency reporting

---

## ETL Pipeline — Airflow

### DAG: `property_tax_pipeline_advanced`

Implements an end-to-end ETL workflow.

---

## DAG Design

###  Task Flow

```
create_schema
      ↓
load_dim_property_scd2
      ↓
load_dim_time
      ↓
load_fact_incremental
```

---

### Task Responsibilities

#### create_schema

Creates analytics schema and tables if not present.

* Makes pipeline self-contained
* Ensures environment readiness
* Safe for repeated execution

---

#### load_dim_property_scd2

Loads property dimension using Slowly Changing Dimension Type-2 logic.

Steps:

* Detect changes in attributes
* Close previous record versions
* Insert new current records
* Preserve history

---

#### load_dim_time

Populates time dimension from tax periods in demand data.

* Inserts only new periods
* Avoids duplicates
* Enables time-based slicing

---

#### load_fact_incremental

Loads fact table incrementally.

Responsibilities:

* Join transactional tables with dimensions
* Aggregate successful payments
* Calculate outstanding balances
* Insert only new demand records

---

## Retry Strategy

Configured at DAG level:

* Automatic retries on failures
* Retry delay between attempts
* Improves reliability in case of transient issues

---

## Scheduling

* Manual trigger (for demonstration)
* Can be scheduled for periodic batch loads
* Catchup disabled to prevent historical backfills

---

## Idempotency & Safety

Pipeline supports safe reruns through:

* Incremental loading logic
* SCD Type-2 design
* Conflict handling
* Schema existence checks

---

## Project Structure

```
property-tax-analytics/
│
├── dags/
│   └── property_tax_pipeline.py
│
├── sql/
│   ├── ddl_analytics.sql
│   ├── load_dim_property_scd2.sql
│   ├── load_dim_time.sql
│   └── load_fact_incremental.sql
│
├── sample_data/
│   └── mock_data.sql
│
├── schema/
│   └── analytics_schema.sql
│
├── requirements.txt
└── README.md
```

---

## How to Run

###  Load sample data into PostgreSQL

```
psql -U postgres -d <database> -f sample_data/mock_data.sql
```

---

### Place DAG in Airflow dags folder

```
cp dags/property_tax_pipeline.py ~/airflow/dags/
```

---

### Start Airflow

```
airflow webserver
airflow scheduler
```

---

### Trigger DAG

From Airflow UI:

 Run **property_tax_pipeline_advanced**

---

Author

Tanay Shresth

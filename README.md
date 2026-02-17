# Property Tax Analytics — Airflow ETL

## Overview

This project builds an analytical data model for a Property Tax system
using PostgreSQL and Apache Airflow.

## Source Tables

- property
- demand
- payment

## Analytical Schema

Star schema with:

### Dimensions

- dim_property
- dim_time
- dim_status

### Fact

- fact_property_tax

Supports:

- Demand vs collection analysis
- Time-based reporting
- Zone / ward slicing

## Pipeline Design

Airflow DAG performs:

1. Create analytics schema
2. Load dimensions
3. Load fact table

## How to Run

1. Start PostgreSQL
2. Load sample data
3. Place DAG in Airflow dags folder
4. Trigger DAG from Airflow UI

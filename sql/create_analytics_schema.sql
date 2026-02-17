CREATE SCHEMA IF NOT EXISTS analytics;

-- DIM_PROPERTY (SCD TYPE 2)
CREATE TABLE IF NOT EXISTS analytics.dim_property (
    property_key SERIAL PRIMARY KEY,
    property_id INT,
    zone VARCHAR,
    ward VARCHAR,
    usage_type VARCHAR,
    ownership_type VARCHAR,
    status VARCHAR,
    effective_from TIMESTAMP,
    effective_to TIMESTAMP,
    is_current BOOLEAN
);

-- DIM_TIME
CREATE TABLE IF NOT EXISTS analytics.dim_time (
    time_key SERIAL PRIMARY KEY,
    tax_period VARCHAR UNIQUE,
    year_start INT,
    year_end INT
);

-- FACT TABLE
CREATE TABLE IF NOT EXISTS analytics.fact_property_tax (
    fact_key SERIAL PRIMARY KEY,
    property_key INT,
    time_key INT,
    demand_id INT,
    demand_amount NUMERIC,
    collected_amount NUMERIC,
    outstanding_amount NUMERIC,
    record_created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (demand_id)
);

CREATE SCHEMA IF NOT EXISTS analytics;

-- ===============================
-- DIMENSION: PROPERTY (SCD-2)
-- ===============================

CREATE TABLE IF NOT EXISTS analytics.dim_property (
    property_key SERIAL PRIMARY KEY,
    property_id VARCHAR NOT NULL,

    zone VARCHAR,
    ward VARCHAR,
    usage_type VARCHAR,
    ownership_type VARCHAR,
    status VARCHAR,

    effective_from TIMESTAMP NOT NULL,
    effective_to TIMESTAMP,
    is_current BOOLEAN NOT NULL DEFAULT TRUE
);

-- ===============================
-- DIMENSION: TIME
-- ===============================

CREATE TABLE IF NOT EXISTS analytics.dim_time (
    time_key SERIAL PRIMARY KEY,
    tax_period VARCHAR UNIQUE,
    year_start INT,
    year_end INT
);

-- ===============================
-- FACT TABLE
-- ===============================

CREATE TABLE IF NOT EXISTS analytics.fact_property_tax (
    fact_key SERIAL PRIMARY KEY,
    property_key INT REFERENCES analytics.dim_property(property_key),
    time_key INT REFERENCES analytics.dim_time(time_key),

    demand_id VARCHAR UNIQUE,
    demand_amount NUMERIC,
    collected_amount NUMERIC,
    outstanding_amount NUMERIC
);

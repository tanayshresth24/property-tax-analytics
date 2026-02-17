CREATE SCHEMA IF NOT EXISTS analytics;

-- PROPERTY DIMENSION
CREATE TABLE IF NOT EXISTS analytics.dim_property (
    property_key SERIAL PRIMARY KEY,
    property_id VARCHAR UNIQUE,
    zone VARCHAR,
    ward VARCHAR,
    usage_type VARCHAR,
    ownership_type VARCHAR,
    status VARCHAR
);

-- TIME DIMENSION
CREATE TABLE IF NOT EXISTS analytics.dim_time (
    time_key SERIAL PRIMARY KEY,
    tax_period VARCHAR UNIQUE
);

-- STATUS DIMENSION
CREATE TABLE IF NOT EXISTS analytics.dim_status (
    status_key SERIAL PRIMARY KEY,
    status VARCHAR UNIQUE
);

-- FACT TABLE
CREATE TABLE IF NOT EXISTS analytics.fact_property_tax (
    fact_key SERIAL PRIMARY KEY,
    property_key INT REFERENCES analytics.dim_property(property_key),
    time_key INT REFERENCES analytics.dim_time(time_key),
    status_key INT REFERENCES analytics.dim_status(status_key),
    demand_amount NUMERIC,
    collected_amount NUMERIC,
    outstanding_amount NUMERIC
);

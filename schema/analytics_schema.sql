CREATE SCHEMA IF NOT EXISTS analytics;

-- ================= DIMENSION: PROPERTY =================
CREATE TABLE IF NOT EXISTS analytics.dim_property (
    property_key SERIAL PRIMARY KEY,
    property_id VARCHAR UNIQUE,
    zone VARCHAR,
    ward VARCHAR,
    usage_type VARCHAR,
    ownership_type VARCHAR,
    status VARCHAR
);

-- ================= DIMENSION: TIME =================
CREATE TABLE IF NOT EXISTS analytics.dim_time (
    time_key SERIAL PRIMARY KEY,
    tax_period VARCHAR UNIQUE,
    year_start INT,
    year_end INT
);

-- ================= FACT TABLE =================
CREATE TABLE IF NOT EXISTS analytics.fact_property_tax (
    fact_key SERIAL PRIMARY KEY,
    property_key INT REFERENCES analytics.dim_property(property_key),
    time_key INT REFERENCES analytics.dim_time(time_key),
    demand_amount NUMERIC,
    collected_amount NUMERIC,
    outstanding_amount NUMERIC,
    record_created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(property_key, time_key)
);

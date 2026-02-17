INSERT INTO analytics.dim_time (
    tax_period,
    year_start,
    year_end
)
SELECT DISTINCT
    d.tax_period,
    SPLIT_PART(d.tax_period, '-', 1)::INT,
    SPLIT_PART(d.tax_period, '-', 2)::INT
FROM public.demand d
ON CONFLICT (tax_period) DO NOTHING;

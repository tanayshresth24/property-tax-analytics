INSERT INTO analytics.dim_time (tax_period)

SELECT DISTINCT tax_period
FROM public.demand
ON CONFLICT (tax_period) DO NOTHING;

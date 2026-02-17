INSERT INTO analytics.dim_status (status)

SELECT DISTINCT status
FROM public.demand
ON CONFLICT (status) DO NOTHING;

INSERT INTO analytics.fact_property_tax (
    property_key,
    time_key,
    demand_id,
    demand_amount,
    collected_amount,
    outstanding_amount
)
SELECT
    dp.property_key,
    dt.time_key,
    d.demand_id,
    d.demand_amount,
    COALESCE(SUM(p.payment_amount), 0),
    d.demand_amount - COALESCE(SUM(p.payment_amount), 0)

FROM public.demand d

JOIN analytics.dim_property dp
  ON d.property_id = dp.property_id
 AND dp.is_current = TRUE

JOIN analytics.dim_time dt
  ON d.tax_period = dt.tax_period

LEFT JOIN public.payment p
  ON d.demand_id = p.demand_id
 AND p.status = 'SUCCESS'

WHERE NOT EXISTS (
    SELECT 1
    FROM analytics.fact_property_tax f
    WHERE f.demand_id = d.demand_id
)

GROUP BY
    dp.property_key,
    dt.time_key,
    d.demand_id,
    d.demand_amount;

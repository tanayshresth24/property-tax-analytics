INSERT INTO analytics.fact_property_tax
(property_key, time_key, status_key,
 demand_amount, collected_amount, outstanding_amount)

SELECT
    dp.property_key,
    dt.time_key,
    ds.status_key,
    d.demand_amount,
    COALESCE(SUM(p.payment_amount), 0) AS collected,
    d.demand_amount - COALESCE(SUM(p.payment_amount), 0) AS outstanding

FROM public.demand d

JOIN analytics.dim_property dp
    ON d.property_id = dp.property_id

JOIN analytics.dim_time dt
    ON d.tax_period = dt.tax_period

JOIN analytics.dim_status ds
    ON d.status = ds.status

LEFT JOIN public.payment p
    ON d.demand_id = p.demand_id
   AND p.status = 'SUCCESS'

GROUP BY
    dp.property_key,
    dt.time_key,
    ds.status_key,
    d.demand_amount;

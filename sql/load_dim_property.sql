INSERT INTO analytics.dim_property
(property_id, zone, ward, usage_type, ownership_type, status)

SELECT DISTINCT
    property_id, zone, ward, usage_type, ownership_type, status
FROM public.property
ON CONFLICT (property_id) DO NOTHING;

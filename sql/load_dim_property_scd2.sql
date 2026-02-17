-- ======================================
-- STEP 1: CLOSE OLD RECORDS IF CHANGED
-- ======================================

UPDATE analytics.dim_property d
SET
    effective_to = NOW(),
    is_current = FALSE
FROM public.property p
WHERE d.property_id = p.property_id
  AND d.is_current = TRUE
  AND (
        d.zone <> p.zone OR
        d.ward <> p.ward OR
        d.usage_type <> p.usage_type OR
        d.ownership_type <> p.ownership_type OR
        d.status <> p.status
      );


-- ======================================
-- STEP 2: INSERT NEW CURRENT RECORDS
-- ======================================

INSERT INTO analytics.dim_property (
    property_id,
    zone,
    ward,
    usage_type,
    ownership_type,
    status,
    effective_from,
    effective_to,
    is_current
)
SELECT
    p.property_id,
    p.zone,
    p.ward,
    p.usage_type,
    p.ownership_type,
    p.status,
    NOW(),
    NULL,
    TRUE
FROM public.property p
LEFT JOIN analytics.dim_property d
  ON p.property_id = d.property_id
 AND d.is_current = TRUE
WHERE d.property_id IS NULL
   OR (
        d.zone <> p.zone OR
        d.ward <> p.ward OR
        d.usage_type <> p.usage_type OR
        d.ownership_type <> p.ownership_type OR
        d.status <> p.status
      );

-- ================= SOURCE TABLES =================

-- PROPERTY
INSERT INTO public.property VALUES
('P1','Zone A','Ward 1','Residential','Private','ACTIVE', NOW(), NOW()),
('P2','Zone B','Ward 2','Commercial','Corporate','ACTIVE', NOW(), NOW()),
('P3','Zone C','Ward 3','Residential','Government','INACTIVE', NOW(), NOW());

-- DEMAND
INSERT INTO public.demand VALUES
('D101','P1','2023-24',5000,'ACTIVE', NOW(), NOW()),
('D102','P2','2023-24',12000,'ACTIVE', NOW(), NOW()),
('D103','P3','2023-24',8000,'ACTIVE', NOW(), NOW());

-- PAYMENT
INSERT INTO public.payment VALUES
('PAY1','D101',3000,'2024-06-15','SUCCESS', NOW()),
('PAY2','D101',2000,'2024-07-10','SUCCESS', NOW()),
('PAY3','D102',5000,'2024-06-20','SUCCESS', NOW());

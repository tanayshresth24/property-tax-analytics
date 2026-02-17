INSERT INTO property VALUES
('P1','Zone A','Ward 1','Residential','Private','ACTIVE',NOW(),NOW()),
('P2','Zone B','Ward 2','Commercial','Corporate','ACTIVE',NOW(),NOW()),
('P3','Zone C','Ward 3','Residential','Government','INACTIVE',NOW(),NOW());

INSERT INTO demand VALUES
('D1','P1','2024-25',5000,'ACTIVE',NOW(),NOW()),
('D2','P2','2024-25',12000,'ACTIVE',NOW(),NOW()),
('D3','P3','2024-25',8000,'ACTIVE',NOW(),NOW());

INSERT INTO payment VALUES
('PM1','D1',3000,'2024-06-15','SUCCESS',NOW()),
('PM2','D1',2000,'2024-07-10','SUCCESS',NOW()),
('PM3','D2',5000,'2024-06-20','SUCCESS',NOW());

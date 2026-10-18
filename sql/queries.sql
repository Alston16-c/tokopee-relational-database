-- Query 1: New Product
INSERT INTO product (StockCode, ProductName, CurrentPrice, Description)
VALUES ('P99999','Eco Bamboo Coffee Cup', 12.50,'Reusable bamboo coffee cup with silicone lid');


-- Query 2: Customer double order
START TRANSACTION;

INSERT INTO invoice (InvoiceID, InvoiceDate, CustomerID, TotalAmount, `Status`, AddressID)
VALUES ('70001', NOW(), 12346, 0.0,'Unfinished',12);

-- SELECT * 
-- FROM invoice 
-- WHERE InvoiceID = '70001';

INSERT INTO invoicedetail (InvoiceID, StockCode, Quantity, UnitPrice)
VALUES
('70001', '10002', 2, 3.50),
('70001', '10080', 1, 5.00);

-- SELECT * 
-- FROM invoicedetail 
-- WHERE InvoiceID = '70001';

UPDATE invoice
SET TotalAmount = (
SELECT SUM(Quantity * UnitPrice) 
FROM invoicedetail WHERE InvoiceID = '70001'
)
WHERE InvoiceID = '70001';

-- SELECT InvoiceID, TotalAmount
-- FROM invoice
-- WHERE InvoiceID = '70001';

UPDATE invoice
SET Status = 'Completed'
WHERE InvoiceID = '70001';

-- SELECT *
-- FROM invoice
-- WHERE InvoiceID = '70001';

COMMIT;

-- Query 3: Customer return

START TRANSACTION;

INSERT INTO invoice (InvoiceID, InvoiceDate, CustomerID, TotalAmount, `Status`, AddressID)
VALUES ('C70001', NOW(), 12346, 0.0,'Unfinished',12);

INSERT INTO invoicedetail (InvoiceID, StockCode, Quantity, UnitPrice)
VALUES
('C70001', '10002', -2, 3.50),
('C70001', '10080', -1, 5.00);

-- SELECT * 
-- FROM invoicedetail 
-- WHERE InvoiceID = 'C70001';

UPDATE invoice
SET TotalAmount = (
SELECT SUM(Quantity * UnitPrice) 
FROM invoicedetail WHERE InvoiceID = 'C70001'
)
WHERE InvoiceID = 'C70001';

-- SELECT InvoiceID, TotalAmount
-- FROM invoice
-- WHERE InvoiceID = 'C70001';

UPDATE invoice
SET Status = 'Completed'
WHERE InvoiceID = 'C70001';

-- SELECT *
-- FROM invoice
-- WHERE InvoiceID = 'C70001';

COMMIT;

-- Query 4: top 10 customer
SELECT CustomerID, SUM(TotalAmount) AS Total_Spent
FROM invoice
WHERE Status = 'Completed'
GROUP BY CustomerID
ORDER BY Total_Spent DESC
LIMIT 10;

-- Query 5:Highest revenue month in 2011
SELECT
    MONTHNAME(InvoiceDate) AS Month_Name,
    EXTRACT(MONTH FROM InvoiceDate) AS Month,
    SUM(TotalAmount) AS total_sales_revenue
FROM invoice
WHERE EXTRACT(YEAR FROM InvoiceDate) = 2011
  AND Status = 'Completed'
GROUP BY Month
ORDER BY total_sales_revenue DESC
LIMIT 1;

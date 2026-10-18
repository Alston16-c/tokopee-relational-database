DELIMITER $$

CREATE TRIGGER trg_update_inventory_after_invoice_details
AFTER INSERT ON invoicedetail
FOR EACH ROW
BEGIN
    UPDATE product p
    SET p.CurrentStock = p.CurrentStock - NEW.Quantity
    WHERE p.StockCode LIKE NEW.StockCode COLLATE utf8mb4_general_ci;
END$$

DELIMITER ;

DELIMITER $$

CREATE PROCEDURE GetCustomerInvoiceHistory(IN ID INT)
BEGIN
    SELECT 
        InvoiceID,
        InvoiceDate,
        TotalAmount
    FROM invoice
    WHERE CustomerID = ID
    ORDER BY InvoiceDate DESC;
END $$

DELIMITER ;
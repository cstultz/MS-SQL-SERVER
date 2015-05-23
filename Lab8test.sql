/*
********************************************
Oracle10g with SQL Developer
using SQL Developer 4.0.3.16
Lab7test.sql
2014.11.18 maintenance history
********************************************
*/

-- Chris Stultz
-- 15 Tests for Lab8 to test entire code.

SET ECHO OFF --toggles code display (default is usually off)

SET VERIFY OFF --toggles old and new display (default is usually on)

SET FEEDBACK ON  --toggles results display (default is usually on)

GO
BEGIN
@Lab8 0, 6099, 1001, 15  --Tests invalid CustID input only. #2
@Lab8 1 0 0 0 --Tests valid CustID input only. #2
@Lab8 1 0 1001 15 --Tests invalid OrderID input only. #3
@Lab8 0 6099 0 0 --Tests valid OrderID input only. #3
@Lab8 1 6109 1001 15 --Tests valid OrderID that does not belong to the valid CustID. #4
@Lab8 1 6099 0 0 --Tests valid OrderID that does belong to the valid CustID. #4
@Lab8 1 6099 0 15 --Tests invalid PartID input only. #5
@Lab8 0 0 1001 0 --Tests valid PartID input only. #5
@Lab8 1 6099 1001 0 --Tests invalid Qty input only. #6
@Lab8 0 0 0 15 --Tests valid Qty input only. #6
@Lab8 1 6107 1001 10  --6107 Order added with no OrderItems for CustID 1 (Detail = 0; Set Detail = 1). Tests ALL valid input. Successful Transaction. Commit. Customer 1 #7
@Lab8 1 6099 1001 40 --Tests ALL valid input and exhaust entire StockQty of 1001 Testing 0 left in StockQty. Successful Transaction. Commit. #9
@Lab8 1 6099 1001 200 --Tests ALL valid input and Test stock on hand not enough to fill order Transaction Failure. Rollback. #9
@Lab8 1 6099 1001 15  --Tests ALL valid input. Successful Transaction. Commit. Customer 1. #10
@Lab8 2 6109 1010 15  --Tests ALL valid input. Successful Transaction. Commit. Customer 2. #10

--Next statement Inserts Order 6107 for Customer 1
INSERT INTO ORDERS (Orderid, Empid, Custid, SalesDate)
VALUES (6107          --Orderid
      , 101           --Empid
      , 1             --Custid
      , '15-DEC-95'   --SalseDate
       );
COMMIT;

--Next update will set Part ID 1001 back to original StockQty Value.
UPDATE INVENTORY i
SET i.StockQty = 100
WHERE i.Partid = 1001;
COMMIT;

--Next update will set Part ID 1010 back to original StockQty Value.
UPDATE INVENTORY i
SET i.StockQty = 110
WHERE i.Partid = 1010;
COMMIT;

# MS-SQL-SERVER
TransactSQL - Embedded SQL, stored procedures and triggers.

Introduction
Using Transact SQL and SQL Server 2012, This code focuses on embedded SQL, stored procedures and triggers. 

Database Design
Create and load the tables into your SQL Server 2012 database. The names of the relations (tables) are: 

CUSTOMERS    ( CustID, Cname, Credit )
SALESPERSONS ( EmpID, Ename, Rank, Salary )
ORDERS       ( OrderID, EmpID, CustID, SalesDate )
ORDERITEMS   ( OrderID, Detail, PartID, Qty )
INVENTORY    ( PartID, Description, StockQty, ReorderPnt, Price )
Code Notes
•	There are seven stored procedures and two triggers. Along with testing for each object, there is also a testing script.
•	The test script will verify that the correct changes are made to the tables in the database:

o	Valid and invalid CustID 
o	Valid and invalid OrderID 
o	Good and bad CustID / OrderID pairing
o	Valid and invalid PartID 
o	Qty that is less than zero, equal to zero, and greater than zero
o	Valid CustID, OrderID, PartID and Qty that would result in insufficient stock 
o	Valid CustID, OrderID, PartID and Qty that will reduce stock on hand to zero
o	Valid CustID, OrderID, PartID and Qty for an order with line items
o	Valid CustID, OrderID, PartID and Qty for an order with no previous line items 
Code 
1.	DROP, CREATE, and test of the procedure, ValidateCustID, that validates the entered CustID against the current CustIDs in the CUSTOMERS table. This procedure accepts a CustID and returns the name of the customer. 

2.	DROP, CREATE, and test of the procedure, ValidateOrderID, that first validates the entered OrderID against the current OrderIDs in the ORDERS table. Then it compares both CustID and OrderID together in the ORDERS table to check that the pairing is valid. Both CustID and OrderID are sent to the procedure which returns the SalesDate when both validations are good.

3.	DROP, CREATE, and test of the procedure, ValidatePartID, that validates the entered PartID against the current PartIDs in the INVENTORY table. Input the PartID and output the Description.

4.	DROP, CREATE, and test of the procedure, ValidateQty, that validates the entered Qty to ensure it is greater than zero. 

5.	DROP, CREATE, and test of the UPDATE trigger on INVENTORY table, UpdateInventoryTRG. This trigger only tests the value of the new (INSERTED) StockQty for the PartID currently being considered by the transaction. When the value is less than or equal to zero, an error must be raised.

6.	DROP, CREATE, and test of the INSERT trigger on ORDERITEMS table, InsertOrderitemsTRG. 

7.	DROP, CREATE, and test of the procedure, GetNewDetail, that determines the Detail value for new line item. This stored procedure accepts an OrderID and returns a value for the next detail. SQL Server will not allow you to assign a column value to the newly inserted row inside of the trigger so you must have the Detail for the INSERT statement in AddLineItemSP. Be sure to handle the case of an OrderID without detail lines in the OrderItems table.

8.	DROP and CREATE of the procedure that does the transaction processing, AddLineItem. This procedure will call GetNewDetailSP and then perform an INSERT to the ORDERITEMS table. Before the transaction does a COMMIT or ROLLBACK, print a statement that says the transaction is committed or rolled back.

9.	DROP and CREATE of the procedure, Lab8proc, that receives the CustID, OrderID, PartID, and Qty as input parameters (in that order please) and essentially brings all the other parts together. In this program you will validate all the data and do the transaction processing by calling the previously written and tested stored procedures:

1.	Print a statement that Lab8proc begins.
2.	EXECUTE the CustID validation procedure and print a line giving the input CustID and a statement that it is valid or invalid.
3.	EXECUTE the OrderID validation procedure and print a line giving the input OrderID value and a statement that it is valid or invalid. Print another line stating the OrderID and CustID values are valid together or not.
4.	EXECUTE the PartID validation procedure and print a line giving the input PartID value and a statement that it is valid or invalid.
5.	EXECUTE the Qty validation procedure and print a line giving the input Qty value and a statement that it is valid or invalid.
6.	If all is good, print a message stating that Lab8proc validations were good so the transaction continues and then EXECUTE the add line item procedure; otherwise print a message stating that Lab8proc is ending the transaction and do not run the add line item procedure.

10.	Testing of Lab8proc (similar to tests used in Labs 6 and 7). Please use different data and include your test plan, pertinent table data before and after if needed, and PRINT statements to show what each test is supposed to prove.

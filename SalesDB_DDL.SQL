/*
********************************************************************************
SalesDB Build
MS SQL Server 2012
DROP, CREATE, INSERT
********************************************************************************
*/
GO

PRINT '
--------------------------------------------------------------------------------
DROP SalesDB tables
--------------------------------------------------------------------------------
';
GO

IF EXISTS (SELECT name FROM sys.objects WHERE name = 'ORDERITEMS')
    DROP TABLE ORDERITEMS;
GO

IF EXISTS (SELECT name FROM sys.objects WHERE name = 'ORDERS')
    DROP TABLE ORDERS;
GO

IF EXISTS (SELECT name FROM sys.objects WHERE name = 'CUSTOMERS')
    DROP TABLE CUSTOMERS;
GO

IF EXISTS (SELECT name FROM sys.objects WHERE name = 'INVENTORY')
    DROP TABLE INVENTORY;
GO

IF EXISTS (SELECT name FROM sys.objects WHERE name = 'SALESPERSONS')
    DROP TABLE SALESPERSONS;
GO

PRINT '
--------------------------------------------------------------------------------
DROP SalesDB other objects; specific to the Lab8 assignment
--------------------------------------------------------------------------------
';
GO

-- Since trigger is on the INVENTORY table, 
-- when INVENTORY is dropped the trigger will disappear too
IF EXISTS (SELECT name FROM sys.objects WHERE name = 'InventoryUpdateTrg')
    DROP TRIGGER InventoryUpdateTrg;
GO

-- Since trigger is on ORDERITEMS, 
-- when ORDERITEMS is dropped the trigger will go away too
IF EXISTS (SELECT name FROM sys.objects WHERE name = 'OrderitemsInsertTrg')
    DROP TRIGGER OrderitemsInsertTrg;
GO

IF EXISTS (SELECT name FROM sys.objects WHERE name = 'GetNewDetail')
    DROP PROCEDURE GetNewDetail;
GO

IF EXISTS (SELECT name FROM sys.objects WHERE name = 'AddLineItem')
    DROP PROCEDURE AddLineItem;
GO

IF EXISTS (SELECT name FROM sys.objects WHERE name = 'LAB8proc')
    DROP PROCEDURE LAB8proc;
GO

PRINT '
--------------------------------------------------------------------------------
CREATE SalesDB tables and ALTER tables for PK/FK constraints
--------------------------------------------------------------------------------
';
GO

CREATE TABLE CUSTOMERS
(
  CustID   SMALLINT     NOT NULL
, Cname    NVARCHAR(25) NOT NULL
, Credit   NVARCHAR(1)  NOT NULL
, CONSTRAINT PK_CUSTOMERS PRIMARY KEY (CustID) 
);
GO

CREATE TABLE SALESPERSONS 
(
  EmpID     SMALLINT    NOT NULL
, Ename     VARCHAR(15) NOT NULL
, [Rank]    SMALLINT    NOT NULL
, Salary    MONEY       NOT NULL
, CONSTRAINT PK_SALESPERSONS PRIMARY KEY (EmpID)
);
GO

CREATE TABLE ORDERS 
(
  OrderID   SMALLINT NOT NULL
, EmpID     SMALLINT NOT NULL
, CustID    SMALLINT NOT NULL
, SalesDate SMALLDATETIME NOT NULL
, CONSTRAINT PK_ORDERS PRIMARY KEY (OrderID)
, CONSTRAINT FK_ORDERS_CUSTOMERS FOREIGN KEY (OrderID)
      REFERENCES ORDERS (OrderID)
);
GO

CREATE TABLE INVENTORY 
( 
  PartID      SMALLINT     NOT NULL
, Description NVARCHAR(10) NOT NULL
, StockQty    SMALLINT     NOT NULL
, ReorderPnt  SMALLINT     NULL
, Price       MONEY        NOT NULL
, CONSTRAINT PK_INVENTORY PRIMARY KEY (PartID)
);
GO

CREATE TABLE ORDERITEMS 
(
  OrderID   SMALLINT     NOT NULL
, Detail    SMALLINT     NOT NULL
, PartID    SMALLINT     NOT NULL
, Qty       SMALLINT     NOT NULL
, CONSTRAINT PK_ORDERITEMS PRIMARY KEY (OrderID, Detail)
, CONSTRAINT FK_ORDERITEMS_INVENTORY FOREIGN KEY (PartID)
      REFERENCES INVENTORY (PartID)
, CONSTRAINT FK_ORDERITEMS_ORDERS FOREIGN KEY (OrderID)
      REFERENCES ORDERS (OrderID)
);
GO

PRINT '
--------------------------------------------------------------------------------
Fill SalesDB tables
--------------------------------------------------------------------------------
';
GO

INSERT INTO CUSTOMERS
    SELECT * FROM SalesDB.dbo.CUSTOMERS;
GO

INSERT INTO SALESPERSONS
    SELECT * FROM SalesDB.dbo.SALESPERSONS;
GO

INSERT INTO INVENTORY
    SELECT * FROM SalesDB.dbo.INVENTORY;
GO

INSERT INTO ORDERS
    SELECT * FROM SalesDB.dbo.ORDERS;
GO

INSERT INTO ORDERITEMS
    SELECT * FROM SalesDB.dbo.ORDERITEMS;
GO

PRINT '
--------------------------------------------------------------------------------
Make it so and advise
--------------------------------------------------------------------------------
';

BEGIN TRANSACTION
    DECLARE @v_now DATETIME
    BEGIN
        SET @v_now = GETDATE()
        PRINT '----------------------------';
        PRINT 'SalesDB has been initialized';
        PRINT @v_now
        PRINT '----------------------------';
        COMMIT
    END;
-- END TRANSACTION


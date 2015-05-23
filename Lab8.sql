/*
********************************************************************************
CIS276 @PCC using SQL Server 2012 with Management Studio
THIS IS A TEMPLATE - ALWAYS FOLLOW THE LAB ASSIGNMENT INSTRUCTIONS FIRST
20141123 Vicki Jonathan, Instructor
--------------------------------------------------------------------------------
CREATE procedures and triggers must be the first command in a batch.
********************************************************************************
*/
PRINT '
--------------------------------------------------------------------------------
CERTIFICATION:
I, << Christopher C. Stultz >>, certify that the following is original code written 
by myself without unauthorized assistance. I agree to abide by class restrictions 
and understand that if I have violated them, I may receive reduced credit 
(or no credit) for this assignment.
--------------------------------------------------------------------------------
';
GO

-- specify database to be used; THIS WILL BE YOUR DATABASE
USE s276CStultz
GO

PRINT '
--------------------------------------------------------------------------------
ValidateCustID 
A procedure that will return a value if the CustID is in the CUSTOMERS table
DROP, CREATE, TEST
--------------------------------------------------------------------------------
';
GO

IF EXISTS (SELECT name FROM sys.objects WHERE name = 'ValidateCustID')
    BEGIN DROP PROCEDURE ValidateCustID END; 

GO

CREATE PROCEDURE ValidateCustID 
      @iCustID SMALLINT
    , @oFound  NVARCHAR(25) OUTPUT 
AS 
BEGIN 
    SET @oFound = 'N';

    SELECT @oFound = Cname
    FROM CUSTOMERS
    WHERE CustID = @iCustID;

	IF @oFound = 'N' 
	    BEGIN 
		    PRINT 'CustID ' + LTRIM(CAST(@iCustID AS NVARCHAR)) + ' is invalid.'; 
		END;
	ELSE
		BEGIN
			PRINT 'CustID ' + LTRIM(CAST(@iCustID AS NVARCHAR))  + ' is valid.';
		END;
END;
GO

BEGIN
    DECLARE @vCname  NVARCHAR(25);

    EXECUTE ValidateCustID    1, @vCname OUTPUT; --valid customer
	PRINT ' ';

    EXECUTE ValidateCustID   -1, @vCname OUTPUT; --invalid negative number customer
	PRINT ' ';

    EXECUTE ValidateCustID 9999, @vCname OUTPUT; --invalid positive number customer
	PRINT ' ';
END;
GO

PRINT '
--------------------------------------------------------------------------------
ValidateOrderID
A procedure that will return a value if the Orderid is valid for the customer
as well as something to say that the CustID/OrderID pairing is valid
--------------------------------------------------------------------------------
';

IF EXISTS (SELECT name FROM sys.objects WHERE name = 'ValidateOrderID')
    BEGIN DROP PROCEDURE ValidateOrderID; END;
GO

CREATE PROCEDURE ValidateOrderID 
      @iOrderID        SMALLINT
    , @iCustID         SMALLINT
	, @oFound          NVARCHAR(12) OUTPUT
AS 
	BEGIN 

		SET    @oFound = 'N';

		SELECT @oFound = 'Y'
        FROM   ORDERS
        WHERE  OrderID = @iOrderID;

		IF @oFound = 'Y' 
		    BEGIN
				
				SET @oFound = 'N';

				PRINT 'OrderID '  + LTRIM(CAST(@iOrderID AS NVARCHAR)) + ' is valid.';

				SELECT @oFound = CONVERT(CHAR(12), SalesDate, 101)
				FROM ORDERS
				WHERE OrderID = @iOrderID AND CustID = @iCustID;

				IF  @oFound = 'N' --OrderID/CustID is invalid
				    BEGIN 

					    PRINT 'OrderID '  + LTRIM(CAST(@iOrderID AS NVARCHAR)) + 
					 	  ' does not belong to CustID '  + LTRIM(CAST(@iCustID  AS NVARCHAR)); 
					END;
				ELSE
					BEGIN
						
						PRINT 'OrderID '  + LTRIM(CAST(@iOrderID AS NVARCHAR)) + 
					 	  ' belongs to CustID '  + LTRIM(CAST(@iCustID  AS NVARCHAR));
					END;
		    END;
		ELSE
			BEGIN
				PRINT 'OrderID '  + LTRIM(CAST(@iOrderID AS NVARCHAR)) + ' is invalid.';
			END;
	END;
GO

BEGIN    
    DECLARE @vSalesDate NVARCHAR(12);  

    EXECUTE ValidateOrderID 9999, -1, @vSalesDate OUTPUT; -- invalid OrderID. invalid CustID
	PRINT ' ';

    EXECUTE ValidateOrderID 9999,  1, @vSalesDate OUTPUT; -- invalid OrderID. valid CustID
	PRINT ' ';

    EXECUTE ValidateOrderID 6099, -1, @vSalesDate OUTPUT; -- valid OrderID. invalid CustID. Invalid pairing OUTPUT.
	PRINT ' ';

    EXECUTE ValidateOrderID 6099,  2, @vSalesDate OUTPUT; -- valid OrderID. valid CustID. Invalid pairing OUTPUT.
	PRINT ' ';

    EXECUTE ValidateOrderID 6099,  1, @vSalesDate OUTPUT; -- invalid OrderID. invalid CustID. Valid pairing OUTPUT.
	PRINT ' ';
END;
GO

PRINT'
--------------------------------------------------------------------------------
ValidatePartID
A procedure that will return a value if the Partid is in the INVENTORY table
--------------------------------------------------------------------------------
';
IF EXISTS (SELECT name FROM sys.objects WHERE name = 'ValidatePartID')
    BEGIN DROP PROCEDURE ValidatePartID; END;
GO

CREATE PROCEDURE ValidatePartID 
      @iPartID  SMALLINT
    , @oFound   NVARCHAR(10) OUTPUT 
AS 
	BEGIN 
		SET    @oFound = 'N';

		SELECT @oFound = Description
		FROM INVENTORY
		WHERE PartID = @iPartID;

	IF @oFound = 'N' 
	    BEGIN 
		    PRINT 'PartID ' + LTRIM(STR(@iPartID, 7, 0)) + ' is invalid.';
		END;
	ELSE
		BEGIN
			PRINT 'PartID ' + LTRIM(STR(@iPartID, 7, 0)) + ' is valid.';
		END;
	END;
GO

BEGIN    
	DECLARE @vDescription  NVARCHAR(10);

	EXECUTE ValidatePartID  1010, @vDescription OUTPUT; --valid PartID
    PRINT   ' ';

    EXECUTE ValidatePartID  9999, @vDescription OUTPUT; --invalid positive number PartID
    PRINT   ' ';

    EXECUTE ValidatePartID -9999, @vDescription OUTPUT; --invalid negative number PartID
	PRINT ' ';
END;
GO

PRINT'
--------------------------------------------------------------------------------
ValidateQty
A procedure that will return a value if the Qty in the new lineitem is >= 0
--------------------------------------------------------------------------------
';
IF EXISTS (SELECT name FROM sys.objects WHERE name = 'ValidateQty')
    BEGIN DROP PROCEDURE ValidateQty; END;
GO

CREATE PROCEDURE ValidateQty 
      @iQty     SMALLINT
    , @oFound   SMALLINT OUTPUT 
AS 
	BEGIN 
		SET @oFound = -1;

		IF (@iQty > 0)
				BEGIN 
					SET @oFound = @iQty;
				END;

		IF @oFound = -1
			BEGIN 
				PRINT 'Qty ' + LTRIM(STR(@iQty, 7, 0)) + ' is invalid. Qty must be greater than zero to place an order.';
			END;
		ELSE
			BEGIN
				PRINT 'Qty ' + LTRIM(STR(@iQty, 7, 0)) + ' is valid.';
			END;
		
	END;
GO

BEGIN    
	DECLARE @vQty  NVARCHAR(7);

	EXECUTE ValidateQty 1, @vQty OUTPUT; --valid Qty
	PRINT   ' ';

    EXECUTE ValidateQty 0, @vQty OUTPUT; --invalid equal to zero Qty
	PRINT   ' ';

    EXECUTE ValidateQty -1, @vQty OUTPUT; --invalid less than zero Qty
	PRINT   ' ';
END;
GO

PRINT'
--------------------------------------------------------------------------------
UpdateInventoryTRG
A trigger on UPDATE for the INVENTORY table
Checks value for updated StockQty and includes error handling
--------------------------------------------------------------------------------
';
IF EXISTS (SELECT name FROM sys.objects WHERE name = 'UpdateInventoryTRG')
    BEGIN DROP TRIGGER UpdateInventoryTRG; END;
GO

CREATE TRIGGER UpdateInventoryTRG
ON INVENTORY
FOR UPDATE
AS
	BEGIN 
		DECLARE @vStockQty   SMALLINT;
		DECLARE @vError      INT;
		DECLARE @vErrMsg     VARCHAR(100);
		DECLARE @vPartID     SMALLINT;

		SET @vErrMsg = ' ';

		SELECT @vPartID = PartID FROM INSERTED;

		SELECT  @vStockQty = StockQty FROM INVENTORY WHERE PartID = @vPartID;
		
		IF @vStockQty <= 0
		    BEGIN 
				SET @vErrMsg = 'The StockQty ' + LTRIM(STR(@vStockQty, 7, 0)) + ' must be greater than zero.';
				RaisError(@vErrMsg, 1, 1) WITH SetError;

			END;

	END;
GO

BEGIN
    UPDATE INVENTORY SET StockQty =   0 WHERE PartID = 1010; --invalid NewStockQty equal to zero
	PRINT ' ';
    UPDATE INVENTORY SET StockQty =  -1 WHERE PartID = 1010; --invalid NewStockQty less than zero
	PRINT ' ';
	UPDATE INVENTORY SET StockQty = 110 WHERE PartID = 1010; --valid NewStockQty positive value
	PRINT ' ';
END;
GO

PRINT'
--------------------------------------------------------------------------------
InsertOrderitemsTRG
A trigger on INSERT for the ORDERITEMS table
Performs the INVENTORY UPDATE and includes error handling
--------------------------------------------------------------------------------
';

IF EXISTS (SELECT name FROM sys.objects WHERE name = 'InsertOrderitemsTRG')
    BEGIN DROP TRIGGER InsertOrderitemsTRG; END;
-- END IF;
GO

CREATE TRIGGER InsertOrderitemsTRG
ON ORDERITEMS
FOR INSERT
AS
BEGIN
    DECLARE   @vQty        SMALLINT;
    DECLARE   @vPartID     SMALLINT;
    DECLARE   @vStockQty   SMALLINT;
	DECLARE   @vError      INT;
    DECLARE   @vErrMsg     NVARCHAR(100);

	SET @vQty = 0;
	SET @vPartID = 0;
	SET @vStockQty = 0;
	SET @vErrMsg = ' ';

	SELECT @vQty = Qty, @vPartID = PartID FROM INSERTED;

	UPDATE INVENTORY SET StockQty = StockQty - @vQty WHERE PartID = @vPartID;
	
	SELECT @vStockQty = StockQty FROM INVENTORY WHERE PartID = @vPartID;

	PRINT 'PartID ' + LTRIM(STR(@vPartID, 7, 0)) + ' old StockQty was ' + LTRIM(STR((@vStockQty + @vQty), 7, 0)) + '.';
	PRINT 'PartID ' + LTRIM(STR(@vPartID, 7, 0)) + ' new StockQty is '  + LTRIM(STR((@vStockQty), 7, 0)) + '.';

	IF @vStockQty <= 0
		BEGIN 
			SET @vErrMsg = 'There is not enough StockQty on hand ' + LTRIM(STR((@vStockQty + @vQty), 7, 0)) + 
			                                        ' for PartID ' + LTRIM(STR(@vPartID, 7, 0)) + ' to fill the order Qty of ' + LTRIM(STR(@vQty, 7, 0)) + '.';
			RaisError(@vErrMsg, 1, 1) WITH SetError;

		END;
END;
GO

BEGIN
	/*
	********************************************************************************
	Test 1 Block (For PartID 1001 the starting StockQty is 100)
	********************************************************************************
	*/
	BEGIN 
		INSERT INTO ORDERITEMS (OrderID, Detail, PartID, Qty)
		VALUES (6128, 3, 1001, 1000);                                       --Invalid Qty ordered. Not enough Stock on hand to fill the order.

		DELETE FROM ORDERITEMS WHERE OrderID = 6128 AND Detail = 3;         --DELETE newley inserted ORDERITEM Detail
		UPDATE INVENTORY SET StockQty = 100 WHERE PartID = 1001;            --UPDATE StockQty back to original value
	END;
	/*
	********************************************************************************
	Test 2 Block (For PartID 1005 the starting StockQty is 24)
	********************************************************************************
	*/
	BEGIN
		INSERT INTO ORDERITEMS (OrderID, Detail, PartID, Qty)
		VALUES (6128, 3, 1005, 1);                                          --Valid Qty ordered. 

		DELETE FROM ORDERITEMS WHERE OrderID = 6128 AND Detail = 3;         --DELETE newley inserted ORDERITEM Detail
		UPDATE INVENTORY SET StockQty = 24 WHERE PartID = 1005;             --UPDATE StockQty back to original value
	END;
	/*
	********************************************************************************
	Test 3 Block (For PartID 1006 the starting StockQty is 87)
	********************************************************************************
	*/
	BEGIN
		INSERT INTO ORDERITEMS (OrderID, Detail, PartID, Qty)
		VALUES (6128, 3, 1006, 1);                                          --Valid Qty ordered. 

		DELETE FROM ORDERITEMS WHERE OrderID = 6128 AND Detail = 3;         --DELETE newley inserted ORDERITEM Detail
		UPDATE INVENTORY SET StockQty = 87 WHERE PartID = 1006;             --UPDATE StockQty back to original value
	END;
END;
GO

PRINT'
--------------------------------------------------------------------------------
GetNewDetail
A procedure that will determine the value of the Detail column for a new line 
item (SQL Server will not allow you to assign a column value to the newly 
inserted row inside of the trigger).
You can handle NULL within the projection or it can be done in two steps
(SELECT and then test). It is important to deal with the possibility of NULL
because Detail is part of the primary key and therefore cannot contain NULL.
--------------------------------------------------------------------------------
';
IF EXISTS (SELECT name FROM sys.objects WHERE name = 'GetNewDetail')
    BEGIN DROP PROCEDURE GetNewDetail; END;
-- END IF;
GO

CREATE PROCEDURE GetNewDetail 
	@iOrderID   SMALLINT
  , @oDetail    SMALLINT OUTPUT 
AS 
BEGIN 
	SELECT @oDetail = MAX(Detail)+1 
	FROM ORDERITEMS oi JOIN ORDERS o 
	ON oi.OrderID = o.OrderID 
	WHERE oi.OrderID = @iOrderID;

	IF @oDetail is NULL
		SET @oDetail = 1;                    --If Order contains no OrderItems Details
END;
GO

BEGIN  
	DECLARE   @vDetail     SMALLINT;

/* ----------TEST BLOCK 1 NEW DATA ADDED THEN REMOVED IN ORDER TO TEST AN ORDER WITH NO DETAILS----------*/
	INSERT INTO ORDERS (OrderID, EmpID, CustID, SalesDate)
	VALUES (5057, 500, 555, '1995/10/15');
	
	EXECUTE GetNewDetail 5057, @vDetail OUTPUT; --Order with NO details

	DELETE FROM ORDERS WHERE OrderID = 5057;
/* ----------TEST BLOCK 1 NEW DATA ADDED THEN REMOVED IN ORDER TO TEST AN ORDER WITH NO DETAILS----------*/

    --TEST 2
	EXECUTE GetNewDetail 6099, @vDetail OUTPUT; --Order with details

END;
GO

PRINT'
--------------------------------------------------------------------------------
AddLineItem
A procedure that does the transaction processing (adds the order item). 
This procedure calls GetNewDetail procedure and, with successful return,
performs an INSERT to the ORDERITEMS table which in turn performs an UPDATE 
to the INVENTORY table. Error handling determines COMMIT/ROLLBACK.
--------------------------------------------------------------------------------
';

IF EXISTS (SELECT name FROM sys.objects WHERE name = 'AddLineItem')
    BEGIN DROP PROCEDURE AddLineItem; END;
-- END IF;
GO

CREATE PROCEDURE AddLineItem 
	@iOrderID   SMALLINT
  , @iPartID    SMALLINT
  , @iQty       SMALLINT
   
AS
BEGIN
BEGIN TRAN    -- this is the only BEGIN TRANSACTION for the lab assignment

    DECLARE @vDetail   SMALLINT;
	DECLARE @vError    INT;
	DECLARE @vErrMsg   VARCHAR(100);

    EXECUTE GetNewDetail @iOrderID, @vDetail OUTPUT;

	INSERT INTO ORDERITEMS (OrderID, Detail, PartID, Qty)
	VALUES (@iOrderID, @vDetail, @iPartID, @iQty);
	SET @vError = @@ERROR;

	IF (@vError <> 0)
		BEGIN
			SET @vErrMsg = 'Transaction Failure. Rolling Back.';
			ROLLBACK TRAN;
			RAISERROR(@vErrMsg, 1, 1) WITH SetError;
		END;
	ELSE
		BEGIN
			PRINT ('Successful Transaction. Commit.');
			COMMIT; 
		END;


END;
GO

PRINT'
--------------------------------------------------------------------------------
Lab8proc
A procedure that puts all of the above together to produce a solution for Lab8 
done in SQL Server. This is a stored procedure that accepts the 4 pieces of 
input: Custid, Orderid, Partid, and Qty (in that order please). 
Lab8proc will validate all the data and do the transaction processing 
by calling the previously written and tested modules.
--------------------------------------------------------------------------------
';
IF EXISTS (SELECT name FROM sys.objects WHERE name = 'Lab8proc')
    BEGIN DROP PROCEDURE Lab8proc; END;
-- END IF;
GO

CREATE PROCEDURE Lab8proc 
	@iCustID    SMALLINT
  , @iOrderID   SMALLINT
  , @iPartID    SMALLINT
  , @iQty       SMALLINT

AS

BEGIN
    -- DECLARE user defined variables for use in this procedure
    -- EXECUTE ValidateCustId
	-- EXECUTE ValidateOrderid
    -- EXECUTE ValidatePartId
    -- EXECUTE ValidateQty
	-- IF everything validates THEN we can do the TRANSACTION
        -- EXECUTE AddLineItem
        -- IF good then COMMIT else ROLLBACK
        -- END IF;
    -- ELSE send a message of data entry errors
    -- ENDIF;

	DECLARE @vCustID        SMALLINT;
	DECLARE @vCname         NVARCHAR(25);
	DECLARE @vOrderID       SMALLINT;
	DECLARE @vSalesDate     NVARCHAR(12);
	DECLARE @vPartID        SMALLINT;
	DECLARE @vDescription   NVARCHAR(10);
	DECLARE @vQty           SMALLINT;
	DECLARE @vError         INT;
	
	DECLARE @vFlag         CHAR(1) = 'Y';

    EXECUTE ValidateCustID @iCustID, @vCname OUTPUT;
	IF @vCname = 'N' BEGIN SET @vFlag = 'N'; END;

	EXECUTE ValidateOrderID @iOrderID, @iCustID, @vSalesDate OUTPUT;
	IF @vSalesDate = 'N' BEGIN SET @vFlag = 'N'; END;

    EXECUTE ValidatePartID @iPartID, @vDescription OUTPUT;
	IF @vDescription = 'N' BEGIN SET @vFlag = 'N'; END;

    EXECUTE ValidateQty @iQty, @vQty OUTPUT;
	IF @vQty = -1 BEGIN SET @vFlag = 'N'; END;

	IF @vFlag = 'Y'
	    BEGIN
			EXECUTE AddLineItem @iOrderID, @iPartID, @iQty;
			SET @vError = @@ERROR;

			IF (@vError = 0)
				BEGIN
					PRINT ('---------------------------------------------------------------------------------------------------');
					PRINT ('CustID      Name                               OrderID       Sales Date            PartID        Qty');
					PRINT (CAST(@iCustID AS CHAR(2)) + REPLICATE(' ', 10) + CAST(@vCname AS CHAR(25)) + REPLICATE(' ', 10) + CAST(@iOrderID AS CHAR(4)) + REPLICATE(' ', 10) + CAST(@vSalesDate AS CHAR(12)) + REPLICATE(' ', 10) + CAST(@iPartID AS CHAR(4)) + REPLICATE(' ', 10) + CAST(@iQty AS CHAR(7)));
					PRINT ('---------------------------------------------------------------------------------------------------');
					PRINT (' ');
				END;
		END;


END;
GO 

PRINT'
--------------------------------------------------------------------------------
Testing of Lab8proc 
(similar to the testing you did previously for the Oracle labs 6 and 7)
--------------------------------------------------------------------------------
';

BEGIN
-- EXECUTE Lab8proc value_for_CustID, value_for_OrderID, value_for_PartID, aQty_value

PRINT '
--------------------------------------------------------------------------------
Tests invalid CustID input only. #1
--------------------------------------------------------------------------------
';
EXECUTE Lab8proc 0, 6099, 1001, 15;  
PRINT ' '; PRINT ' '; PRINT ' ';

PRINT '
--------------------------------------------------------------------------------
Tests valid CustID input only. #1
--------------------------------------------------------------------------------
';
EXECUTE Lab8proc 1, 0, 0, 0; 
PRINT ' '; PRINT ' '; PRINT ' ';

PRINT '
--------------------------------------------------------------------------------
Tests invalid OrderID input only. #2
--------------------------------------------------------------------------------
';
EXECUTE Lab8proc 1, 0, 1001, 15; 
PRINT ' '; PRINT ' '; PRINT ' ';

PRINT '
--------------------------------------------------------------------------------
Tests valid OrderID input only. #2
--------------------------------------------------------------------------------
';
EXECUTE Lab8proc 0, 6099, 0, 0; 
PRINT ' '; PRINT ' '; PRINT ' ';

PRINT '
--------------------------------------------------------------------------------
Tests valid OrderID that does not belong to the valid CustID. #2
--------------------------------------------------------------------------------
';
EXECUTE Lab8proc 1, 6109, 1001, 15; 
PRINT ' '; PRINT ' '; PRINT ' ';

PRINT '
--------------------------------------------------------------------------------
Tests valid OrderID that does belong to the valid CustID. #2
--------------------------------------------------------------------------------
';
EXECUTE Lab8proc 1, 6099, 0, 0; 
PRINT ' '; PRINT ' '; PRINT ' ';

PRINT '
--------------------------------------------------------------------------------
Tests invalid PartID input only. #3
--------------------------------------------------------------------------------
';
EXECUTE Lab8proc 1, 6099, 0, 15; 
PRINT ' '; PRINT ' '; PRINT ' ';

PRINT '
--------------------------------------------------------------------------------
Tests valid PartID input only. #3
--------------------------------------------------------------------------------
';
EXECUTE Lab8proc 0, 0, 1001, 0; 
PRINT ' '; PRINT ' '; PRINT ' ';

PRINT '
--------------------------------------------------------------------------------
Tests invalid Qty input only. #4
--------------------------------------------------------------------------------
';
EXECUTE Lab8proc 1, 6099, 1001, 0; 
PRINT ' '; PRINT ' '; PRINT ' ';

PRINT '
--------------------------------------------------------------------------------
Tests valid Qty input only. #4
--------------------------------------------------------------------------------
';
EXECUTE Lab8proc 0, 0, 0, 15; 
PRINT ' '; PRINT ' '; PRINT ' ';


PRINT '
--------------------------------------------------------------------------------
INSERT: Order 5555 for CustID 1 FOR #7
--------------------------------------------------------------------------------
';
INSERT INTO ORDERS (OrderID, EmpID, CustID, SalesDate)
VALUES (5555, 101, 1, '1995/10/15');

PRINT '
--------------------------------------------------------------------------------
TEST 5555 Order added with no OrderItems for CustID 1 (Detail = 0; Set Detail = 1). Tests ALL valid input. Successful Transaction. Commit. Customer 1 #7
--------------------------------------------------------------------------------
';
EXECUTE Lab8proc 1, 5555, 1001, 10;  
PRINT ' '; PRINT ' '; PRINT ' ';


PRINT '
--------------------------------------------------------------------------------
DELETE: Order 6107 for CustID 1 FOR #7
--------------------------------------------------------------------------------
';
DELETE FROM ORDERITEMS WHERE OrderID = 5555 AND PartID = 1001;
DELETE FROM ORDERS WHERE OrderID = 5555;

PRINT '
--------------------------------------------------------------------------------
Tests ALL valid input and exhaust entire StockQty of 1001 Testing 0 left in StockQty. Successful Transaction. Commit. #5
--------------------------------------------------------------------------------
';
EXECUTE Lab8proc 1, 6099, 1001, 100; 
PRINT ' '; PRINT ' '; PRINT ' ';

PRINT '
--------------------------------------------------------------------------------
Tests ALL valid input and Test stock on hand not enough to fill order Transaction Failure. Rollback. #5
--------------------------------------------------------------------------------
';
EXECUTE Lab8proc 1, 6099, 1001, 200; 
PRINT ' '; PRINT ' '; PRINT ' ';

PRINT '
--------------------------------------------------------------------------------
Tests ALL valid input. Successful Transaction. Commit. Customer 1. #9
--------------------------------------------------------------------------------
';
EXECUTE Lab8proc 1, 6099, 1001, 15;  
PRINT ' '; PRINT ' '; PRINT ' ';

PRINT '
--------------------------------------------------------------------------------
Tests ALL valid input. Successful Transaction. Commit. Customer 2. #9
--------------------------------------------------------------------------------
';
EXECUTE Lab8proc 2, 6109, 1010, 15;  
PRINT ' '; PRINT ' '; PRINT ' ';


PRINT '
--------------------------------------------------------------------------------
UPDATE: Sets Part ID 1001 back to original StockQty Value.
--------------------------------------------------------------------------------
';
UPDATE INVENTORY
SET StockQty = 100
WHERE PartID = 1001;


PRINT '
--------------------------------------------------------------------------------
UPDATE: Sets Part ID 1010 back to original StockQty Value
--------------------------------------------------------------------------------
';
UPDATE INVENTORY
SET StockQty = 110
WHERE PartID = 1010;

END;

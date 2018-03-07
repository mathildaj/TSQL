

/*  TASK 01 */

Create Function GET_TITLE (@bookID int = null)
returns varchar(75)
with returns null on null input as
Begin
	declare @bookTitle as varchar(75)
	set @bookTitle = (select title from bk_books 
	where book_id = @bookID);

	return @bookTitle;

End; 


Go 

select dbo.GET_TITLE(1077) as Book_Title;

Go

/*  TASK 02 */

Create Function GET_BULK_DISCOUNT 
	(@orderQuantity as int,
	@orderPrice as decimal(6,2))
	
returns decimal(6,2)
with returns null on null input as
Begin
	declare @totalSales as decimal(6,2)
			
	
	if (@orderQuantity > 2)
		set @totalSales = (@orderPrice * @orderQuantity * 0.95)
						
	else
		set @totalSales = (@orderPrice * @orderQuantity)

	return @totalSales;

End; 

Go 

select od.book_id, dbo.GET_BULK_DISCOUNT(od.quantity, od.order_price)  as TotalPrice
from dbo.bk_order_details od
where od.order_id = 1028

Go


/*  TASK 03 */

/*step 1: create sequence */
CREATE SEQUENCE books_seq AS INT
 START WITH 2624
 INCREMENT BY 1
GO

/* step 2: create function */
Create Function VALID_PUBL
(@pubID int)
	
returns bit
with returns null on null input as
Begin
	declare @isValid as bit, /* 0 is False, 1 is True */
			@publisher as int
	set @publisher = (select publ_id from bk_publishers	
		where publ_id = @pubID)
	if (@publisher IS NULL)
		set @isValid = 0
	else
		set @isValid = 1

	return @isValid
End;

Go


CREATE PROCEDURE ADD_BOOK
	@bookTitle varchar(75),
	@pubID int,
	@year_publ int = 0, /*this value will be reset later to current year*/
	@isbn varchar(17),
	@pageCount int,
	@listPrice decimal(6,2) = 29.00
AS
BEGIN
	set @year_publ = (select year(getdate()))

	if (dbo.VALID_PUBL(@pubID) = 1)
		Insert into dbo.bk_books Values
		(NEXT VALUE FOR books_seq,
		 @bookTitle,
		 @pubID,
		 @year_publ,
		 @isbn,
		 @pageCount,
		 @listPrice)
	else
		PRINT('Not valid publisher ID: ' + convert(char(10), @pubID));

End
 
GO

Execute ADD_BOOK
	@bookTitle = "Big Littel Lies",
	@pubID = 1133,
	@isbn = 8934626,
	@pageCount = 298

Go	
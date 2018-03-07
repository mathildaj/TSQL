
/*  TASK 01 */

Declare @PublisherTableVar table (
   tb_publ_id           integer          not null
 , tb_publ_name         varchar(25)      not null  
 , primary key(tb_publ_id) 
 , check (tb_publ_id >1000)
 );

 Insert Into @PublisherTableVar
 Select * from dbo.bk_publishers;

 Select * from @PublisherTableVar; 

 GO
  

 /*  TASK 02 */

 Declare @EmpTableVar table (
	emp_id          int           not null  
  , name_last       varchar(25)      not null
  , name_first      varchar(25)      null
  , ssn             char(9)           not null  
  , emp_mng         int           null
  , dept_id         int           not null
  , hire_date       date              not null
  , salary          decimal (8, 2)     null
  , job_id          int           not null
  , primary key(emp_id)
  , check (emp_id >= 100) 
  , unique(ssn)
  , check(hire_date >= '1950-01-01')
  , check (salary >= 0)
 );

 Insert Into @EmpTableVar
 Select * from dbo.emp_employees;

 DECLARE @LoopCounter INT , @MaxEmployeeId INT, 
        @EmployeeName NVARCHAR(50);

 SELECT @LoopCounter = min(emp_id) , 
       @MaxEmployeeId = max(emp_id) 
 FROM @EmpTableVar;
 
 WHILE(@LoopCounter IS NOT NULL
      AND @LoopCounter <= @MaxEmployeeId)
 BEGIN
   SELECT @EmployeeName = name_first + ' ' + name_last
   FROM @EmpTableVar WHERE emp_id = @LoopCounter
    
   PRINT @EmployeeName  
   SELECT  @LoopCounter  = min(emp_id) FROM @EmpTableVar
   WHERE emp_id > @LoopCounter;        
END
GO 

 /*  TASK 03 */

 Declare @book_promo table(
    book_id           integer          not null
  , title             varchar(75)     not null 
  , publ_id           integer          null
  , year_publd        integer          not null
  , isbn              varchar(17)     null
  , page_count        integer          null  
  , old_list_price        decimal(6,2)      null 
  , new_list_price        decimal(6,2)      null 
  , primary key (book_id)
 
);
 
 /*Insert Into @book_promo
 Select * from dbo.bk_books;*/

 UPDATE TOP (5) dbo.bk_books  
 SET list_price = list_price * 1.20 
      
 OUTPUT inserted.book_id, 
		inserted.title, 
		inserted.publ_id,
		inserted.year_publd,
		inserted.isbn,
		inserted.page_count,
		deleted.list_price,
		inserted.list_price
 INTO @book_promo;  

 --Display the result set of the table variable.  
 SELECT *  
 FROM @book_promo;  
 GO  

 --Display the result set of the table.  
SELECT TOP (5) * from dbo.bk_books;  
GO 

 
 /*  TASK 04 */

 Declare @BookOrderDetailsTableVar table (
    order_id          integer          not null 
  , book_id           integer          not null 
  , total       decimal(10,2)     not null   
 );


 Insert Into @BookOrderDetailsTableVar
 Select order_id, book_id,  order_price * quantity from dbo.bk_order_details;

 --Display the result set of the table variable.  
SELECT * 
FROM @BookOrderDetailsTableVar;  
GO  
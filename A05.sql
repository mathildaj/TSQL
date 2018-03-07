

/*  TASK 01 */

Declare @DeptTableVar table (
	tb_dept_id integer not null
,	tb_dept_name varchar(50) not null
);

Insert into @DeptTableVar
Select dept_id, dept_name from dbo.emp_departments
where dept_id like '%0';

Select tb_dept_name from @DeptTableVar;

Go 


/*  TASK 02 */

Create Procedure [dbo].[updateSalary_2]
	@dept_id int --parameter
AS
BEGIN
	Declare @emp_raise table (
		emp_id int not null
	,	emp_lname varchar(25) not null
	,	emp_fname varchar(25) not null
	,	old_emp_sal	decimal(8,2)	null
	,	new_emp_sal decimal(8,2)	null 
	);

	--only update if dept_id is in this list, else, raise an error
	IF (@dept_id not in  (20,80,90,95,215))
	BEGIN
		RAISERROR('Invalid parameter: @dept_id', 18, 0)
		RETURN
	END

	Update dbo.emp_employees 
	Set salary = ( CASE
					When salary > 120000 Then salary * 1.03
					When salary > 95000 Then salary * 1.08
					When salary > 65000 Then salary * 1.15
					When salary <= 65000 Then salary * 1.20
					Else salary
				 End )
		
	OUTPUT inserted.emp_id,
		   inserted.name_last,
		   inserted.name_first,
		   deleted.salary,
		   inserted.salary
	INTO @emp_raise
	Where dept_id  = @dept_id;

		--display the updated results using xml
	/*DECLARE @xmltmp xml = (SELECT emp_lname + emp_fname as EmpName FROM @emp_raise FOR XML AUTO)
	PRINT CONVERT(NVARCHAR(MAX), @xmltmp)*/

	---display the updated results using loop
	DECLARE @LoopCounter INT , @MaxEmployeeId INT, 
        @EmployeeName NVARCHAR(50);

	SELECT @LoopCounter = min(emp_id) , 
       @MaxEmployeeId = max(emp_id) 
	FROM @emp_raise;
 
	 WHILE(@LoopCounter IS NOT NULL
		  AND @LoopCounter <= @MaxEmployeeId)
	 BEGIN
	   SELECT @EmployeeName = emp_fname + ' ' + emp_lname
	   FROM @emp_raise WHERE emp_id = @LoopCounter
    
	   PRINT @EmployeeName  

	   SELECT  @LoopCounter  = min(emp_id) FROM @emp_raise
	   WHERE emp_id > @LoopCounter;        
	END

END


 
 Go 

execute [dbo].[updateSalary_2] @dept_id = 20; 

GO


/*
drop Procedure [dbo].[updateSalary_2]
*/

/* Task 03 */

create table flight(flightno int primary key, seats int);
insert into flight values (101, 1);
insert into flight values (102, 1);

 

GO 

--First transaction

Create Procedure [dbo].[book_seats]
	@flight_num	int,
	@seat_requested int

AS

BEGIN
	Declare @total_seats int;
			
	Begin Transaction
		--check flight num
		IF (@flight_num) NOT IN (select flightno from flight)
		Begin
			-- Rollback the transaction
			ROLLBACK Transaction

			-- Raise an error and return
			RAISERROR ('No such flight', 16, 1)
			RETURN
		End	

		--update seats being reserved
		Update flight
		Set seats = seats + @seat_requested
		Where flightno = @flight_num;

		--if error occurs in the update
		IF (@@ERROR <> 0)
		BEGIN
			-- Rollback the transaction
			ROLLBACK Transaction

			-- Raise an error and return
			RAISERROR ('Error updating seats', 16, 1)
			RETURN
		END

		--if total seats greater than 555, roll back transaction
		Set @total_seats = (Select seats from flight Where flightno = @flight_num);
		If (@total_seats > 555 OR @@ERROR <> 0)
		BEGIN
			-- Rollback the transaction
			ROLLBACK Transaction

			-- Raise an error and return
			RAISERROR ('Exceed max seats', 16, 1)
			RETURN
		END

	Commit Transaction
End	--end of procedure



Go 


exec book_seats @flight_num = 101,
	@seat_requested = 600 

GO

----Second transaction

Create Procedure [dbo].[book_seats_premier]
	@diamond_num int,
	@flight_num	int,
	@seat_requested int

AS

BEGIN
	Declare @total_seats int;
			
	Begin Transaction

		--check diamond num
		IF (@diamond_num <= 0)
		Begin
			-- Rollback the transaction
			ROLLBACK Transaction

			-- Raise an error and return
			RAISERROR ('No such diamond number', 16, 1)
			RETURN
		End	

		--check flight num
		IF (@flight_num) NOT IN (select flightno from flight)
		Begin
			-- Rollback the transaction
			ROLLBACK Transaction

			-- Raise an error and return
			RAISERROR ('No such flight', 16, 1)
			RETURN
		End	

		--update seats being reserved
		Update flight
		Set seats = seats + @seat_requested
		Where flightno = @flight_num;

		--if error occurs in the update
		IF (@@ERROR <> 0)
		BEGIN
			-- Rollback the transaction
			ROLLBACK Transaction

			-- Raise an error and return
			RAISERROR ('Error updating seats', 16, 1)
			RETURN
		END

		--if total seats greater than 555, roll back transaction
		Set @total_seats = (Select seats from flight Where flightno = @flight_num);
		If (@total_seats > 560 OR @@ERROR <> 0)
		BEGIN
			-- Rollback the transaction
			ROLLBACK Transaction

			-- Raise an error and return
			RAISERROR ('Exceed max seats for diamond customers', 16, 1)
			RETURN
		END

	Commit Transaction
End	--end of procedure

GO

exec book_seats_premier @diamond_num = 1, @flight_num = 101,
	@seat_requested = 600 

GO

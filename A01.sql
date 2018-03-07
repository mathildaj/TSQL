
---------use this to comment out everything before the store procedure credit_limit

/*  TASK 00 */
select SYSDATETIME(), user;


/*  TASK 01 */
BEGIN 
	Select 'Hello World';
END 


/*  TASK 02  */

BEGIN
	DECLARE @v_num int = 1,
			@v_char char(1) = 'A';
	select 'Original @v_num = ' + cast(@v_num as varchar);
	select 'Original @v_char = ' + @v_char; 
	
	SET @v_num = 2;
	SET	@v_char = 'B';

	select 'The new @v_num = ' + cast(@v_num as varchar);
	select 'The new @v_char = ' + @v_char; 
	
END 


/*  TASK 03 */

BEGIN
	DECLARE @salary Decimal(8,2);
	SET @salary = (Select salary from emp_employees where emp_id = 145);
	Select @salary as 'salary';
		
END


/*  TASK 04 */

BEGIN
	DECLARE @it_emp_count int,
			@emp_count int,
			@total_cost int;

	SET @it_emp_count = (Select count(emp_id) from emp_employees e, emp_departments d
						where dept_name = 'IT Support'
						and e.dept_id = d.dept_id);

	SET @emp_count = (select count(emp_id) from emp_employees);

	SET @total_cost = @emp_count * 150 + @it_emp_count * 100;

	Select @it_emp_count as 'back_stage_pass_count', @emp_count as 'total_ticket_count',
		@total_cost as 'total_cost';
END

----------use this to comment out everything before the stored procedure credit_limit 


/*  TASK 05 */

/*--the following create proc block needs to be run separately, not as
  --part of the entire script file. */
   
CREATE PROC credit_limit
	@cust_id int  --parameter
AS
BEGIN
	DECLARE @credit_limit int;
	SET @credit_limit = (Select customer_credit_limit from cust_customers
		where customer_id = @cust_id);

	Select @credit_limit as 'credit limit';

END;  
GO 

EXEC credit_limit @cust_id = 400300;




/*  TASK 1 */
/*Write a T-SQL block that will display all employees in the IT Support 
department (you can use dept_id 210 and 215) using a cursor WHILE loop. */

DECLARE @eid int, @lname VARCHAR(25), @fname VARCHAR(25), @did int;

DECLARE Employee_Cursor CURSOR FOR
Select emp_id, name_last, name_first, dept_id from dbo.emp_employees
Where dept_id = 210 OR dept_id = 215;

OPEN Employee_Cursor
FETCH NEXT FROM Employee_Cursor INTO @eid, @lname, @fname, @did
WHILE @@FETCH_STATUS = 0
BEGIN
	Select @eid as "Emp ID", @lname as "Last Name", 
	@fname as "First Name", @did as "Department ID"
	FETCH NEXT FROM Employee_Cursor INTO @eid, @lname, @fname, @did
END

CLOSE Employee_Cursor;
DEALLOCATE Employee_Cursor;

GO 

/* TASK 2 */
/* Create a T-SQL Procedure to calculate bonuses */

CREATE Procedure [dbo].[calculateBonus]
	@sales_target decimal(10,2) --parameter 
AS
BEGIN
	Declare @sales_amt decimal(10,2), @total_sales decimal(10,2);
	DECLARE @j_id int,
			@e_id int,
			@sal_adj_rate decimal(3,2),
			@salary decimal(10,2),
			@new_salary decimal(10,2);

	set @total_sales = (select sum(quantity_ordered * quoted_price)
	from oe_orderDetails, oe_orderHeaders
	where oe_orderDetails.order_id = oe_orderHeaders.order_id
	and year(order_date) = 2015);

	IF (@total_sales >= @sales_target)
	BEGIN
		Declare sales_cursor CURSOR FOR
		select job_id, emp_id, salary
		from emp_employees
		where dept_id = 80 --sales department

		OPEN sales_cursor;
		FETCH NEXT FROM sales_cursor INTO @j_id, @e_id, @salary;
		WHILE @@FETCH_STATUS = 0
			BEGIN
			
				IF @j_id = 1 --president
					SET @sal_adj_rate = 1.10;
				ELSE IF @j_id = 4 -- sales manager
					SET @sal_adj_rate = 1.15;
				ELSE IF @j_id = 8 --sales rep
					SET @sal_adj_rate = 1.20;
				ELSE
					SET @sal_adj_rate = 1.00;
				
				Set @new_salary = @salary * @sal_adj_rate;
				Select @e_id as "Emp ID", @salary as "Old Salary", 
				@new_salary as "New Salary"

			FETCH NEXT FROM sales_cursor INTO  @j_id, @e_id, @salary;
			END
		Close sales_cursor;
		Deallocate sales_cursor;
	

	END
END

GO

EXEC calculateBonus @sales_target = 50000.00;



/* TASK 3 */

/* Please NOTE!!: in the original sql create script provided by the professor,
it has a constrain called order_mode_value, which defines the order_mode value has to be one of
the following: DIRECT, ONLINE, PHONE.
It creates conflicts with this task.

So I drop this constrain here in order to make the task work.

Please DO drop the constrain, or task 3 will not work.
*/
ALTER TABLE oe_orderHeaders DROP CONSTRAINT ord_mode_values;

/*Write a T-SQL block that uses a cursor to update the order_mode column as follows:

DIRECT should be replaced with SALES REP */

DECLARE @oid int;

DECLARE order_cursor CURSOR FOR
Select order_id from oe_orderHeaders
where order_mode = 'DIRECT';

OPEN order_cursor
FETCH NEXT FROM order_cursor INTO @oid
WHILE @@FETCH_STATUS = 0
BEGIN
	Update oe_orderHeaders
	Set order_mode = 'SALES REP'
	where order_id = @oid
	FETCH NEXT FROM order_cursor INTO @oid
END

CLOSE order_cursor;
DEALLOCATE order_cursor;

GO 

/* display after the update */
select order_id, order_mode from oe_orderHeaders
where order_mode = 'SALES REP';




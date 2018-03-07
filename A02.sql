
/*  TASK 1 */
--if already exists, need to drop first
-- procedure [dbo].[updateSalary]
--GO
CREATE PROCEDURE [dbo].[updateSalary]
	@empolyee_id int --paramater
AS
BEGIN
	DECLARE @j_id int,
			@sal_adj_rate decimal(3,2),
			@new_salary decimal(8,2);

	SET @j_id = (Select job_id from emp_employees
	where emp_id = @empolyee_id);

	IF @j_id = 1 --president
		SET @sal_adj_rate = 1.10;
	ELSE IF @j_id = 4 -- sales manager
		SET @sal_adj_rate = 1.15;
	ELSE IF @j_id = 8 --sales rep
		SET @sal_adj_rate = 1.20;
	ELSE
		SET @sal_adj_rate = 1.00;

	Update emp_employees
	Set salary = salary * @sal_adj_rate
	Where emp_employees.emp_id = @empolyee_id;

	Set @new_salary = (Select salary from emp_employees
	Where emp_employees.emp_id = @empolyee_id);

	PRINT('Employee: ' + convert(char(10), @empolyee_id)
+ ' has a new salary of: ' + convert(char(10), @new_salary));
		
END
 
GO

EXEC updateSalary @empolyee_id = 100;


/*  TASK 2 */
BEGIN
	SELECT order_id, 
		(CASE
			WHEN order_status = 1 THEN 'Received'
			WHEN order_status = 2 THEN 'Processed'
			WHEN order_status = 3 THEN 'Shipped'
			WHEN order_status = 4 THEN 'Delivered'
			WHEN order_status = 5 THEN 'Back_ordered'
			WHEN order_status = 7 THEN 'Canceled'
			WHEN order_status = 9 THEN 'Returned'
			ELSE 'Order Status'
		END) AS Description 
	FROM oe_orderHeaders;
END
GO


/*  TASK 3 */

BEGIN
	DECLARE @election_year int,
			@counter int,
			@gap int;
	SET @election_year = 2020;
	SET @counter = 10;
	SET @gap = @election_year - convert(int, year(getdate()));

	PRINT('The election year 2020 is ' + convert(char(1), @gap)
+ ' years from now');

	WHILE @counter > 0
		BEGIN
			PRINT(@counter);
			SET @counter = @counter -1;
		END

	PRINT('The year is now ' + convert(char(4), @election_year));

END

GO

/*  TASK 4 */

BEGIN
	DECLARE @lname varchar(25), 
			@fname varchar(25), 
			@counter int, 
			@rand_add int,
			@maxcounter int;
	SET @counter = (SELECT MIN(emp_id) FROM emp_employees);
	--SET @counter = 100;
	SET @maxcounter = (SELECT MAX(emp_id) FROM emp_employees);
	
	WHILE @counter < @maxcounter
		BEGIN
			--the range between min_emp_id to max_emp_id is 1-107
			SET @rand_add = (Select RAND() * (107-1) + 1); 
			--SET @rand_add = 1; 
			SET @counter = @counter + @rand_add;

			IF exists(select emp_id from emp_employees where emp_id = @counter)
				BEGIN
					SET @lname = (select name_last from emp_employees where emp_id = @counter);
					SET @fname = (select name_first from emp_employees where emp_id = @counter);
					PRINT('The winner is: ' + @fname + ' ' + @lname);
					BREAK;
				END
			ELSE
				BEGIN
					PRINT('');
					PRINT('Not a winner! Continue!');
				END
		
		END
END
GO

CREATE PROCEDURE FormEmployeeData as 
begin
    delete from [dbo].[Employees];
    with TempEmployee as (
        select UPPER(LEFT(concat(ISNULL(Name, ''), ISNULL(FirstName, '')),1))+LOWER(SUBSTRING(concat(ISNULL(Name, ''), ISNULL(FirstName, '')),2,LEN(concat(ISNULL(Name, ''), ISNULL(FirstName, ''))))) as Name, PhoneNumber, left(ZipCode, 5) as ZipCode, Date from EmployeesJsonData
    ),
    TempEmployeeJoined as (
        select Name, max(PhoneNumber) as PhoneNumber, max(ZipCode) as ZipCode, max(Date) as Date from TempEmployee group by Name
    )
    Insert into Employees (ID, Name, PhoneNumber, EmailAddress, ZipCode, State, Date)
    select newID() as ID, t.Name, format(t.PhoneNumber, '(000)-000-0000'), concat(lower(Name), 'genericdomain.com') as EmailAddress, t.ZipCode, z.State, DATEADD(S, CONVERT(int,LEFT(t.Date, 10)), '1970-01-01') as Date from TempEmployeeJoined t 
    left join ZipCodeData z on t.ZipCode = z.ZipCode
end

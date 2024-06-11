--1.List all the sales orders from the table with general sales order information, 
--including the customer name(first name + last name), order date, and the total order amount.
select (p.FirstName+' '+p.LastName) as CustomerName, soh.OrderDate, sum(sod.LineTotal) totalorderamount
from Sales.SalesOrderHeader soh
join Sales.SalesOrderDetail sod on soh.SalesOrderID = sod.SalesOrderID
join person.Person p on soh.CustomerID = p.BusinessEntityID
group by p.FirstName,p.LastName,soh.OrderDate

--2.Find all products that have never been sold.
select ProductID,[Name] from Production.Product 
where ProductID not in(select ProductID from sales.SalesOrderDetail)

--3.Retrieve the names and list prices of all products that cost more than $100.
select [Name], ListPrice from Production.Product
where ListPrice > 100

--4.Combine the list of vendors and customers into a single result set with their names and phonenumber.
select p.FirstName +' '+ p.LastName as name,ph.PhoneNumber 
from person.Person p
join person.PersonPhone ph on p.BusinessEntityID = ph.BusinessEntityID
where PersonType = 'VC'
UNION
select FirstName +'  '+ LastName as name,ph.PhoneNumber
from person.Person p
join person.PersonPhone ph on p.BusinessEntityID = ph.BusinessEntityID
where PersonType = 'IN'

--5.Find all employees who are not assigned to any department.
--MEHTOD 1
select e.BusinessEntityID, dh.DepartmentID
from HumanResources.Employee e
left join HumanResources.EmployeeDepartmentHistory dh on e.BusinessEntityID = dh.BusinessEntityID
where dh.DepartmentID is null

--MEHTOD 2
select BusinessEntityID from HumanResources.Employee
where BusinessEntityID not  in(select BusinessEntityID from HumanResources.EmployeeDepartmentHistory)
--THERE IS NO EMPLOYEE WITHOUT A DEPARTMENT 

--6.Find the total sales amount for each sales territory.
select st.[Name] as Territory, sum(sod.LineTotal) as Totalsalesamount
from Sales.SalesTerritory st
join Sales.SalesOrderHeader soh on st.TerritoryID = soh.TerritoryID
join sales.SalesOrderDetail sod on soh.SalesOrderID = sod.SalesOrderID
group by st.Name

--7 List all sales territories with total sales greater than $1,000,000.
select st.[Name] as Territory, sum(sod.LineTotal) as Totalsalesamount
from Sales.SalesTerritory st
join Sales.SalesOrderHeader soh on st.TerritoryID = soh.TerritoryID
join sales.SalesOrderDetail sod on soh.SalesOrderID = sod.SalesOrderID
group by st.Name
having sum(sod.LineTotal) > 1000000

--8.Retrieve the top 5 most expensive products, show customers that can afford them .
select top 5 [Name] as Products, ListPrice  from production.product
order by ListPrice desc

select pd.Name as Products, pd.ListPrice, p.FirstName + ' '+ p.LastName as Customers
from Sales.SalesOrderHeader soh
join Sales.SalesOrderDetail sod on soh.SalesOrderID = sod.SalesOrderID
join person.person p on soh.CustomerID = p.BusinessEntityID
join production.Product pd on sod.ProductID = pd.ProductID
where pd.Name in('Road-150 Red, 62','Road-150 Red, 44','Road-150 Red, 48','Road-150 Red, 52','Road-150 Red, 56')
order by pd.ListPrice desc

--9.Find all customers who made a purchase in the last 30 days.

select soh.CustomerID, p.FirstName + ' '+p.LastName as Customers, soh.OrderDate
from  sales.SalesOrderHeader soh
join sales.Customer sc on soh.CustomerID =sc.CustomerID
join Person.Person p on sc.CustomerID = p.BusinessEntityID
where soh.OrderDate  >= DATEADD(DAY,-30,OrderDate)
order by OrderDate desc

--10. Identify employees who have been involved in more than 5 distinct sales orders.
select e.BusinessEntityID, p.FirstName + ' ' + p.LastName as EmployeeName,
count(distinct soh.SalesOrderID) as NumberOfSalesOrders
from Sales.SalesOrderHeader soh
join HumanResources.Employee e on soh.SalesPersonID = e.BusinessEntityID
join  Person.Person p ON e.BusinessEntityID = p.BusinessEntityID
group by e.BusinessEntityID, p.FirstName, p.LastName
having count(distinct soh.SalesOrderID) > 5
order by NumberOfSalesOrders desc;

--11. List the total sales amount for each sales territory, including the territory name.
select st.Name as TerritoryName, sum(soh.TotalDue) as TotalSalesAmount
from sales.salesorderheader soh
join Sales.SalesTerritory as st on soh.TerritoryID = st.TerritoryID
group by st.Name
order by TotalSalesAmount desc;

--12.Find the total sales amount for each customer,including their name and the number of orders they have placed.
select p.FirstName+ ' '+p.LastName as Customer, sum(sod.LineTotal) as Totalsalesamount,sum(sod.OrderQty) as totalorders
from Sales.SalesOrderHeader soh
join sales.SalesOrderDetail sod on soh.SalesOrderID = sod.SalesOrderID
join Person.Person p on soh.CustomerID = p.BusinessEntityID
group by p.FirstName+ ' '+p.LastName
order by Totalsalesamount desc

--13. Identify the top 3 sales representatives with the highest total sales amount
select  top 3 p.FirstName+ ' '+p.LastName as Salesrepname, sum(soh.TotalDue) as Totalsales	
from person.Person p
join sales.SalesOrderHeader soh on p.BusinessEntityID = soh.SalesPersonID
join Sales.SalesOrderDetail sod on soh.SalesOrderID = sod.SalesOrderID
group by  p.FirstName+ ' '+p.LastName
order by sum(soh.TotalDue) desc

--14. Retrieve all products that are either in the "Bikes" category or have a standard cost greater than $1000.
SELECT ProductID, Name, StandardCost 
FROM Production.Product
WHERE ProductSubcategoryID IN (SELECT ProductSubcategoryID FROM Production.ProductSubcategory WHERE Name LIKE '%Bike%')
or  StandardCost > 1000;

--15. List all employees who have sold more than the average sales amount
select e.BusinessEntityID, p.FirstName + ' ' +p.LastName as EmployeeName, sum(soh.TotalDue) as TotalSales
from Sales.SalesOrderHeader soh
join HumanResources.Employee e on soh.SalesPersonID = e.BusinessEntityID
join Person.Person p on e.BusinessEntityID = p.BusinessEntityID
group by e.BusinessEntityID, p.FirstName, p.LastName
having sum(soh.TotalDue) > (select avg(TotalDue) from Sales.SalesOrderHeader);










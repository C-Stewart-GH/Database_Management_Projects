use SalesOrdersExampleTest;

Create view SalesOrders_Joined as
SELECT `Customers`.`CustomerID`,
    `Customers`.`CustFirstName`,
    `Customers`.`CustLastName`,
	`Orders`.`OrderNumber`,
    `Products`.`ProductNumber`,
    `Products`.`ProductName`,
    `Products`.`ProductDescription`,
	`Categories`.`CategoryID`,
    `Categories`.`CategoryDescription`
from ((((Customers
		left join Orders
		ON Customers.CustomerID = Orders.CustomerID)
			left join Order_Details
			ON Orders.OrderNumber = Order_Details.OrderNumber)
				left join Products
				ON Order_Details.ProductNumber = Products.ProductNumber)
					left join Categories
					ON Products.CategoryID = Categories.CategoryID);

Create view Vendors_Joined as
SELECT `Products`.`ProductNumber`,
    `Products`.`ProductName`,
    `Products`.`ProductDescription`,
	`Categories`.`CategoryID`,
    `Categories`.`CategoryDescription`,
    `Product_Vendors`.`VendorID`,
    `Vendors`.`VendName`
        from (((Products
					left join Categories
					ON Products.CategoryID = Categories.CategoryID)
						left join Product_Vendors
						ON Products.ProductNumber = Product_Vendors.ProductNumber)
							left join Vendors
							ON Product_Vendors.VendorID = Vendors.VendorID);
							

/* 1.	Display the customers who have never ordered bikes or tires.
distinct CustomerID, CustFirstName, CustLastName */
    
select distinct CustomerID, CustFirstName, CustLastName
from Customers
where CustomerID not in
	(select distinct CustomerID
	from salesorders_joined
	where CategoryDescription IN ("Bikes", "Tires"));

/* 2.	List the customers who have purchased a bike but not a helmet. 
Assuming Dog Ear Helmet Mount Mirrors is not a Helmet*/
       
select distinct CustomerID, CustFirstName, CustLastName
	from salesorders_joined
	where CategoryDescription = "Bikes" and CustomerID not in
		(select distinct CustomerID
        from salesorders_joined
        where ProductName like "%Helmet");

/* 3.	Show me the customer orders that have a bike but do not have a 
helmet. Hint: This might seem to be the same as problem 2 above, but it 
is not. Solve it using EXISTS and NOT EXISTS. Assuming Dog Ear Helmet 
Mount Mirrors is not a Helmet*/
        
select distinct OrderNumber
	from salesorders_joined oq
	where NOT EXISTS
			(select OrderNumber
			from salesorders_joined iq
			where ProductName like "%Helmet"
			and iq.OrderNumber=oq.OrderNumber)
        AND EXISTS
			(select OrderNumber
			from salesorders_joined iqq
			where CategoryDescription = "Bikes"
			and iqq.OrderNumber=oq.OrderNumber);


/* 4.	Display the customers and their orders that have a bike and a helmet 
in the same order. Hint: Solve this problem using EXISTS*/

select distinct OrderNumber, CustomerID, CustFirstName, CustLastName
	from salesorders_joined oq
	where EXISTS
			(select OrderNumber
			from salesorders_joined iq
			where ProductName like "%Helmet"
			and iq.OrderNumber=oq.OrderNumber)
        AND EXISTS
			(select OrderNumber
			from salesorders_joined iqq
			where CategoryDescription = "Bikes"
			and iqq.OrderNumber=oq.OrderNumber);

/* 5.	Show the vendors who sell accessories, car racks, and clothing. 
Hint: Solve this problem using IN. */

select Distinct VendorID, VendName
from Vendors_Joined oq
where VendorID IN
	(select VendorID
	from Vendors_Joined iq
	where CategoryDescription in ("accessories")
	and iq.VendorID=oq.VendorID)
and  VendorID IN
	(select VendorID
	from Vendors_Joined iqq
	where CategoryDescription in ("car racks")
	and iqq.VendorID=oq.VendorID)
and VendorID IN
	(select VendorID
	from Vendors_Joined iqqq
	where CategoryDescription in ("clothing")
	and iqqq.VendorID=oq.VendorID);




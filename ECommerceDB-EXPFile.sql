create database ecommerceDB;
use ecommerceDB;

drop table Supplier;
drop table Customer;
drop table Category;
drop table Product;
drop table ProductDetails;
drop table Orders;
drop table Rating;

create table supplier(
SUPP_ID int,
SUPP_NAME varchar(50),
SUPP_CITY varchar(50),
SUPP_PHONE bigint
);

create table Customer(
CUS_ID int,
CUS_NAME varchar(50),
CUS_PHONE bigint,
CUS_CITY varchar(50),
CUS_GENDER varchar(10)
);

create table Category(
CAT_ID int,
CAT_NAME varchar(50)
);

create table Product(
PRO_ID int,
PRO_NAME varchar(50),
PRO_DESC varchar(50),
CAT_ID int
);

create table ProductDetails(
PROD_ID int,
PRO_ID int,
SUPP_ID int,
PRICE bigint
);

create table Orders(
ORD_ID int,
ORD_AMOUNT bigint,
ORD_DATE varchar(50),
CUS_ID int,
PROD_ID int
);

create table Rating(
RAT_ID int,
CUS_ID int,
SUPP_ID int,
RAT_RATSTARS int
);

insert into Supplier (SUPP_ID, SUPP_NAME, SUPP_CITY, SUPP_PHONE)
values
(1, 'Rajesh Retails', 'Delhi', 1234567890),
(2, 'Appario Ltd.', 'Mumbai', 2589631470),
(3, 'Knome products', 'Banglore',	9785462315),
(4, 'Bansal Retails', 'Kochi', 8975463285),
(5, 'Mittal Ltd.', 'Lucknow', 7898456532)
;

insert into Customer (CUS_ID, CUS_NAME, CUS_PHONE, CUS_CITY, CUS_GENDER)
values
(1, 'AAKASH', 9999999999, 'DELHI', 'M'),
(2, 'AMAN', 9785463215,	'NOIDA', 'M'),
(3, 'NEHA', 9999999999,	'MUMBAI', 'F'),
(4, 'MEGHA' , 9994562399, 'KOLKATA', 'F'),
(5, 'PULKIT', 7895999999, 'LUCKNOW', 'M')
;
insert into Category (CAT_ID, CAT_NAME)
values
(1, 'BOOKS'),
(2, 'GAMES'),
(3, 'GROCERIES'),
(4, 'ELECTRONICS'),
(5, 'CLOTHES')
;

insert into Product (PRO_ID, PRO_NAME, PRO_DESC, CAT_ID)
values
(1, 'GTA V', 'DFJDJFDJFDJFDJFJF', 2),
(2, 'TSHIRT', 'DFDFJDFJDKFD', 5),
(3, 'ROG LAPTOP', 'DFNTTNTNTERND', 4),
(4, 'OATS', 'REURENTBTOTH', 3),
(5, 'HARRY POTTER', 'NBEMCTHTJTH', 1)
;

insert into ProductDetails (PROD_ID, PRO_ID, SUPP_ID, PRICE)
values
(1,	1, 2, 1500),
(2,	3, 5, 30000),
(3,	5, 1, 3000),
(4,	2, 3, 2500),
(5,	4, 1, 1000)
;

insert into Orders (ORD_ID, ORD_AMOUNT, ORD_DATE, CUS_ID, PROD_ID)
values
(20, 1500,  '2021-10-12', 3, 5),
(25, 30500, '2021-09-16', 5, 2),
(26, 2000,  '2021-10-05', 1, 1),
(30, 3500,  '2021-08-16', 4, 3),
(50, 2000,  '2021-10-06', 2, 1)
;

insert into Rating (RAT_ID, CUS_ID, SUPP_ID, RAT_RATSTARS)
values
(1, 2, 2, 4),
(2, 3, 4, 3),
(3, 5, 1, 5),
(4, 1, 3, 2),
(5, 4, 5, 4)
;


select * from Supplier;
select * from Customer;
select * from Category;	
select * from Product;
select * from ProductDetails;
select * from Orders;	
select * from Rating;




select cus_gender, count(c.cus_id) 
from customer c 
inner join orders o on o.cus_id = c.cus_id 
where ORD_AMOUNT >= 3000 group by cus_gender;


select o.ord_id, pr.pro_name, o.ord_amount, o.ord_date, o.cus_id, pd.prod_id 
from orders o inner join ProductDetails pd on pd.prod_id = o.prod_id 
inner join product pr on pr.pro_id = pd.pro_id
where o.cus_id = 2;


select s.supp_id as 'Supplier Id', s.supp_name as 'Supplier Name', s.supp_city as 'City', s.supp_phone as 'Phone', count(pd.prod_id) as 'No of Products'
from supplier s
inner join ProductDetails pd on pd.supp_id = s.supp_id
group by pd.supp_id
having count(pd.prod_id) > 1
order by count(pd.prod_id);


select c.*, pr.pro_name, o.ord_amount
from category c
inner join product pr on pr.cat_id = c.cat_id
inner join ProductDetails pd on pd.pro_id = pr.pro_id
inner join orders o on o.prod_id = pd.prod_id
having min(o.ord_amount);


select o.ord_id as 'Order ID', pr.pro_id as 'Product ID', pr.pro_name as 'Product Name'
from orders o
inner join ProductDetails pd on pd.prod_id = o.prod_id
inner join product pr on pr.pro_id = pd.pro_id
where o.ord_date > '2021-10-05';


select cus_name as 'Customer Name', cus_gender as 'Gender'
from customer
where cus_name like 'A%' or cus_name like '%A';





CREATE DEFINER=`root`@`localhost` PROCEDURE `group_suppliers`()
BEGIN
	select supplier.supp_id, supplier.supp_name, rating.rat_ratstars,
    case
		when rating.rat_ratstars > 4 then 'Genuine Supplier'
        when rating.rat_ratstars > 2 then 'Average Supplier'
        else 'Supplier should not be Considered'
	end as verdict
    from rating
    inner join supplier on supplier.supp_id=rating.supp_id
    order by rating.rat_ratstars desc;
END

call group_suppliers();

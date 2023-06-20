--- This script creates two users, "usr_opr" and "usr_des", each with their own password

CREATE USER usr_opr IDENTIFIED BY "usr_opr_password";

CREATE USER usr_des IDENTIFIED BY "usr_des_password";


-------------------------------------------------------------------------------------------------------------------------------------------------
---------------- creating the operational database-------------------------------------
-

-- Create indexes                                                                 
create index idx_customer5_name on Customers5(name);
create index idx_product5_name on Products5(name);                                     
create index idx_sale_date on Sales(sale_date);

-- Create views 

create view vw_customer5_sales as
select c.name as customer_name, p.name as product, s.quantity, s.sale_date
from Customers5 c
join Sales s on c.customer_id = s.customer_id
join Products5 p on s.product_id = p.product_id;

-- Create procedures 
create procedure sp_update_product5_price (p_product_id number, p_new_price number)
as
begin
update Products5
set price = p_new_price
where product_id = p_product_id;
end;
/

-- Create triggers 
create trigger trg_update_inventory
before insert or update on Sales
for each row
begin
update Inventory
set quantity = quantity - :new.quantity
where product_id = :new.product_id;
end;
/

create table performance_log (
  log_id number primary key,
  log_time timestamp not null,
  log_message varchar(255) not null
);

---------------------------------------------------------------------------------------------------------------------------------------------------------
--script for creating the decisional database 


-- Create Customers_Analysis table
CREATE TABLE Customers_Analysis AS
SELECT customer_id, name, address, SUM(quantity) as total_quantity, SUM(quantity*price) as total_sales
FROM Customers5
JOIN Sales ON Customers5.customer_id = Sales.customer_id
GROUP BY customer_id, name, address;

-- Create the Products_Analysis table
CREATE TABLE Products_Analysis AS
SELECT product_id, name, SUM(quantity) as total_quantity, SUM(quantity*price) as total_sales
FROM Products5
JOIN Sales ON Products5.product_id = Sales.product_id
GROUP BY product_id, name;

-- Create the Sales_Analysis table
CREATE TABLE Sales_Analysis AS
SELECT sale_id, customer_id, product_id, SUM(quantity) as total_quantity, SUM(quantity*price) as total_sales
FROM Sales
GROUP BY sale_id, customer_id, product_id;


CREATE OR REPLACE PROCEDURE insert_data_into_tables AS
BEGIN
  INSERT INTO Customers5 (customer_id, name, address, contact_number)
  VALUES (1, 'Ram', '123 Main St', '45622524255');

  INSERT INTO Products5 (product_id, name, description, price)
  VALUES (1, 'Product A', 'Description of Product A', 12);

  INSERT INTO Sales (sale_id, customer_id, product_id, quantity, sale_date)
  VALUES (1, 1, 1, 2, '01-JAN-2021');

  -- Insert data into the Inventory table
  INSERT INTO Inventory (product_id, quantity, location)
  VALUES (1, 100, 'Warehouse A');

  COMMIT;
END;

BEGIN
    insert_data_into_tables;
END;


__________________________________________________________________________________________________________________________________________________
-------Assigning roles and privileges to users-----

-- Assign the CONNECT role
GRANT CONNECT TO usr_opr;
GRANT CONNECT TO usr_des;
-- Assign the CREATE SESSION 
GRANT CREATE SESSION TO usr_opr;
GRANT CREATE SESSION TO usr_des;
-- Assign the SELECT privilege 
GRANT SELECT ON Customers TO usr_opr;
GRANT SELECT ON Customers TO usr_des;
-- Assign the INSERT privilege 
GRANT INSERT ON Sales TO usr_opr;
GRANT INSERT ON Sales TO uusr_des;
-- Assign the UPDATE privilege 
GRANT UPDATE ON Inventory TO usr_opr;
GRANT UPDATE ON Inventory TO usr_des;



----------------------------------------------------------------------------------------------------
----------------------script to create a small dataset for  'usr_opr' ------------------------------ 

-create table usr_opr.Customers5 (
  customer_id number primary key,
  name varchar(50) not null,
  address varchar(100) not null,
  contact_number varchar(20) not null
);

-- Create Products5 table
create table usr_opr.Products5 (
  product_id number primary key,
  name varchar(50) not null,
  description varchar(255) not null,
  price number not null
);

-- Create Sales table
create table usr_opr.Sales (
  sale_id number primary key,
  customer_id number not null,
  product_id number not null,
  quantity number not null,
  sale_date date not null,
  foreign key (customer_id) references usr_opr.Customers5(customer_id),
  foreign key (product_id) references usr_opr.Products5(product_id)
);

-- Create Inventory table
create table usr_opr.Inventory (
  product_id number primary key,
  quantity number not null,
  location varchar(50) not null,
  foreign key (product_id) references usr_opr.Products5(product_id)
);


-- Insert data 
INSERT INTO usr_opr.Customers5 (customer_id, name, address, contact_number)
VALUES (1, 'Ram', '123 Main St', '2122522');

INSERT INTO usr_opr.Products5 (product_id, name, description, price)
VALUES (1, 'Product A', 'Description of Product A', 12);

INSERT INTO usr_opr.Sales (sale_id, customer_id, product_id, quantity, sale_date)
VALUES (1, 1, 1, 2, '01-JAN-2021');

INSERT INTO usr_opr.Inventory (product_id, quantity, location)
VALUES (1, 100, 'Warehouse A');


-------------------------------------------------------------------------------------------------------------------------------------
--------------script to extract data from 'usr_opr' to supply 'usr_des'------------------- 

CREATE TABLE Customers_usr_des AS SELECT * FROM usr_opr.Customers5;
CREATE TABLE Products_usr_des AS SELECT * FROM usr_opr.Products5;
CREATE TABLE Sales_usr_des AS SELECT * FROM usr_opr.Sales;
CREATE TABLE Inventory_usr_des AS SELECT * FROM usr_opr.Inventory;


____________________________________________________________________________________________________________________________________________________________
--------------------script to query on 'usr_des'    ___ 
--
SELECT * FROM Customers_usr_des;
SELECT * FROM Products_usr_des;
SELECT * FROM Sales_usr_des;
SELECT * FROM Inventory_usr_des;





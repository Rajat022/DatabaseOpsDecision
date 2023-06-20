
-- Create Customers5 table
create table Customers5 (
  customer_id number primary key,
  name varchar(50) not null,
  address varchar(100) not null,
  contact_number varchar(20) not null
);

-- Create Products5 table
create table Products5 (
  product_id number primary key,
  name varchar(50) not null,
  description varchar(255) not null,
  price number not null
);

-- Create Sales table
create table Sales (
  sale_id number primary key,
  customer_id number not null,
  product_id number not null,
  quantity number not null,
  sale_date date not null,
  foreign key (customer_id) references Customers5(customer_id),
  foreign key (product_id) references Products5(product_id)
  );

-- Create Inventory table
create table Inventory (
  product_id number primary key,
  quantity number not null,
  location varchar(50) not null,
  foreign key (product_id) references Products5(product_id)
);

-- Create Employee5 table
create table Employee5 (
  Employee5_id number primary key,
  name varchar(50) not null,
  position varchar(50) not null,
  contact_number varchar(20) not null
);

-- Create Promotions table
create table Promotions (
  promotion_id number primary key,
  product_id number not null,
  promotion_type varchar(50) not null,
  start_date date not null,
  end_date date not null,
  foreign key (product_id) references Products5(product_id)
);

-- Create Transactions table
create table Transactions (
  transaction_id number primary key,
  customer_id number not null,
  Employee5_id number not null,
  product_id number not null,
  price number not null,
  transaction_date date not null,
  foreign key (customer_id) references Customers5(customer_id),
  foreign key (Employee5_id) references Employee5(Employee5_id),
  foreign key (product_id) references Products5(product_id)
);

-- Inserting the data into tables 

-- Connect to the Oracle Database
connect <username>/<password>

-- Insert data into Customers5 table
insert into Customers5 values (1, 'John Smith', '123 Main St', '555-555-1234');
insert into Customers5 values (2, 'Jane Doe', '456 Park Ave', '555-555-5678');

-- Insert data into Products5 table
insert into Products5 values (1, 'Product A', 'Description of Product A', 10.99);
insert into Products5 values (2, 'Product B', 'Description of Product B', 15.99);

-- Insert data into Sales table
insert into Sales values (1, 1, 1, 2, '01-JAN-2021');
insert into Sales values (2, 2, 2, 1, '02-JAN-2021');

-- Insert data into Inventory table
insert into Inventory values (1, 100, 'Warehouse 1');
insert into Inventory values (2, 50, 'Warehouse 2');

-- Insert data into Employee5 table
insert into Employee5 values (1, 'Bob Smith', 'Manager', '555-555-6789');
insert into Employee5 values (2, 'Sally Jones', 'Assistant Manager', '555-555-9876');

-- Insert data into Promotions table
insert into Promotions values (1, 1, 'Discount', '01-JAN-2021', '31-JAN-2021');
insert into Promotions values (2, 2, 'BOGO', '15-JAN-2021', '28-JAN-2021');

-- Insert data into Transactions table
insert into Transactions values (1, 1, 1, 1, 9.99, '01-JAN-2021');
insert into Transactions values (2, 2, 2, 2, 14.99, '02-JAN-2021');












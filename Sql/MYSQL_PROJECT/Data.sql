CREATE DATABASE apple;
use apple;

-- CREATE ALL TABLES --
CREATE TABLE stores(
store_id VARCHAR(5) PRIMARY KEY,
store_name	VARCHAR(30),
city	VARCHAR(25),
country VARCHAR(25)
);

CREATE TABLE category(
category_id VARCHAR(10) PRIMARY KEY,
category_name VARCHAR(20)
);

CREATE TABLE products(
product_id	VARCHAR(10) PRIMARY KEY,
product_name VARCHAR(35),
category_id	VARCHAR(10),
launch_date	date,
price FLOAT,
CONSTRAINT fk_category FOREIGN KEY (category_id) REFERENCES category(category_id)
);

CREATE TABLE sales(
sale_id	VARCHAR(15) PRIMARY KEY,
sale_date DATE,
store_id VARCHAR(10), 
product_id	VARCHAR(10),
quantity INT,
CONSTRAINT fk_store FOREIGN KEY (store_id) REFERENCES stores(store_id),
CONSTRAINT fk_product FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE warranty(
claim_id VARCHAR(10) PRIMARY KEY,	
claim_date date,
sale_id	VARCHAR(15),
repair_status VARCHAR(15),
CONSTRAINT fk_orders FOREIGN KEY (sale_id) REFERENCES sales(sale_id)
);


-- LOAD DATASETS --
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/APPLE/stores.CSV' 
INTO TABLE stores
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n' 
IGNORE 1 ROWS;
select*from stores;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/APPLE/category.CSV' 
INTO TABLE category
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n' 
IGNORE 1 ROWS;
select *from category;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/APPLE/products.CSV' 
INTO TABLE products
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n' 
IGNORE 1 ROWS;
select*from products;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/APPLE/sales.CSV' 
INTO TABLE sales
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n' 
IGNORE 1 ROWS;
select*from sales;
select count(sale_id) from sales;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/APPLE/warranty.CSV' 
INTO TABLE warranty
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\r\n' 
IGNORE 1 ROWS;
select*from warranty;
select count(claim_id) from warranty;

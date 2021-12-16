use eventbooking;
-- Create 5 tables for Event booking

-- 1. Customer Information
Create Table tbl_Customer(
	customer_id INT PRIMARY KEY NOT NULL,
	customer_Firstname varchar(50) NOT NULL,
	customer_Lastname varchar(50) NOT NULL,
	customer_Address varchar(50) NOT NULL,
	customer_Phone varchar(15) NOT NULL,
	customer_Email	varchar(50) NOT NULL
   );
/*2. Create Reservation Information table;*/
Create table tbl_Reservation 
	(
		Reservation_Id  INT  PRIMARY KEY NOT NULL,
		customer_id INT  NOT NULL,
		event_type_id INT NOT NULL, -- online,hybrid,inperson
		event_date DATE NOT NULL,
		event_status varchar(50)    
		);
    
    /*3. Create Booking  Information table;*/
    Create table tbl_Booking 
    (
		Booking_Id  INT NOT NULL PRIMARY KEY,
		Reservation_Id  INT NOT NULL,
		customer_id INT NOT NULL,
        event_type_id INT NOT NULL,
        event_date DATE NOT NULL
    );
       /*4. Create Event  Type table ;*/
	Create table tbl_Event_type 
    (
		event_type_id INT NOT NULL PRIMARY KEY,
		event_Type varchar(50) NOT NULL
	);
        
         /*5. Create Event  Information table; */
	Create table tbl_Event 
    (
    event_id INT NOT NULL PRIMARY KEY,
    event_Name varchar(50) NOT NULL,
    event_type_id INT(12) NOT NULL, 
    event_status varchar(50) NOT NULL
          );
       
       
         /*6. Create Payment  Information table; */
         drop table  tbl_PaymentInfo;
         Create table tbl_PaymentInfo
    (
		Payment_id INT NOT NULL PRIMARY KEY,
        customer_id INT  NOT NULL,
        Discount_code varchar(50),
        event_price float NOT NULL,
        total_price float NOT NULL,
        Payment_status INT NOT NULL
        );
        
    -- Altered table to include foreign key constraint
    
    ALTER TABLE tbl_PaymentInfo
	ADD FOREIGN KEY (customer_id) REFERENCES tbl_customer(customer_id);    
               
         -- Customer_detail table imported from CSV file
         
-- core query with subquerytbl_customer
select customer_firstname, customer_lastname tbl_customer
from tbl_customer 
where customer_id in (select customer_id from tbl_booking );

-- View to display Customer and Event Information
create view Customers_onlineEvent as
select  
t1.customer_FirstName,
t1.customer_LastName,
t2.event_date,
t3.event_Name
from tbl_customer t1
inner join
tbl_booking t2
on t1.CUSTOMER_ID = t2.customer_id
right join tbl_event t3 
on t2.event_type_id = t3.event_type_id
;

Insert into tbl_paymentinfo values
(1,2,70,"80",80.00,1
);
Insert into tbl_paymentinfo values
(3,4,0,"20",75.00,1
);

INSERT INTO TBL_EVENT values
(
1,"Annual Jazz",1,"Scheduled");
INSERT INTO TBL_EVENT values
(
2,"Workshop Sessions",2,"Scheduled");
INSERT INTO TBL_EVENT values
(
3,"Christmas Market",2,"Scheduled");

INSERT INTO TBL_EVENT values
(
4,"IceSkating",4,"Tentative");

-- Creating a stored function to upate tbl_paymentinfo coloumn total price
DELIMITER //

 CREATE PROCEDURE update_payment( CUSTID INT, Discount_Code INT)
BEGIN
	 DECLARE ApplyDiscount VARCHAR(20);
     DECLARE CUSTID INT;
    IF Discount_Code = 70 THEN
        SET ApplyDiscount = 10;
    ELSEIF Discount_Code = 80 THEN
        SET ApplyDiscount = 20;
    ELSEIF Discount_Code = 0 THEN
        SET ApplyDiscount = 0;
    END IF;
    update tbl_paymentinfo set TOTAL_PRICE = TOTAL_PRICE - TOTAL_PRICE * ApplyDiscount WHERE CUSTOMER_ID=CUSTID;
END//

DELIMITER ;
CALL  update_payment(2,70);
drop procedure update_payment;

SELECT * FROM tbl_paymentinfo WHERE CUSTOMER_ID =2

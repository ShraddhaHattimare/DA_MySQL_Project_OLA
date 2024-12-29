create database OLA ;
use OLA;

# user table is created
CREATE TABLE Users (
    UserID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    PhoneNumber VARCHAR(15) UNIQUE NOT NULL,
    UserType ENUM('Driver', 'Passenger') NOT NULL,
    PasswordHash VARCHAR(255) NOT NULL,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

# driver table is created
CREATE TABLE Drivers (
    DriverID INT PRIMARY KEY,
    VehicleNumber VARCHAR(20) NOT NULL,
    VehicleModel VARCHAR(50) NOT NULL,
    LicenseNumber VARCHAR(50) NOT NULL,
    Rating DECIMAL(3, 2) DEFAULT 5.0,
    FOREIGN KEY (DriverID) REFERENCES Users(UserID) ON DELETE CASCADE
);


# passenger table is created
CREATE TABLE Passengers (
    PassengerID INT PRIMARY KEY,
    PreferredPaymentMethod ENUM('Cash', 'Card', 'UPI') DEFAULT 'Cash',
    FOREIGN KEY (PassengerID) REFERENCES Users(UserID) ON DELETE CASCADE
);


# ride table is created
CREATE TABLE Rides (
    RideID INT AUTO_INCREMENT PRIMARY KEY,
    DriverID INT NOT NULL,
    PassengerID INT NOT NULL,
    StartLocation VARCHAR(255) NOT NULL,
    EndLocation VARCHAR(255) NOT NULL,
    StartTime DATETIME,
    EndTime DATETIME,
    Fare DECIMAL(10, 2),
    Status ENUM('Requested', 'Ongoing', 'Completed', 'Cancelled') DEFAULT 'Requested',
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (DriverID) REFERENCES Drivers(DriverID),
    FOREIGN KEY (PassengerID) REFERENCES Passengers(PassengerID)
);

#---------------------------------------------------------------------
# insert data in to tables
#---------------------------------------------------------------------

# ------------- insert into USER table -------------------------------
-- way1
insert into users values
("2", "bipin bhai","bipin@gmail.com",
 "9028764315", "Passenger", "bp@1234", "2024-12-27 15:17:59") ;

-- way2
INSERT INTO Users (Name, Email, PhoneNumber, UserType, PasswordHash)
VALUES ('Alice Johnson', 'alice.johnson@example.com', '9876543210',
 'Driver', 'aj@1234');
 
INSERT INTO Users (Name, Email, PhoneNumber, UserType, PasswordHash)
VALUES 
    ('John Doe', 'john.doe@example.com', '9123456780', 'Passenger', 'jd@1234'),
    ('Mark Smith', 'mark.smith@example.com', '9988776655', 'Driver', 'ms@1234'),
    ('Sarah Lee', 'sarah.lee@example.com', '8877665544', 'Passenger', 'sl@1234'),
    ('Emma Davis', 'emma.davis@example.com', '7766554433', 'Passenger', 'ed@1234'),
    ('Michael Brown', 'michael.brown@example.com', '6655443322', 'Driver', 'mb@1234');
 
#---------------------------------- read data from USER table
Select * from users ;
select * from users where usertype = "Driver" ;

#----------------------------- update USER table -----------
update users
set name = "Emma David"
where name = "Emma Davis" ;

#------------------------------------------------------------------------
#insert data into driver table
INSERT INTO Drivers (DriverID, VehicleNumber, VehicleModel,
LicenseNumber, Rating)
VALUES (1, 'GJ01BF1234', 'Toyota Innova', 'DL12345678', 4.8);

INSERT INTO Drivers (DriverID, VehicleNumber, VehicleModel, LicenseNumber, Rating)
VALUES 
    (3, 'MH01AB5678', 'Hyundai Verna', 'MH98765432', 4.5),
    (5, 'DL03XY9876', 'Honda City', 'DL45327890', 4.7),
    (8, 'TN10PQ4567', 'Maruti Swift', 'TN12345678', 4.6);

# ---------- read from Drivers table ---
select * from Drivers ;

#----------------------------insert data into passenger table----------------
insert into passengers (PassengerID, PreferredPaymentMethod) values
(2,"UPI");

INSERT INTO Passengers (PassengerID, PreferredPaymentMethod)
VALUES 
    (4, 'Card'),
    (6, 'Cash'),
    (7, 'UPI');

# -----------------select from Passengers ----
select * from Passengers;

#----------------update passesngers ------
UPDATE Passengers
SET PreferredPaymentMethod = 'Cash'
WHERE PassengerID = 7;

#insert data into ride table
INSERT INTO Rides (DriverID, PassengerID, StartLocation, EndLocation, 
StartTime, Status)
VALUES (1, 2, 'Maninagar, Ahmedabad', 'Vastrapur, Ahmedabad', NOW(), 
'Requested');

INSERT INTO Rides (DriverID, PassengerID, StartLocation, EndLocation,
StartTime, EndTime, Fare, Status)
VALUES 
    (1, 4, 'Indiranagar, Ahmedabad', 'LD College, Ahmedabad', '2024-12-22 10:30:00', '2024-12-22 11:00:00', 250.00, 'Completed'),
    (3, 4, 'Nehrunagar, Ahmedabad', 'AMA, Ahmedabad', '2024-12-23 09:00:00', '2024-12-23 09:45:00', 400.00, 'Completed'),
    (5, 6, 'MG Road, Ahmedabad', 'university road, Ahmedabad', '2024-12-24 14:15:00', NULL, NULL, 'Ongoing'),
    (3, 7, 'BTM Layout, Ahmedabad', 'Jayanagar, Ahmedabad', '2024-12-24 08:00:00', NULL, NULL, 'Ongoing'),
    (8, 2, 'JP Nagar, Ahmedabad', 'Bapunagar, Ahmedabad', '2024-12-25 16:00:00', NULL, NULL, 'Requested');

# ------------------ update ride table which rides status gets completed---------

update rides
set endtime = now(), Fare = 550.00, status = "Completed"
where rideid = 4 ;

# ------------------ JOIN Query ---------------
select * from rides inner join passengers on
 rides.passengerid = passengers.passengerid ;
 
/*select all rides Retrieve all rides, including those that may not 
have an assigned passenger (e.g., scheduled rides), 
along with the passenger details if available. */
SELECT 
    r.RideID,
    r.StartLocation,
    r.EndLocation,
    r.StartTime,
    r.EndTime,
    r.Fare,
    r.Status,
    p.PassengerID,
    u1.Name AS PassengerName
FROM 
    Rides r
LEFT JOIN 
    Passengers p ON r.PassengerID = p.PassengerID
LEFT JOIN 
    Users u1 ON p.PassengerID = u1.UserID;
    
/*
Retrieve all drivers, including those who may not have provided 
any rides,along with their assigned rides if available.
*/    
 
SELECT 
    d.DriverID,
    u2.Name AS DriverName,
    d.VehicleModel,
    r.RideID,
    r.StartLocation,
    r.EndLocation,
    r.Fare
FROM 
    Rides r
RIGHT JOIN 
    Drivers d ON r.DriverID = d.DriverID
RIGHT JOIN 
    Users u2 ON d.DriverID = u2.UserID;
    
/*
Retrieve Completed Rides with Passenger Details
*/
SELECT 
    r.RideID,
    r.StartLocation,
    r.EndLocation,
    r.Fare,
    r.Status,
    u1.Name AS PassengerName
FROM 
    Rides r
LEFT JOIN 
    Passengers p ON r.PassengerID = p.PassengerID
LEFT JOIN 
    Users u1 ON p.PassengerID = u1.UserID
WHERE 
    r.Status = 'Completed';
    
-- List All Drivers with Their Rides --

SELECT 
    d.DriverID,
    u2.Name AS DriverName,
    d.VehicleModel,
    r.RideID,
    r.StartLocation,
    r.EndLocation,
    r.Status
FROM 
    Rides r
RIGHT JOIN 
    Drivers d ON r.DriverID = d.DriverID
RIGHT JOIN 
    Users u2 ON d.DriverID = u2.UserID;
    
-- select query using where clause --
select * from users where usertype = "passenger" ; 

-- limit : select only 2 record from user table who is driver -- 
select * from users where usertype = "driver" ;   
select * from users where usertype = "driver" limit 2; 

-- group by query - Total Fare Earned by Each Driver --
select 
SUM(r.fare) as totalfare, 
u.name as drivername, 
d.driverid from  rides r 
	inner join drivers d on r.driverid = d.driverid
	inner join users u on u.userid = d.driverid 
	group by u.name,d.driverid; 

/*
-- group by-having query  --
*/
INSERT INTO Users (Name, Email, PhoneNumber, UserType, PasswordHash)
VALUES 
( "james bond","jb@gmail.com","9898765463", "Driver","jb@1234");
 
select count(*) as Total, usertype from users 
group by usertype ;
 
select count(*) as Total, usertype from users 
group by usertype 
having Total > 4;


 
 
 

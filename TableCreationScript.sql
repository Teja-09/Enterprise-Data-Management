-- Drop tables in reverse order to handle foreign key constraints
DROP TABLE SUBSCRIPTION_MODELS;
DROP TABLE CUSTOMER_CONTACTS;
DROP TABLE CUSTOMERS;
DROP TABLE EMP_CONTACTS;
DROP TABLE EMPLOYEES;
DROP TABLE STATIONS;
DROP TABLE DEPARTMENTS;
DROP TABLE AUTHENTICATION;
DROP TABLE COMPLAINTS;
DROP TABLE RATINGS;
DROP TABLE PAYROLLS;
DROP TABLE TRIP;
DROP TABLE BIKE_MODELS;
DROP TABLE VENDORS;
DROP TABLE SPARE_PARTS;
DROP TABLE DISCOUNTS;
DROP TABLE PAYMENT;
DROP TABLE BIKES;

-- Create AUTHENTICATION table
CREATE TABLE AUTHENTICATION (
    authID NUMBER PRIMARY KEY,
    password VARCHAR2(255),
    email VARCHAR2(255),
    securityQuestion VARCHAR2(255),
    securityAnswer VARCHAR2(255),
    type VARCHAR2(255)
);

-- Create DEPARTMENTS table
CREATE TABLE DEPARTMENTS (
    deptID NUMBER PRIMARY KEY,
    deptName VARCHAR2(255),
    designation VARCHAR2(255)
);

-- Create VENDORS table
CREATE TABLE VENDORS (
    vendorID NUMBER PRIMARY KEY,
    vPhone VARCHAR2(20),
    vName VARCHAR2(255),
    vEmail VARCHAR2(255),
    street VARCHAR2(255),
    city VARCHAR2(255),
    state VARCHAR2(255),
    zipCode VARCHAR2(20),
    country VARCHAR2(255)
);

-- Create BIKE_MODELS table
CREATE TABLE BIKE_MODELS (
    modelID NUMBER PRIMARY KEY,
    modelName VARCHAR2(255),
    type VARCHAR2(255),
    description VARCHAR2(1000),
    costToCompany NUMBER,
    rentalPrice NUMBER
);

-- Create SPARE_PARTS table
CREATE TABLE SPARE_PARTS (
    sPartID NUMBER PRIMARY KEY,
    spName VARCHAR2(255),
    spWeight NUMBER,
    spColor VARCHAR2(255),
    spBrand VARCHAR2(255),
    price NUMBER,
    vendorID NUMBER,
    CONSTRAINT fk_spare_part_vendor FOREIGN KEY (vendorID) REFERENCES VENDORS(vendorID)
);

-- Create DISCOUNTS table
CREATE TABLE DISCOUNTS (
    discountID NUMBER PRIMARY KEY,
    disCode VARCHAR2(255),
    creditAmount NUMBER,
    description VARCHAR2(1000),
    validFrom DATE,
    validTo DATE
);

-- Create PAYROLLS table
CREATE TABLE PAYROLLS (
    payrollID NUMBER PRIMARY KEY,
    incentivePercent NUMBER,
    taxInformation VARCHAR2(255),
    salaryGrade VARCHAR2(255),
    salary NUMBER
);

-- Create STATIONS table
CREATE TABLE STATIONS (
    stationID NUMBER PRIMARY KEY,
    sName VARCHAR2(255),
    city VARCHAR2(255),
    bikeCapacity NUMBER,
    availableBikes NUMBER,
    maintenanceBikes NUMBER,
    coOrdinates VARCHAR2(255),
    freeBikeSpaces NUMBER
);

-- Create EMPLOYEES table
CREATE TABLE EMPLOYEES (
    empID NUMBER PRIMARY KEY,
    fName VARCHAR2(255),
    lName VARCHAR2(255),
    designation VARCHAR2(255),
    dateOfLeaving DATE,
    SSN VARCHAR2(20),
    dateOfJoining DATE,
    gender CHAR(1),
    emergencyContact VARCHAR2(20),
    workLocation VARCHAR2(255),
    managerID NUMBER,
    departmentID NUMBER,
    authID NUMBER,
    email VARCHAR2(255),
    street VARCHAR2(255),
    city VARCHAR2(255),
    state VARCHAR2(255),
    zipCode VARCHAR2(20),
    dob DATE,
    age NUMBER,
    isManager CHAR(1),
    isOnCallSupport CHAR(1),
    isMechanic CHAR(1),
    CONSTRAINT fk_emp_auth FOREIGN KEY (authID) REFERENCES AUTHENTICATION(authID)
);

-- Create EMP_CONTACTS table
CREATE TABLE EMP_CONTACTS (
    empID NUMBER,
    mobileNum VARCHAR2(20),
    PRIMARY KEY (empID, mobileNum),
    CONSTRAINT fk_emp_contacts FOREIGN KEY (empID) REFERENCES EMPLOYEES(empID)
);

-- Create CUSTOMERS table
CREATE TABLE CUSTOMERS (
    custID NUMBER PRIMARY KEY,
    fName VARCHAR2(255),
    lName VARCHAR2(255),
    age NUMBER,
    dob DATE,
    custSince DATE,
    address VARCHAR2(255),
    email VARCHAR2(255),
    hasPayed CHAR(1),
    authID NUMBER,
    CONSTRAINT fk_auth FOREIGN KEY (authID) REFERENCES AUTHENTICATION(authID)
);

-- Create CUSTOMER_CONTACTS table
CREATE TABLE CUSTOMER_CONTACTS (
    custID NUMBER,
    mobileNum VARCHAR2(20),
    PRIMARY KEY (custID, mobileNum),
    CONSTRAINT fk_cust_contacts FOREIGN KEY (custID) REFERENCES CUSTOMERS(custID)
);

-- Create SUBSCRIPTION_MODELS table
CREATE TABLE SUBSCRIPTION_MODELS (
    planID NUMBER PRIMARY KEY,
    title VARCHAR2(255),
    basePrice NUMBER(10, 2),
    description VARCHAR2(256)
);

-- Create COMPLAINTS table
CREATE TABLE COMPLAINTS (
    complaintID NUMBER PRIMARY KEY,
    typeOfComplaint VARCHAR2(255),
    status VARCHAR2(255),
    raisedTime TIMESTAMP,
    resolveTime TIMESTAMP,
    custID NUMBER,
    empID NUMBER,
    CONSTRAINT fk_complaint_cust FOREIGN KEY (custID) REFERENCES CUSTOMERS(custID),
    CONSTRAINT fk_complaint_emp FOREIGN KEY (empID) REFERENCES EMPLOYEES(empID)
);

-- Create RATINGS table
CREATE TABLE RATINGS (
    reviewID NUMBER PRIMARY KEY,
    userID NUMBER,
    datePosted TIMESTAMP,
    bikeID NUMBER,
    reviewText VARCHAR2(1000),
    custID NUMBER,
    CONSTRAINT fk_rating_cust FOREIGN KEY (custID) REFERENCES CUSTOMERS(custID)
);

-- Create PAYMENT table
CREATE TABLE PAYMENT (
    paymentID NUMBER PRIMARY KEY,
    amount NUMBER,
    paymentTime TIMESTAMP,
    paymentMode VARCHAR2(255)
);

-- Create BIKES table
CREATE TABLE BIKES (
    bikeID NUMBER PRIMARY KEY,
    status VARCHAR2(255),
    cityID NUMBER,
    bikeName VARCHAR2(255),
    yearOfManufacture NUMBER,
    modelID NUMBER,
    stationID NUMBER,
    CONSTRAINT fk_bike_model FOREIGN KEY (modelID) REFERENCES BIKE_MODELS(modelID),
    CONSTRAINT fk_bike_station FOREIGN KEY (stationID) REFERENCES STATIONS(stationID)
);

-- Create TRIP table
CREATE TABLE TRIP (
    tripID NUMBER PRIMARY KEY,
    startTime TIMESTAMP,
    endTime TIMESTAMP,
    custID NUMBER,
    pickUpStationID NUMBER,
    dropOffStationID NUMBER,
    bikeID NUMBER,
    CONSTRAINT fk_trip_pickup FOREIGN KEY (pickUpStationID) REFERENCES STATIONS(stationID),
    CONSTRAINT fk_trip_dropoff FOREIGN KEY (dropOffStationID) REFERENCES STATIONS(stationID),
    CONSTRAINT fk_trip_cust FOREIGN KEY (custID) REFERENCES CUSTOMERS(custID),
    CONSTRAINT fk_trip_bike FOREIGN KEY (bikeID) REFERENCES BIKES(bikeID)
);

commit;



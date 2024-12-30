-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema ola
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema ola
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `ola` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `ola` ;

-- -----------------------------------------------------
-- Table `ola`.`users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ola`.`users` (
  `UserID` INT NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(100) NOT NULL,
  `Email` VARCHAR(100) NOT NULL,
  `PhoneNumber` VARCHAR(15) NOT NULL,
  `UserType` ENUM('Driver', 'Passenger') NOT NULL,
  `PasswordHash` VARCHAR(255) NOT NULL,
  `CreatedAt` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`UserID`),
  UNIQUE INDEX `Email` (`Email` ASC) VISIBLE,
  UNIQUE INDEX `PhoneNumber` (`PhoneNumber` ASC) VISIBLE)
ENGINE = InnoDB
AUTO_INCREMENT = 10
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `ola`.`drivers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ola`.`drivers` (
  `DriverID` INT NOT NULL,
  `VehicleNumber` VARCHAR(20) NOT NULL,
  `VehicleModel` VARCHAR(50) NOT NULL,
  `LicenseNumber` VARCHAR(50) NOT NULL,
  `Rating` DECIMAL(3,2) NULL DEFAULT '5.00',
  PRIMARY KEY (`DriverID`),
  CONSTRAINT `drivers_ibfk_1`
    FOREIGN KEY (`DriverID`)
    REFERENCES `ola`.`users` (`UserID`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `ola`.`passengers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ola`.`passengers` (
  `PassengerID` INT NOT NULL,
  `PreferredPaymentMethod` ENUM('Cash', 'Card', 'UPI') NULL DEFAULT 'Cash',
  PRIMARY KEY (`PassengerID`),
  CONSTRAINT `passengers_ibfk_1`
    FOREIGN KEY (`PassengerID`)
    REFERENCES `ola`.`users` (`UserID`)
    ON DELETE CASCADE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `ola`.`rides`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `ola`.`rides` (
  `RideID` INT NOT NULL AUTO_INCREMENT,
  `DriverID` INT NOT NULL,
  `PassengerID` INT NOT NULL,
  `StartLocation` VARCHAR(255) NOT NULL,
  `EndLocation` VARCHAR(255) NOT NULL,
  `StartTime` DATETIME NULL DEFAULT NULL,
  `EndTime` DATETIME NULL DEFAULT NULL,
  `Fare` DECIMAL(10,2) NULL DEFAULT NULL,
  `Status` ENUM('Requested', 'Ongoing', 'Completed', 'Cancelled') NULL DEFAULT 'Requested',
  `CreatedAt` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`RideID`),
  INDEX `DriverID` (`DriverID` ASC) VISIBLE,
  INDEX `PassengerID` (`PassengerID` ASC) VISIBLE,
  CONSTRAINT `rides_ibfk_1`
    FOREIGN KEY (`DriverID`)
    REFERENCES `ola`.`drivers` (`DriverID`),
  CONSTRAINT `rides_ibfk_2`
    FOREIGN KEY (`PassengerID`)
    REFERENCES `ola`.`passengers` (`PassengerID`))
ENGINE = InnoDB
AUTO_INCREMENT = 7
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
CREATE SCHEMA IF NOT EXISTS `smart_irrigation_db_nuovo` DEFAULT CHARACTER SET latin1 ;
USE `mydb` ;
USE `smart_irrigation_db_nuovo` ;

-- -----------------------------------------------------
-- Table `smart_irrigation_db_nuovo`.`actuatordevice`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `smart_irrigation_db_nuovo`.`ActuatorDevice` ;

CREATE  TABLE IF NOT EXISTS `smart_irrigation_db_nuovo`.`ActuatorDevice` (
  `ActuatorId` CHAR(30) NOT NULL ,
  `ZoneId` VARCHAR(45) NULL DEFAULT NULL ,
  `IPaddress` VARCHAR(45) NULL DEFAULT NULL ,
  `State` INT(11) NOT NULL ,
  `GeoCoordinates` VARCHAR(100) NULL DEFAULT NULL ,
  PRIMARY KEY (`ActuatorId`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `smart_irrigation_db_nuovo`.`actuatoractivation`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `smart_irrigation_db_nuovo`.`ActuatorActivation` ;

CREATE  TABLE IF NOT EXISTS `smart_irrigation_db_nuovo`.`ActuatorActivation` (
  `ActuatorId` CHAR(30) NOT NULL ,
  `Timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  PRIMARY KEY (`ActuatorId`, `Timestamp`) ,
  INDEX `ActAssing` (`ActuatorId` ASC) ,
  CONSTRAINT `ActAssing`
    FOREIGN KEY (`ActuatorId` )
    REFERENCES `smart_irrigation_db_nuovo`.`actuatordevice` (`ActuatorId` )
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `smart_irrigation_db_nuovo`.`sensordevice`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `smart_irrigation_db_nuovo`.`SensorDevice` ;

CREATE  TABLE IF NOT EXISTS `smart_irrigation_db_nuovo`.`SensorDevice` (
  `SensorId` CHAR(30) NOT NULL ,
  `PairedAct` CHAR(30) NULL DEFAULT NULL ,
  `ZoneId` VARCHAR(45) NULL DEFAULT NULL ,
  `IPaddress` VARCHAR(45) NULL DEFAULT NULL ,
  `GeoCoordinates` VARCHAR(100) NULL DEFAULT NULL ,
  PRIMARY KEY (`SensorId`) ,
  INDEX `ActAssign` (`PairedAct` ASC) ,
  CONSTRAINT `ActAssign`
    FOREIGN KEY (`PairedAct` )
    REFERENCES `smart_irrigation_db_nuovo`.`ActuatorDevice` (`ActuatorId` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `smart_irrigation_db_nuovo`.`temperature`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `smart_irrigation_db_nuovo`.`Temperature` ;

CREATE  TABLE IF NOT EXISTS `smart_irrigation_db_nuovo`.`Temperature` (
  `SensorId` CHAR(30) NOT NULL ,
  `Timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  `Value_C` INT(11) NOT NULL ,
  PRIMARY KEY (`SensorId`, `Timestamp`) ,
  INDEX `SensAssign` (`SensorId` ASC) ,
  CONSTRAINT `SensAssignTemp`
    FOREIGN KEY (`SensorId` )
    REFERENCES `smart_irrigation_db_nuovo`.`SensorDevice` (`SensorId` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `smart_irrigation_db_nuovo`.`volumetricwatercontent`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `smart_irrigation_db_nuovo`.`VolumetricWaterContent` ;

CREATE  TABLE IF NOT EXISTS `smart_irrigation_db_nuovo`.`VolumetricWaterContent` (
  `SensorId` CHAR(30) NOT NULL ,
  `Timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP ,
  `Value_perc` INT(11) NOT NULL ,
  PRIMARY KEY (`SensorId`, `Timestamp`) ,
  INDEX `SensAssign` (`SensorId` ASC) ,
  CONSTRAINT `SensAssignVMC`
    FOREIGN KEY (`SensorId` )
    REFERENCES `smart_irrigation_db_nuovo`.`SensorDevice` (`SensorId` )
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;

--
-- create user for jdbc connections
--
CREATE USER 'JavaCollector'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password';
GRANT ALL PRIVILEGES ON *.* TO 'JavaCollector'@'localhost' WITH GRANT OPTION;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=1;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

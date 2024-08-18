-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema CyberThreatManagementDB
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema CyberThreatManagementDB
-- -----------------------------------------------------
DROP DATABASE IF EXISTS `CyberThreatManagementDB`;
CREATE DATABASE IF NOT EXISTS `CyberThreatManagementDB` DEFAULT CHARACTER SET utf8 ;
USE `CyberThreatManagementDB` ;

-- -----------------------------------------------------
-- Table `CyberThreatManagementDB`.`Accounts`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CyberThreatManagementDB`.`Accounts` (
  `account_id` INT NOT NULL AUTO_INCREMENT,
  `username` VARCHAR(45) NOT NULL,
  `password` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`account_id`),
  UNIQUE INDEX `username_UNIQUE` (`username` ASC) VISIBLE,
  UNIQUE INDEX `account_id_UNIQUE` (`account_id` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CyberThreatManagementDB`.`User`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CyberThreatManagementDB`.`User` (
  `user_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(30) NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  `dob` DATE NOT NULL,
  `user_type` ENUM('Administrator', 'Registered User', 'Employee', 'Unregistered User') NOT NULL,
  `accounts_id` INT NULL,
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE,
  PRIMARY KEY (`user_id`),
  UNIQUE INDEX `user_id_UNIQUE` (`user_id` ASC) VISIBLE,
  INDEX `fk_User_Accounts1_idx` (`accounts_id` ASC) VISIBLE,
  CONSTRAINT `account_id_fk`
    FOREIGN KEY (`accounts_id`)
    REFERENCES `CyberThreatManagementDB`.`Accounts` (`account_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CyberThreatManagementDB`.`Administrators`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CyberThreatManagementDB`.`Administrators` (
  `admin_id` INT NOT NULL AUTO_INCREMENT,
  `admin_user_id` INT NOT NULL,
  `admin_password` VARCHAR(64) NOT NULL,
  PRIMARY KEY (`admin_id`),
  UNIQUE INDEX `admin_id_UNIQUE` (`admin_id` ASC) VISIBLE,
  INDEX `user_id_fk_idx` (`admin_user_id` ASC) VISIBLE,
  CONSTRAINT `user_id_fk`
    FOREIGN KEY (`admin_user_id`)
    REFERENCES `CyberThreatManagementDB`.`User` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CyberThreatManagementDB`.`RegisteredUsers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CyberThreatManagementDB`.`RegisteredUsers` (
  `registered_id` INT NOT NULL AUTO_INCREMENT,
  `registered_user_id` INT NOT NULL,
  PRIMARY KEY (`registered_id`),
  UNIQUE INDEX `registered_id_UNIQUE` (`registered_id` ASC) VISIBLE,
  CONSTRAINT `reg_id_fk`
    FOREIGN KEY (`registered_user_id`)
    REFERENCES `CyberThreatManagementDB`.`User` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CyberThreatManagementDB`.`Company`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CyberThreatManagementDB`.`Company` (
  `company_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `collab` INT NULL,
  PRIMARY KEY (`company_id`),
  INDEX `company_id_fk_idx` (`collab` ASC) VISIBLE,
  UNIQUE INDEX `company_id_UNIQUE` (`company_id` ASC) VISIBLE,
  CONSTRAINT `company_id_fk`
    FOREIGN KEY (`collab`)
    REFERENCES `CyberThreatManagementDB`.`Company` (`company_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CyberThreatManagementDB`.`Teams`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CyberThreatManagementDB`.`Teams` (
  `team_id` INT NOT NULL AUTO_INCREMENT,
  `team_name` VARCHAR(45) NOT NULL,
  `admin_managed` INT NULL,
  PRIMARY KEY (`team_id`),
  UNIQUE INDEX `team_id_UNIQUE` (`team_id` ASC) VISIBLE,
  INDEX `admins_id_fk_idx` (`admin_managed` ASC) VISIBLE,
  CONSTRAINT `admins_id_fk`
    FOREIGN KEY (`admin_managed`)
    REFERENCES `CyberThreatManagementDB`.`Administrators` (`admin_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CyberThreatManagementDB`.`Employees`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CyberThreatManagementDB`.`Employees` (
  `employee_id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `company` INT NULL,
  `team_id` INT NULL,
  PRIMARY KEY (`employee_id`),
  UNIQUE INDEX `work_id_UNIQUE` (`employee_id` ASC) VISIBLE,
  INDEX `user_id_fk_idx` (`user_id` ASC) VISIBLE,
  INDEX `company_fk_idx` (`company` ASC) VISIBLE,
  INDEX `team_id_fk_idx` (`team_id` ASC) VISIBLE,
  CONSTRAINT `uid_fk`
    FOREIGN KEY (`user_id`)
    REFERENCES `CyberThreatManagementDB`.`User` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `company_fk`
    FOREIGN KEY (`company`)
    REFERENCES `CyberThreatManagementDB`.`Company` (`company_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `team_id_fk`
    FOREIGN KEY (`team_id`)
    REFERENCES `CyberThreatManagementDB`.`Teams` (`team_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CyberThreatManagementDB`.`ThreatsCampaigns`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CyberThreatManagementDB`.`ThreatsCampaigns` (
  `campaign_id` INT NOT NULL AUTO_INCREMENT,
  `campaign_name` VARCHAR(45) NULL,
  `description` MEDIUMTEXT NULL,
  PRIMARY KEY (`campaign_id`),
  UNIQUE INDEX `campaign_id_UNIQUE` (`campaign_id` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CyberThreatManagementDB`.`Status`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CyberThreatManagementDB`.`Status` (
  `status_id` INT NOT NULL AUTO_INCREMENT,
  `status_name` VARCHAR(45) NOT NULL,
  `description` MEDIUMTEXT NULL,
  PRIMARY KEY (`status_id`),
  UNIQUE INDEX `status_id_UNIQUE` (`status_id` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CyberThreatManagementDB`.`SeverityLevel`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CyberThreatManagementDB`.`SeverityLevel` (
  `severity_id` INT NOT NULL AUTO_INCREMENT,
  `description` MEDIUMTEXT NULL,
  `title` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`severity_id`),
  UNIQUE INDEX `severity_level_id_UNIQUE` (`severity_id` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CyberThreatManagementDB`.`Threats`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CyberThreatManagementDB`.`Threats` (
  `threat_id` INT NOT NULL AUTO_INCREMENT,
  `threat_name` VARCHAR(45) NOT NULL,
  `status` INT NULL,
  `severity_level` INT NULL,
  PRIMARY KEY (`threat_id`),
  UNIQUE INDEX `threat_id_UNIQUE` (`threat_id` ASC) VISIBLE,
  INDEX `status_id_fk_idx` (`status` ASC) VISIBLE,
  INDEX `severity_id_fk_idx` (`severity_level` ASC) VISIBLE,
  CONSTRAINT `status_id_fk`
    FOREIGN KEY (`status`)
    REFERENCES `CyberThreatManagementDB`.`Status` (`status_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `severity_id_fk`
    FOREIGN KEY (`severity_level`)
    REFERENCES `CyberThreatManagementDB`.`SeverityLevel` (`severity_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CyberThreatManagementDB`.`Devices`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CyberThreatManagementDB`.`Devices` (
  `device_id` INT NOT NULL AUTO_INCREMENT,
  `user_log` INT NOT NULL,
  PRIMARY KEY (`device_id`),
  UNIQUE INDEX `device_id_UNIQUE` (`device_id` ASC) VISIBLE,
  INDEX `fk_Devices_Registered Users1_idx` (`user_log` ASC) VISIBLE,
  CONSTRAINT `device_user_id_fk`
    FOREIGN KEY (`user_log`)
    REFERENCES `CyberThreatManagementDB`.`RegisteredUsers` (`registered_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CyberThreatManagementDB`.`Forums`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CyberThreatManagementDB`.`Forums` (
  `forum_id` INT NOT NULL AUTO_INCREMENT,
  `forum_title` VARCHAR(45) NOT NULL,
  `forum_description` MEDIUMTEXT NULL,
  `publisher` INT NULL,
  PRIMARY KEY (`forum_id`),
  UNIQUE INDEX `forum_id_UNIQUE` (`forum_id` ASC) VISIBLE,
  INDEX `user_id_fk_idx` (`publisher` ASC) VISIBLE,
  CONSTRAINT `forum_user_id_fk`
    FOREIGN KEY (`publisher`)
    REFERENCES `CyberThreatManagementDB`.`User` (`user_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CyberThreatManagementDB`.`Services`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CyberThreatManagementDB`.`Services` (
  `services_id` INT NOT NULL AUTO_INCREMENT,
  `service_name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`services_id`),
  UNIQUE INDEX `services_id_UNIQUE` (`services_id` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CyberThreatManagementDB`.`AttackVectors`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CyberThreatManagementDB`.`AttackVectors` (
  `vector_id` INT NOT NULL AUTO_INCREMENT,
  `description` MEDIUMTEXT NULL,
  PRIMARY KEY (`vector_id`),
  UNIQUE INDEX `vector_id_UNIQUE` (`vector_id` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CyberThreatManagementDB`.`Vulnerabilities`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CyberThreatManagementDB`.`Vulnerabilities` (
  `vulnerabilty_id` INT NOT NULL AUTO_INCREMENT,
  `vulnerability_name` VARCHAR(45) NOT NULL,
  `descriptions` VARCHAR(255) NULL,
  `date` DATE NULL,
  `severity_level` INT NULL,
  `status` INT NULL,
  PRIMARY KEY (`vulnerabilty_id`),
  UNIQUE INDEX `vulnerabilty_id_UNIQUE` (`vulnerabilty_id` ASC) VISIBLE,
  INDEX `severity_level_id_fk_idx` (`severity_level` ASC) VISIBLE,
  INDEX `status_id_fk_idx` (`status` ASC) VISIBLE,
  CONSTRAINT `severity_level_id_fk`
    FOREIGN KEY (`severity_level`)
    REFERENCES `CyberThreatManagementDB`.`SeverityLevel` (`severity_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `vul_status_id_fk`
    FOREIGN KEY (`status`)
    REFERENCES `CyberThreatManagementDB`.`Status` (`status_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CyberThreatManagementDB`.`Alert`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CyberThreatManagementDB`.`Alert` (
  `alert_id` INT NOT NULL AUTO_INCREMENT,
  `alert_date` DATE NULL,
  `threat` INT NULL,
  `vulnerability` INT NULL,
  PRIMARY KEY (`alert_id`),
  UNIQUE INDEX `alert_id_UNIQUE` (`alert_id` ASC) VISIBLE,
  INDEX `threat_id_idx` (`threat` ASC) VISIBLE,
  INDEX `vulnerability_id_idx` (`vulnerability` ASC) VISIBLE,
  CONSTRAINT `threat_id`
    FOREIGN KEY (`threat`)
    REFERENCES `CyberThreatManagementDB`.`Threats` (`threat_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `vulnerability_id`
    FOREIGN KEY (`vulnerability`)
    REFERENCES `CyberThreatManagementDB`.`Vulnerabilities` (`vulnerabilty_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CyberThreatManagementDB`.`Reports`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CyberThreatManagementDB`.`Reports` (
  `report_id` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(45) NOT NULL,
  `submitted_by` INT NULL,
  `threat` INT NULL,
  `vulnerability` INT NULL,
  `publication_date` DATE NULL,
  `description` LONGTEXT NULL,
  `status` INT NULL,
  PRIMARY KEY (`report_id`),
  UNIQUE INDEX `report_id_UNIQUE` (`report_id` ASC) VISIBLE,
  INDEX `registered_user_id_fk_idx` (`submitted_by` ASC) VISIBLE,
  INDEX `status_id_fk_idx` (`status` ASC) VISIBLE,
  INDEX `threat_id_fk_idx` (`threat` ASC) VISIBLE,
  INDEX `vulnerability_id_fk_idx` (`vulnerability` ASC) VISIBLE,
  CONSTRAINT `registered_user_id_fk`
    FOREIGN KEY (`submitted_by`)
    REFERENCES `CyberThreatManagementDB`.`RegisteredUsers` (`registered_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `rep_status_id_fk`
    FOREIGN KEY (`status`)
    REFERENCES `CyberThreatManagementDB`.`Status` (`status_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `threat_id_fk`
    FOREIGN KEY (`threat`)
    REFERENCES `CyberThreatManagementDB`.`Threats` (`threat_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `vulnerability_id_fk`
    FOREIGN KEY (`vulnerability`)
    REFERENCES `CyberThreatManagementDB`.`Vulnerabilities` (`vulnerabilty_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CyberThreatManagementDB`.`Profiles`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CyberThreatManagementDB`.`Profiles` (
  `profile_id` INT NOT NULL AUTO_INCREMENT,
  `account_id` INT NOT NULL,
  `alias` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`profile_id`),
  UNIQUE INDEX `profile_id_UNIQUE` (`profile_id` ASC) VISIBLE,
  INDEX `account_id_fk_idx` (`account_id` ASC) VISIBLE,
  CONSTRAINT `prof_account_id_fk`
    FOREIGN KEY (`account_id`)
    REFERENCES `CyberThreatManagementDB`.`Accounts` (`account_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CyberThreatManagementDB`.`Solutions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CyberThreatManagementDB`.`Solutions` (
  `solution_id` INT NOT NULL AUTO_INCREMENT,
  `solution_name` VARCHAR(45) NOT NULL,
  `solution` LONGTEXT NULL,
  PRIMARY KEY (`solution_id`),
  UNIQUE INDEX `solution_id_UNIQUE` (`solution_id` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CyberThreatManagementDB`.`Patterns`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CyberThreatManagementDB`.`Patterns` (
  `pattern_id` INT NOT NULL AUTO_INCREMENT,
  `threat_pattern` TEXT NULL,
  `vulnerability_pattern` TEXT NULL,
  PRIMARY KEY (`pattern_id`),
  UNIQUE INDEX `pattern_id_UNIQUE` (`pattern_id` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CyberThreatManagementDB`.`Comments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CyberThreatManagementDB`.`Comments` (
  `comment_id` INT NOT NULL AUTO_INCREMENT,
  `comment` LONGTEXT NOT NULL,
  `posted_forum` INT NULL,
  `publisher` INT NULL,
  PRIMARY KEY (`comment_id`),
  UNIQUE INDEX `comment_id_UNIQUE` (`comment_id` ASC) VISIBLE,
  INDEX `posted_forum_id_fk_idx` (`posted_forum` ASC) VISIBLE,
  CONSTRAINT `posted_forum_id_fk`
    FOREIGN KEY (`posted_forum`)
    REFERENCES `CyberThreatManagementDB`.`Forums` (`forum_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CyberThreatManagementDB`.`MaliciousActors`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CyberThreatManagementDB`.`MaliciousActors` (
  `actor_id` INT NOT NULL AUTO_INCREMENT,
  `alias` VARCHAR(45) NULL,
  `ma_description` MEDIUMTEXT NULL,
  PRIMARY KEY (`actor_id`),
  UNIQUE INDEX `actor_id_UNIQUE` (`actor_id` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CyberThreatManagementDB`.`DiscoveryMethod`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CyberThreatManagementDB`.`DiscoveryMethod` (
  `discovery_id` INT NOT NULL AUTO_INCREMENT,
  `description` MEDIUMTEXT NULL,
  `title` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`discovery_id`),
  UNIQUE INDEX `discovery_id_UNIQUE` (`discovery_id` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CyberThreatManagementDB`.`UserServiceUsed`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CyberThreatManagementDB`.`UserServiceUsed` (
  `user_id` INT NOT NULL,
  `service_id` INT NOT NULL,
  INDEX `user_id_fk_idx` (`user_id` ASC) VISIBLE,
  INDEX `service_id_fk_idx` (`service_id` ASC) VISIBLE,
  PRIMARY KEY (`user_id`, `service_id`),
  CONSTRAINT `usu_user_id_fk`
    FOREIGN KEY (`user_id`)
    REFERENCES `CyberThreatManagementDB`.`User` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `service_id_fk`
    FOREIGN KEY (`service_id`)
    REFERENCES `CyberThreatManagementDB`.`Services` (`services_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CyberThreatManagementDB`.`HarmUser`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CyberThreatManagementDB`.`HarmUser` (
  `user_id` INT NOT NULL,
  `threat_id` INT NULL,
  `vulnerability_id` INT NULL,
  INDEX `thread_id_fk_idx` (`threat_id` ASC) VISIBLE,
  INDEX `vulnerability_id_fk_idx` (`vulnerability_id` ASC) VISIBLE,
  INDEX `user_id_fk_idx` (`user_id` ASC) VISIBLE,
  PRIMARY KEY (`user_id`),
  CONSTRAINT `hu_user_id_fk`
    FOREIGN KEY (`user_id`)
    REFERENCES `CyberThreatManagementDB`.`User` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `hu_threat_id_fk`
    FOREIGN KEY (`threat_id`)
    REFERENCES `CyberThreatManagementDB`.`Threats` (`threat_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `hu_vul_id_fk`
    FOREIGN KEY (`vulnerability_id`)
    REFERENCES `CyberThreatManagementDB`.`Vulnerabilities` (`vulnerabilty_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CyberThreatManagementDB`.`ForumUserView`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CyberThreatManagementDB`.`ForumUserView` (
  `forum_id` INT NOT NULL,
  `user_id` INT NOT NULL,
  INDEX `user_id_fk_idx` (`user_id` ASC) VISIBLE,
  INDEX `forum_id_fk_idx` (`forum_id` ASC) VISIBLE,
  PRIMARY KEY (`forum_id`, `user_id`),
  CONSTRAINT `fuv_user_id_fk`
    FOREIGN KEY (`user_id`)
    REFERENCES `CyberThreatManagementDB`.`User` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fuv_forum_id_fk`
    FOREIGN KEY (`forum_id`)
    REFERENCES `CyberThreatManagementDB`.`Forums` (`forum_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CyberThreatManagementDB`.`UserComments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CyberThreatManagementDB`.`UserComments` (
  `user_registered_id` INT NULL,
  `comment_id` INT NULL,
  INDEX `fk_Registered Users_has_Comments_Comments1_idx` (`comment_id` ASC) VISIBLE,
  INDEX `fk_Registered Users_has_Comments_Registered Users1_idx` (`user_registered_id` ASC) VISIBLE,
  CONSTRAINT `uc_ru_id_fk`
    FOREIGN KEY (`user_registered_id`)
    REFERENCES `CyberThreatManagementDB`.`RegisteredUsers` (`registered_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `uc_comments_id_fk`
    FOREIGN KEY (`comment_id`)
    REFERENCES `CyberThreatManagementDB`.`Comments` (`comment_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CyberThreatManagementDB`.`InfectedDevices`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CyberThreatManagementDB`.`InfectedDevices` (
  `device_id` INT NOT NULL,
  `threat_id` INT NOT NULL,
  PRIMARY KEY (`device_id`, `threat_id`),
  INDEX `fk_Threats_has_Devices_Devices1_idx` (`device_id` ASC) VISIBLE,
  INDEX `fk_Threats_has_Devices_Threats1_idx` (`threat_id` ASC) VISIBLE,
  CONSTRAINT `threats_id_fk`
    FOREIGN KEY (`threat_id`)
    REFERENCES `CyberThreatManagementDB`.`Threats` (`threat_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `device_id_fk`
    FOREIGN KEY (`device_id`)
    REFERENCES `CyberThreatManagementDB`.`Devices` (`device_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CyberThreatManagementDB`.`DeviceAttacked`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CyberThreatManagementDB`.`DeviceAttacked` (
  `actor_id` INT NOT NULL,
  `device_id` INT NOT NULL,
  PRIMARY KEY (`actor_id`, `device_id`),
  INDEX `fk_Malicious Actors_has_Devices_Devices1_idx` (`device_id` ASC) VISIBLE,
  INDEX `fk_Malicious Actors_has_Devices_Malicious Actors1_idx` (`actor_id` ASC) VISIBLE,
  CONSTRAINT `da_actor_id_fk`
    FOREIGN KEY (`actor_id`)
    REFERENCES `CyberThreatManagementDB`.`MaliciousActors` (`actor_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `da_device_id_fk`
    FOREIGN KEY (`device_id`)
    REFERENCES `CyberThreatManagementDB`.`Devices` (`device_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CyberThreatManagementDB`.`MalAttacker`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CyberThreatManagementDB`.`MalAttacker` (
  `report_id` INT NOT NULL,
  `mactor_id` INT NOT NULL,
  PRIMARY KEY (`report_id`, `mactor_id`),
  INDEX `fk_Reports_has_Malicious Actors_Malicious Actors1_idx` (`mactor_id` ASC) VISIBLE,
  INDEX `fk_Reports_has_Malicious Actors_Reports1_idx` (`report_id` ASC) VISIBLE,
  CONSTRAINT `ma_report_id_fk`
    FOREIGN KEY (`report_id`)
    REFERENCES `CyberThreatManagementDB`.`Reports` (`report_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `ma_actor_id_fk`
    FOREIGN KEY (`mactor_id`)
    REFERENCES `CyberThreatManagementDB`.`MaliciousActors` (`actor_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CyberThreatManagementDB`.`AttackersList`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CyberThreatManagementDB`.`AttackersList` (
  `vector_id` INT NOT NULL,
  `actor_id` INT NOT NULL,
  PRIMARY KEY (`vector_id`, `actor_id`),
  INDEX `fk_Attack Vectors_has_Malicious Actors_Malicious Actors1_idx` (`actor_id` ASC) VISIBLE,
  INDEX `fk_Attack Vectors_has_Malicious Actors_Attack Vectors1_idx` (`vector_id` ASC) VISIBLE,
  CONSTRAINT `vector_id_fk`
    FOREIGN KEY (`vector_id`)
    REFERENCES `CyberThreatManagementDB`.`AttackVectors` (`vector_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `mactor_id_fk`
    FOREIGN KEY (`actor_id`)
    REFERENCES `CyberThreatManagementDB`.`MaliciousActors` (`actor_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CyberThreatManagementDB`.`CampaignAttack`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CyberThreatManagementDB`.`CampaignAttack` (
  `vector_id` INT NOT NULL,
  `campaign_id` INT NOT NULL,
  PRIMARY KEY (`vector_id`, `campaign_id`),
  INDEX `fk_Attack Vectors_has_Threats Campaigns_Threats Campaigns1_idx` (`campaign_id` ASC) VISIBLE,
  INDEX `fk_Attack Vectors_has_Threats Campaigns_Attack Vectors1_idx` (`vector_id` ASC) VISIBLE,
  CONSTRAINT `ca_vector_id_fk`
    FOREIGN KEY (`vector_id`)
    REFERENCES `CyberThreatManagementDB`.`AttackVectors` (`vector_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `ca_campaign_id_fk`
    FOREIGN KEY (`campaign_id`)
    REFERENCES `CyberThreatManagementDB`.`ThreatsCampaigns` (`campaign_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CyberThreatManagementDB`.`CampaignReports`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CyberThreatManagementDB`.`CampaignReports` (
  `campaign_id` INT NOT NULL,
  `report_id` INT NOT NULL,
  PRIMARY KEY (`campaign_id`, `report_id`),
  INDEX `fk_Threats Campaigns_has_Reports_Reports1_idx` (`report_id` ASC) VISIBLE,
  INDEX `fk_Threats Campaigns_has_Reports_Threats Campaigns1_idx` (`campaign_id` ASC) VISIBLE,
  CONSTRAINT `cr_campaign_id_fk`
    FOREIGN KEY (`campaign_id`)
    REFERENCES `CyberThreatManagementDB`.`ThreatsCampaigns` (`campaign_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `cr_report_id_fk`
    FOREIGN KEY (`report_id`)
    REFERENCES `CyberThreatManagementDB`.`Reports` (`report_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CyberThreatManagementDB`.`CTThreats`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CyberThreatManagementDB`.`CTThreats` (
  `campaign_id` INT NOT NULL,
  `threat_id` INT NOT NULL,
  PRIMARY KEY (`campaign_id`, `threat_id`),
  INDEX `fk_Threats Campaigns_has_Threats_Threats1_idx` (`threat_id` ASC) VISIBLE,
  INDEX `fk_Threats Campaigns_has_Threats_Threats Campaigns1_idx` (`campaign_id` ASC) VISIBLE,
  CONSTRAINT `ct_campaign_id_fk`
    FOREIGN KEY (`campaign_id`)
    REFERENCES `CyberThreatManagementDB`.`ThreatsCampaigns` (`campaign_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `ct_threat_id_fk`
    FOREIGN KEY (`threat_id`)
    REFERENCES `CyberThreatManagementDB`.`Threats` (`threat_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CyberThreatManagementDB`.`TeamAnalyzeCampaign`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CyberThreatManagementDB`.`TeamAnalyzeCampaign` (
  `campaign_id` INT NOT NULL,
  `teams_id` INT NOT NULL,
  PRIMARY KEY (`campaign_id`, `teams_id`),
  INDEX `fk_Threats Campaigns_has_Teams_Teams1_idx` (`teams_id` ASC) VISIBLE,
  INDEX `fk_Threats Campaigns_has_Teams_Threats Campaigns1_idx` (`campaign_id` ASC) VISIBLE,
  CONSTRAINT `ta_campaign_id_fk`
    FOREIGN KEY (`campaign_id`)
    REFERENCES `CyberThreatManagementDB`.`ThreatsCampaigns` (`campaign_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `ta_teams_id_fk`
    FOREIGN KEY (`teams_id`)
    REFERENCES `CyberThreatManagementDB`.`Teams` (`team_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CyberThreatManagementDB`.`PublicForum`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CyberThreatManagementDB`.`PublicForum` (
  `pulbic_forum_id` INT NOT NULL AUTO_INCREMENT,
  `forum_id` INT NOT NULL,
  PRIMARY KEY (`pulbic_forum_id`),
  UNIQUE INDEX `pulbic_forum_id_UNIQUE` (`pulbic_forum_id` ASC) VISIBLE,
  INDEX `forum_id_fk_idx` (`forum_id` ASC) VISIBLE,
  CONSTRAINT `pubforum_id_fk`
    FOREIGN KEY (`forum_id`)
    REFERENCES `CyberThreatManagementDB`.`Forums` (`forum_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CyberThreatManagementDB`.`PrivateForum`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CyberThreatManagementDB`.`PrivateForum` (
  `private_forum_id` INT NOT NULL AUTO_INCREMENT,
  `forum_id` INT NOT NULL,
  PRIMARY KEY (`private_forum_id`),
  UNIQUE INDEX `private_forum_id_UNIQUE` (`private_forum_id` ASC) VISIBLE,
  INDEX `forum_id_fk_idx` (`forum_id` ASC) VISIBLE,
  CONSTRAINT `privforum_id_fk`
    FOREIGN KEY (`forum_id`)
    REFERENCES `CyberThreatManagementDB`.`Forums` (`forum_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CyberThreatManagementDB`.`ForumsServices`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CyberThreatManagementDB`.`ForumsServices` (
  `forum_id` INT NOT NULL,
  `service_id` INT NOT NULL,
  PRIMARY KEY (`forum_id`, `service_id`),
  INDEX `fk_Forums_has_Services_Services1_idx` (`service_id` ASC) VISIBLE,
  INDEX `fk_Forums_has_Services_Forums1_idx` (`forum_id` ASC) VISIBLE,
  CONSTRAINT `fs_forum_id_fk`
    FOREIGN KEY (`forum_id`)
    REFERENCES `CyberThreatManagementDB`.`Forums` (`forum_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fs_service_id_fk`
    FOREIGN KEY (`service_id`)
    REFERENCES `CyberThreatManagementDB`.`Services` (`services_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CyberThreatManagementDB`.`ServicesTested`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CyberThreatManagementDB`.`ServicesTested` (
  `service_id` INT NOT NULL,
  `employee_id` INT NOT NULL,
  PRIMARY KEY (`service_id`, `employee_id`),
  INDEX `fk_Services_has_Employees_Employees1_idx` (`employee_id` ASC) VISIBLE,
  INDEX `fk_Services_has_Employees_Services1_idx` (`service_id` ASC) VISIBLE,
  CONSTRAINT `st_service_id_fk`
    FOREIGN KEY (`service_id`)
    REFERENCES `CyberThreatManagementDB`.`Services` (`services_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `st_employee_id_fk`
    FOREIGN KEY (`employee_id`)
    REFERENCES `CyberThreatManagementDB`.`Employees` (`employee_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CyberThreatManagementDB`.`ForumSolutions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CyberThreatManagementDB`.`ForumSolutions` (
  `forum_id` INT NOT NULL,
  `solution_id` INT NOT NULL,
  PRIMARY KEY (`forum_id`, `solution_id`),
  INDEX `solution_id_fk_idx` (`solution_id` ASC) VISIBLE,
  CONSTRAINT `forum_sol_id_fk`
    FOREIGN KEY (`forum_id`)
    REFERENCES `CyberThreatManagementDB`.`Forums` (`forum_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fs_solution_id_fk`
    FOREIGN KEY (`solution_id`)
    REFERENCES `CyberThreatManagementDB`.`Solutions` (`solution_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CyberThreatManagementDB`.`ForumReport`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CyberThreatManagementDB`.`ForumReport` (
  `forums_id` INT NOT NULL,
  `report_id` INT NOT NULL,
  PRIMARY KEY (`forums_id`, `report_id`),
  INDEX `fk_Forums_has_Reports_Reports1_idx` (`report_id` ASC) VISIBLE,
  INDEX `fk_Forums_has_Reports_Forums1_idx` (`forums_id` ASC) VISIBLE,
  CONSTRAINT `forumRep_id_fk`
    FOREIGN KEY (`forums_id`)
    REFERENCES `CyberThreatManagementDB`.`Forums` (`forum_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `freport_report_id_fk`
    FOREIGN KEY (`report_id`)
    REFERENCES `CyberThreatManagementDB`.`Reports` (`report_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CyberThreatManagementDB`.`AdminsForumManage`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CyberThreatManagementDB`.`AdminsForumManage` (
  `admin_id` INT NULL,
  `forum_id` INT NULL,
  INDEX `fk_Administrators_has_Forums_Forums1_idx` (`forum_id` ASC) VISIBLE,
  INDEX `fk_Administrators_has_Forums_Administrators1_idx` (`admin_id` ASC) VISIBLE,
  CONSTRAINT `afm_admin_id_fk`
    FOREIGN KEY (`admin_id`)
    REFERENCES `CyberThreatManagementDB`.`Administrators` (`admin_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `afm_forum_id_fk`
    FOREIGN KEY (`forum_id`)
    REFERENCES `CyberThreatManagementDB`.`Forums` (`forum_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CyberThreatManagementDB`.`EmployeeSolutions`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CyberThreatManagementDB`.`EmployeeSolutions` (
  `employee_id` INT NOT NULL,
  `solution_id` INT NOT NULL,
  INDEX `fk_Employees_has_Solutions_Solutions1_idx` (`solution_id` ASC) VISIBLE,
  INDEX `fk_Employees_has_Solutions_Employees1_idx` (`employee_id` ASC) VISIBLE,
  CONSTRAINT `es_employee_id_fk`
    FOREIGN KEY (`employee_id`)
    REFERENCES `CyberThreatManagementDB`.`Employees` (`employee_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `es_solution_id_fk`
    FOREIGN KEY (`solution_id`)
    REFERENCES `CyberThreatManagementDB`.`Solutions` (`solution_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CyberThreatManagementDB`.`Solved`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CyberThreatManagementDB`.`Solved` (
  `solution_id` INT NOT NULL,
  `vulnerability_id` INT NULL,
  `threat_id` INT NULL,
  INDEX `solution_id_fk_idx` (`solution_id` ASC) VISIBLE,
  INDEX `vulnerability_id_fk_idx` (`vulnerability_id` ASC) VISIBLE,
  PRIMARY KEY (`solution_id`),
  INDEX `threat_id_fk_idx` (`threat_id` ASC) VISIBLE,
  CONSTRAINT `solved_sol_id_fk`
    FOREIGN KEY (`solution_id`)
    REFERENCES `CyberThreatManagementDB`.`Solutions` (`solution_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `solved_vul_id_fk`
    FOREIGN KEY (`vulnerability_id`)
    REFERENCES `CyberThreatManagementDB`.`Vulnerabilities` (`vulnerabilty_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `solved_threat_id_fk`
    FOREIGN KEY (`threat_id`)
    REFERENCES `CyberThreatManagementDB`.`Threats` (`threat_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CyberThreatManagementDB`.`AlertView`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CyberThreatManagementDB`.`AlertView` (
  `alert_id` INT NULL,
  `employee_id` INT NULL,
  `administrator_id` INT NULL,
  INDEX `alert_id_fk_idx` (`alert_id` ASC) VISIBLE,
  INDEX `employee_id_fk_idx` (`employee_id` ASC) VISIBLE,
  INDEX `admin_id_fk_idx` (`administrator_id` ASC) VISIBLE,
  CONSTRAINT `av_alert_id_fk`
    FOREIGN KEY (`alert_id`)
    REFERENCES `CyberThreatManagementDB`.`Alert` (`alert_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `av_emp_id_fk`
    FOREIGN KEY (`employee_id`)
    REFERENCES `CyberThreatManagementDB`.`Employees` (`employee_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `av_admin_id_fk`
    FOREIGN KEY (`administrator_id`)
    REFERENCES `CyberThreatManagementDB`.`Administrators` (`admin_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CyberThreatManagementDB`.`ReportAccess`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CyberThreatManagementDB`.`ReportAccess` (
  `report_id` INT NULL,
  `admin_id` INT NULL,
  `employee_id` INT NULL,
  INDEX `report_id_fk_idx` (`report_id` ASC) VISIBLE,
  INDEX `admin_id_fk_idx` (`admin_id` ASC) VISIBLE,
  INDEX `employee_id_fk_idx` (`employee_id` ASC) VISIBLE,
  CONSTRAINT `ra_report_id_fk`
    FOREIGN KEY (`report_id`)
    REFERENCES `CyberThreatManagementDB`.`Reports` (`report_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `ra_admin_id_fk`
    FOREIGN KEY (`admin_id`)
    REFERENCES `CyberThreatManagementDB`.`Administrators` (`admin_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `ra_emp_id_fk`
    FOREIGN KEY (`employee_id`)
    REFERENCES `CyberThreatManagementDB`.`Employees` (`employee_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CyberThreatManagementDB`.`AdminManageUsers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CyberThreatManagementDB`.`AdminManageUsers` (
  `admin_id` INT NULL,
  `employee_id` INT NULL,
  `registered_user_id` INT NULL,
  INDEX `admin_id_fk_idx` (`admin_id` ASC) VISIBLE,
  INDEX `employee_id_fk_idx` (`employee_id` ASC) VISIBLE,
  INDEX `registered_users_id_fk_idx` (`registered_user_id` ASC) VISIBLE,
  CONSTRAINT `am_admin_id_fk`
    FOREIGN KEY (`admin_id`)
    REFERENCES `CyberThreatManagementDB`.`Administrators` (`admin_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `am_emp_id_fk`
    FOREIGN KEY (`employee_id`)
    REFERENCES `CyberThreatManagementDB`.`Employees` (`employee_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `am_reg_id_fk`
    FOREIGN KEY (`registered_user_id`)
    REFERENCES `CyberThreatManagementDB`.`RegisteredUsers` (`registered_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CyberThreatManagementDB`.`TV_Analysis`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CyberThreatManagementDB`.`TV_Analysis` (
  `admin_id` INT NULL,
  `employee_id` INT NULL,
  `threat_id` INT NULL,
  `vulnerability_id` INT NULL,
  INDEX `admin_id_fk_idx` (`admin_id` ASC) VISIBLE,
  INDEX `employee_id_fk_idx` (`employee_id` ASC) VISIBLE,
  INDEX `threat_id_fk_idx` (`threat_id` ASC) VISIBLE,
  INDEX `vulnerability_id_fk_idx` (`vulnerability_id` ASC) VISIBLE,
  CONSTRAINT `tva_admin_id_fk`
    FOREIGN KEY (`admin_id`)
    REFERENCES `CyberThreatManagementDB`.`Administrators` (`admin_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `tva_emp_id_fk`
    FOREIGN KEY (`employee_id`)
    REFERENCES `CyberThreatManagementDB`.`Employees` (`employee_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `tva_threat_id_fk`
    FOREIGN KEY (`threat_id`)
    REFERENCES `CyberThreatManagementDB`.`Threats` (`threat_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `tva_vul_id_fk`
    FOREIGN KEY (`vulnerability_id`)
    REFERENCES `CyberThreatManagementDB`.`Vulnerabilities` (`vulnerabilty_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CyberThreatManagementDB`.`TVReportList`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CyberThreatManagementDB`.`TVReportList` (
  `report_id` INT NOT NULL,
  `threat_id` INT NULL,
  `vulnerability_id` INT NULL,
  INDEX `report_id_fk_idx` (`report_id` ASC) VISIBLE,
  INDEX `threat_id_fk_idx` (`threat_id` ASC) VISIBLE,
  INDEX `vulnerability_id_fk_idx` (`vulnerability_id` ASC) VISIBLE,
  PRIMARY KEY (`report_id`),
  CONSTRAINT `tvl_report_id_fk`
    FOREIGN KEY (`report_id`)
    REFERENCES `CyberThreatManagementDB`.`Reports` (`report_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `tvl_threat_id_fk`
    FOREIGN KEY (`threat_id`)
    REFERENCES `CyberThreatManagementDB`.`Threats` (`threat_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `tvl_vul_id_fk`
    FOREIGN KEY (`vulnerability_id`)
    REFERENCES `CyberThreatManagementDB`.`Vulnerabilities` (`vulnerabilty_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CyberThreatManagementDB`.`DMReportList`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CyberThreatManagementDB`.`DMReportList` (
  `report_id` INT NOT NULL,
  `discovery_id` INT NULL,
  INDEX `discovery_id_fk_idx` (`discovery_id` ASC) VISIBLE,
  CONSTRAINT `report_id_fk`
    FOREIGN KEY (`report_id`)
    REFERENCES `CyberThreatManagementDB`.`Reports` (`report_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `discovery_id_fk`
    FOREIGN KEY (`discovery_id`)
    REFERENCES `CyberThreatManagementDB`.`DiscoveryMethod` (`discovery_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CyberThreatManagementDB`.`DiscoverList`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CyberThreatManagementDB`.`DiscoverList` (
  `discovery_id` INT NULL,
  `threat_id` INT NULL,
  `vulnerability_id` INT NULL,
  INDEX `discovery_id_fk_idx` (`discovery_id` ASC) VISIBLE,
  INDEX `threat_id_fk_idx` (`threat_id` ASC) VISIBLE,
  INDEX `vulnerability_id_fk_idx` (`vulnerability_id` ASC) VISIBLE,
  CONSTRAINT `dl_disc_id_fk`
    FOREIGN KEY (`discovery_id`)
    REFERENCES `CyberThreatManagementDB`.`DiscoveryMethod` (`discovery_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `dl_threat_id_fk`
    FOREIGN KEY (`threat_id`)
    REFERENCES `CyberThreatManagementDB`.`Threats` (`threat_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `dl_vul_id_fk`
    FOREIGN KEY (`vulnerability_id`)
    REFERENCES `CyberThreatManagementDB`.`Vulnerabilities` (`vulnerabilty_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `CyberThreatManagementDB`.`PatternList`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `CyberThreatManagementDB`.`PatternList` (
  `pattern_id` INT NOT NULL,
  `threat_id` INT NULL,
  `vulnerability_id` INT NULL,
  INDEX `pattern_id_fk_idx` (`pattern_id` ASC) VISIBLE,
  INDEX `vulnerability_id_fk_idx` (`vulnerability_id` ASC) VISIBLE,
  INDEX `threat_id_fk_idx` (`threat_id` ASC) VISIBLE,
  CONSTRAINT `pl_pattern_id_fk`
    FOREIGN KEY (`pattern_id`)
    REFERENCES `CyberThreatManagementDB`.`Patterns` (`pattern_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `pl_threat_id_fk`
    FOREIGN KEY (`threat_id`)
    REFERENCES `CyberThreatManagementDB`.`Threats` (`threat_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE,
  CONSTRAINT `pl_vul_id_fk`
    FOREIGN KEY (`vulnerability_id`)
    REFERENCES `CyberThreatManagementDB`.`Vulnerabilities` (`vulnerabilty_id`)
    ON DELETE SET NULL
    ON UPDATE CASCADE)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
